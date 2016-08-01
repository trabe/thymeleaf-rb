
class ExpressionParser
  def initialize(context)
    self.context = context
  end

  def parse(expr, mode = nil)
    text = parse_asterisk_syntax(expr, get_object_var)
    parse_dollar_syntax(text, mode)
  end
  
private
  
  attr_accessor :context
  
  def get_object_var
    context.get_object_var
  end
  
  # Parse asterisk *{...} syntax (object selection)
  def parse_asterisk_syntax(expr, obj_var)
    expr.gsub(/(\*{.+?})/) do |match|
      if obj_var.nil?
        "${#{match[2..-2]}}"
      else
        ContextEvaluator.new(ContextHolder.new obj_var).evaluate(match[2..-2])
      end
    end
  end
  
  # Parse dollar ${...} syntax
  def parse_dollar_syntax(expr, mode = nil)
    expr.gsub(/(\${.+?})/) do |match|
      conv = ContextEvaluator.new(context).evaluate(match[2..-2])
      if mode.eql? :single_expression
        return conv
      end
      conv
    end
  end
end