#!/usr/bin/env ruby

require_relative '../lib/thymeleaf'
require_relative 'context'
require 'erb'
require 'benchmark/ips'
require 'ostruct'
require 'awesome_print'

test_template = File.read(File.dirname(__FILE__) + '/template.th')
erb_template = File.read(File.dirname(__FILE__) + '/template.erb')
test_context = (Context.new).items

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
    def call(node:, attribute:, **opts)
      attribute.unlink
    end
  end
end


Thymeleaf.configure do |configuration|
  configuration.add_dialect 'cache', RailsCacheDialect
end

test_binding = OpenStruct.new(test_context).instance_eval { binding }


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

suite = GCSuite.new

ap "[PERF] -----------------------------"

# Pit Th against other template solutions. Also compare speed/memory performance against a baseline

Benchmark.ips do |b|
  b.config(suite: suite, time: 2, warmup: 1)
  b.report("thymeleaf.rb") { Thymeleaf::Template.new(test_template, test_context).render }
  b.report("ERB")          { ERB.new(erb_template).result(test_binding) }
  b.compare!
end
