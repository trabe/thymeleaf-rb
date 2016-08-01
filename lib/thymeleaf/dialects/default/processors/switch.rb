class SwitchProcessor
  include Thymeleaf::Processor

  def call(_:nil, attribute:nil, context:nil, **_)
    attribute.unlink

    condition = parse_expression(context, attribute.value)
    new_context = ContextHolder.new({}, context)
    new_context.set_private 'switch_var', condition
    
    new_context
  end
  
  def has_subcontext?
    true
  end

end