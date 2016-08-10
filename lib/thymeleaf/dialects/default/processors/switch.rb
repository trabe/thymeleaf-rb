class SwitchProcessor
  include Thymeleaf::Processor

  def call(attribute:nil, context:nil, **_)
    condition = EvalExpression.parse(context, attribute.value)
    new_context = ContextHolder.new({}, context)
    new_context.set_private DefaultDialect::CONTEXT_SWITCH_VAR, condition

    attribute.unlink
    new_context
  end
  
  def has_subcontext?
    true
  end

end