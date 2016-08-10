
require_relative 'selection'
require_relative 'dollar'

class EvalExpression
  
  def self.parse(context, expr, mode = nil, **args)
    text = SelectionExpression.parse(context, expr, context.get_object_var)
    DollarExpression.parse(context, text, mode)
  end
  
  def self.parse_single_expression(context, expr, **args)
    self.parse(context, expr, :single_expression)
  end
end