
class SelectionExpression
  
  # Parse asterisk *{...} syntax (object selection)
  def self.parse(context, expr, obj_var, **args)
    expr.gsub(/(\*{.+?})/) do |match|
      if obj_var.nil?
        "${#{match[2..-2]}}"
      else
        ContextEvaluator.new(ContextHolder.new obj_var).evaluate(match[2..-2])
      end
    end
  end
  
end