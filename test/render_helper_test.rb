$LOAD_PATH.unshift File.expand_path('../lib', __FILE__),
                   File.expand_path('./lib', __FILE__)

require_relative 'test_helper'
require 'thymeleaf-test'

class TestRenderThymeleaf < TestThymeleaf

  def self.add_test name, &block
    define_method "test_render_#{name}", &block
  end
end


ThymeleafTest::TestDir::find_erb do |testfile|

  test_name = testfile.test_name(true)

  TestRenderThymeleaf.add_test test_name do
    assert_html_page(testfile.expected_fragment, testfile.th_template, testfile.context)
  end

end
