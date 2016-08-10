
class TextProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    node.content = EvalExpression.parse(context, attribute.value)
    attribute.unlink
  end
end