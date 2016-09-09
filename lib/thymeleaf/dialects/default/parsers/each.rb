# Matches:
# "item, stat : ${iterator}",
# "item : ${iterator}" or
# "${iterator}"
class EachExpression
  
  def self.parse(context, expr, **args)
    md = expr.match(/\s*(?:([^\n,]+?)\s*(?:,\s*([^\n,]*?))?\s*:\s*)?\${(.+?)}/)
    raise ArgumentError, "Not a valid each expression" if md.nil?
    md[1..3]
  end
end