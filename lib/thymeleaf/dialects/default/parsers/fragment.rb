class FragmentExpression
  def self.parse(context, expr, **args)
    md = expr.match(/\s*(?:([^\n:]+)\s*)?(?:::([^\n]+))?\s*/)
    raise ArgumentError, "Not a valid include expression" if md.nil?
    md[1..2]
  end
end