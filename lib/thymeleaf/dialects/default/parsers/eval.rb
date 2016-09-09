
require_relative 'selection'
require_relative 'dollar'

class EvalExpression
  
  def self.parse(context, expr, mode = nil, **_)
    text = SelectionExpression.parse(context, expr, context.get_private(DefaultDialect::CONTEXT_OBJECT_VAR))
    DollarExpression.parse(context, text, mode)
  end
  
  def self.parse_single_expression(context, expr, **_)
    self.parse(context, expr, :single_expression)
  end
end