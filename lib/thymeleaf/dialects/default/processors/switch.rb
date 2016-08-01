class SwitchProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    condition = parse_expression(context, attribute.value)
    new_context = ContextHolder.new({}, context)
    new_context.set_private 'switch_var', condition

    attribute.unlink
    new_context
  end
  
  def has_subcontext?
    true
  end

end