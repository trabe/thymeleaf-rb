require 'thymeleaf'

require_relative '../../../test_helper'
require_relative 'hello_dialect'

class RegisterDialectTest < TestThymeleaf

  def template_content
    '<p data-say-hello="">Good bye</p>'
  end

  def template_result
    '<p>Hello</p>'
  end

  def test_register_dialect
    Thymeleaf.configure do |config|
      config.add_dialect ExampleDialect
    end
    assert_equal render(template_content, {}), template_result
  end

end