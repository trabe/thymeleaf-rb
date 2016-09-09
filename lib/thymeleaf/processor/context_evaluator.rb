
class ContextEvaluator
  def initialize(context)
    self.context = context
  end

  def evaluate(expr)
    context.evaluate(expr)
  end

private
  attr_accessor :context
end