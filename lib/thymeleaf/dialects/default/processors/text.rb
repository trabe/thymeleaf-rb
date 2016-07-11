class TextProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **opts)
    node.content = parse_expression(context, attribute.value)
    attribute.unlink
  end
end