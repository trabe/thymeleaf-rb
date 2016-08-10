class UTextProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    node.inner_html = EvalExpression.parse(context, attribute.value)
    attribute.unlink
  end
end