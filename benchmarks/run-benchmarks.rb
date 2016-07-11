#!/usr/bin/env ruby

require_relative '../lib/thymeleaf-test'
require_relative 'suite'
require_relative 'test_runners/erb'
require_relative 'test_runners/th'

require 'benchmark/ips'
require 'awesome_print'


# TODO: See benchmark graphs (util)
# TODO: Save previous benchmarks on files to compare performance

ap "[PERF] -----------------------------"

ThymeleafTest::TestDir::find_erb do |testfile|

  bench_name = testfile.test_name(:add_uniqueid)
  suite = ThymeleafBenchSuite.new

  ap "[Bench:#{bench_name}] -----------------------------"

  # Pit Th against other template solutions. Also compare speed/memory performance against a baseline
  Benchmark.ips do |b|
    b.config(suite: suite, time: 2, warmup: 1)
    b.report("thymeleaf.rb") { ThTestRunner::render(testfile)  }
    b.report("ERB")          { ErbTestRunner::render(testfile) }
    b.compare!
  end

end
