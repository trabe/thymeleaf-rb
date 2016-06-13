$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require_relative 'test_helper'
require 'thymeleaf'
require 'find'
require 'nokogiri'
require 'yaml'
require 'pathname'

class TestRenderThymeleaf < TestThymeleaf
  # Avoid collisions between method names
  @test_number = 1

  def self.add_test name, &block
    define_method "test_render_#{name}_#{@test_number}", &block
    @test_number += 1
  end

end


Find.find('.') do |path|
  if path =~ /.*\.th.xml$/
    doc = Nokogiri::XML(File.open(path))

    context = eval(doc.xpath('//test//context').first.to_s.sub('<context>', '').sub('</context>', ''))
    source = doc.xpath('//test//template//*').first.to_s
    expected = doc.xpath('//test//expected//*').first.to_s

  elsif path =~ /.*\.th.test$/
    parts = File.open(path).read.split("---\n")

    index = 0
    index = 1 if parts.count > 3 && parts[0].empty?

    context = YAML.load(parts[index])
    source = parts[index + 1]
    expected = parts[index + 2]
  else
    next
  end

  test_name = path.to_s.scan(/.*test_([a-zA-Z0-9]+)\.th.*$/)[0][0].to_s

  TestRenderThymeleaf.add_test test_name do
    assert_html_page(expected, source, context)
  end

end
