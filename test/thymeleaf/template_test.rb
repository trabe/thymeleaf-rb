
require_relative '../test_helper'

class TemplateTest < TestThymeleaf
  
  def template_content
    '<p data-th-text="Hello, ${user}">Hello, world</p>'
  end
  
  def template_result
    '<p>Hello, John</p>'
  end
  
  def test_template_render
    assert_equal render(template_content, { :user => 'John' }), template_result
  end

end