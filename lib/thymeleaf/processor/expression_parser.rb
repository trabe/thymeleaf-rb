
class ExpressionParser
  def initialize(context)
    self.context = context
  end

  def parse(expr)
    expr.gsub(/(\${.+?})/) do |match|
      ContextEvaluator.new(context).evaluate(match[2..-2])
    end
  end

private
  attr_accessor :context
end