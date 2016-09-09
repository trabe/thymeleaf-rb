require_relative '../../../utils/booleanize'

class ObjectProcessor

  include Thymeleaf::Processor

  def call(attribute:nil, context:nil, **_)
    attribute.unlink

    obj_var = EvalExpression.parse_single_expression(context, attribute.value)
    new_context = ContextHolder.new({}, context)
    new_context.set_private(DefaultDialect::CONTEXT_OBJECT_VAR, obj_var)

    attribute.unlink
    new_context
  end

  def has_subcontext?
    true
  end
end