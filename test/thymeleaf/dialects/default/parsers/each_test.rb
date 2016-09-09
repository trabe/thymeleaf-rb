require 'thymeleaf/dialects/default/parsers/each'
require 'thymeleaf/context/context_struct'
require 'thymeleaf/context/context_holder'

describe EachExpression do

  def context
    iterable = [ {:name => 'Banana'}, {:name => 'Apple'}, {:name => 'Orange'}, {:name => ''} ]
    ContextHolder.new(ContextStruct.new({:products => iterable}))
  end

  def render_expression(expression)
    EachExpression.parse(context, expression)
  end

  it 'detects standard usage: iterator : ${iterable}' do
    assert_equal render_expression('product : ${all_products}'), ['product', nil, 'all_products']
  end

  it 'detects complete usage: iterator, stat : ${iterable}' do
    assert_equal render_expression('product, stat : ${all_products}'), ['product', 'stat', 'all_products']
  end

  it 'detects simple usage: ${iterable}' do
    assert_equal render_expression('${all_products}'), [nil, nil, 'all_products']
  end

  it 'detects synamic iterable values: iterator : ${iterable}' do
    assert_equal render_expression('number : ${[1,2,3,4]}'), ['number', nil, '[1,2,3,4]']
  end
  

end