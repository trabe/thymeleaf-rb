
class DollarExpression
  def self.parse(context, expr, mode = nil, **args)
    expr.gsub(/(\${.+?})/) do |match|
      conv = ContextEvaluator.new(context).evaluate(match[2..-2])
      if mode.eql? :single_expression
        return conv
      end
      conv
    end
  end
end