require_relative '../../../utils/booleanize'

class UnlessProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink
    if booleanize parse_expression(context, attribute.value)
      node.children.each {|child| child.unlink }
      node.unlink
    end
  end
end