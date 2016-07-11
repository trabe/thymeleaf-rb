class IfProcessor
  include Thymeleaf::Processor
  def call(node:nil, attribute:nil, context:nil, **opts)
    attribute.unlink
    unless parse_expression(context, attribute.value)
      node.unlink
    end
  end
end