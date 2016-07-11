class UnlessProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **opts)
    attribute.unlink
    if parse_expression(context, attribute.value)
      node.children.each {|child| child.unlink }
      node.unlink
    end
  end
end