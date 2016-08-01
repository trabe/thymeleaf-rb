class UTextProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    node.inner_html = parse_expression(context, attribute.value)
    attribute.unlink
  end
end