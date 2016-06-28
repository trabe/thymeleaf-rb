#!/usr/bin/env ruby

require_relative '../lib/thymeleaf'
require 'erb'
require 'benchmark/ips'
require 'ostruct'
require 'awesome_print'
require 'find'
require 'yaml'
require 'pathname'

class RailsCacheDialect

  def default_key
    'rails-cache'
  end

  def processors
    {
        fetch: FetchProccessor
    }
  end

  class FetchProccessor
    def call(node:nil, attribute:nil, **opts)
      attribute.unlink
    end
  end
end


Thymeleaf.configure do |configuration|
  configuration.add_dialect 'cache', RailsCacheDialect
end


class GCSuite
  def warming(*)
    run_gc
  end

  def running(*)
    run_gc
  end

  def warmup_stats(*)
  end

  def add_report(*)
  end

  private

  def run_gc
    GC.enable
    GC.start
    GC.disable
  end
end


ap "[PERF] -----------------------------"

Find.find('.') do |path|
  if path =~ /.*\.th.bench/
    parts = File.open(path).read.split("---\n")

    index = 0
    index = 1 if parts.count > 3 && parts[0].empty?

    bench_context = YAML.load(parts[index])
    test_template = parts[index + 1]
    erb_template = parts[index + 2]
  else
    next
  end

  new_bench_context = {}

  # Convert hashes to OpenStructs (limited to 2 depth levels)
  bench_context.each do |key, content|
    if content.is_a? Hash
      new_bench_context[key] = OpenStruct.new content
    elsif content.is_a? Array
      ncn = []
      content.each do |cnt|
        if cnt.is_a? Hash
          ncn.push OpenStruct.new cnt
        else
          ncn.push cnt
        end
      end
      new_bench_context[key] = ncn
    else
      new_bench_context[key] = content
    end
  end

  bench_name = path.to_s.scan(/.([a-zA-Z0-9]+)\.th.bench$/)[0][0].to_s
  test_binding = OpenStruct.new(new_bench_context).instance_eval { binding }
  suite = GCSuite.new

  ap "[Bench-#{bench_name}] -----------------------------"

  # Pit Th against other template solutions. Also compare speed/memory performance against a baseline
  Benchmark.ips do |b|
    b.config(suite: suite, time: 2, warmup: 1)
    b.report("thymeleaf.rb") { Thymeleaf::Template.new(test_template, new_bench_context).render }
    b.report("ERB")          { ERB.new(erb_template).result(test_binding) }
    b.compare!
  end

end
