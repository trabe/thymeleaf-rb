require 'thymeleaf/dialects/default/parsers/dollar'
require 'thymeleaf/context/context_struct'
require 'thymeleaf/context/context_holder'

describe DollarExpression do
  
  def context
    ContextHolder.new(ContextStruct.new({:user => { :name => 'John', :surname => 'Color' } }))
  end
  
  def render_expression(expression)
    DollarExpression.parse(context, expression).to_s
  end
  
  it 'detects dollar syntax with context' do
    assert_equal render_expression('${user.name}'), 'John'
    assert_equal render_expression('${user.surname}'), 'Color'
  end
  
  it 'evaluates ruby expressions' do
    assert_equal render_expression('The result is: ${5 * 4 + 3}'), 'The result is: 23'
  end
  
  it 'detects dollar syntax in substring' do
    assert_equal render_expression('Hello, ${user.name}'), 'Hello, John'
  end
  
  it 'returns empty string on fail' do
    assert_empty render_expression('${user.inexistent}')
    assert_equal render_expression('Dear ${user.inexistent}'), 'Dear '
  end
  
  it 'works even with escaped character' do
    assert_equal render_expression('Hi, \${user.name}'), 'Hi, \\John'
  end
  
end