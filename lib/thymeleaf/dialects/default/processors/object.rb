require_relative '../../../utils/booleanize'

class ObjectProcessor

  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink

    obj_var = parse_expression_variable(context, attribute.value)
    new_context = ContextHolder.new({}, context)
    new_context.set_object_var obj_var

    attribute.unlink
    new_context
  end

  def has_subcontext?
    true
  end
end