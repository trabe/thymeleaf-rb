class DefaultProcessor
  include Thymeleaf::Processor

  def call(key:nil, node:nil, attribute:nil, context:nil)
    node[key] = EvalExpression.parse(context, attribute.value)
    attribute.unlink
  end
end
