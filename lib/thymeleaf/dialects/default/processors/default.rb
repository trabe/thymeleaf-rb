class DefaultProcessor
  include Thymeleaf::Processor

  def call(key:nil, node:nil, attribute:nil, context:nil)
    node[key] = [node[key], EvalExpression.parse(context, attribute.value)].compact.join(' ')
    attribute.unlink
  end
end