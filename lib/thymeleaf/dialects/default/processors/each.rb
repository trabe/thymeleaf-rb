class EachProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **opts)
    variable, enumerable = parse_each_expr(context, attribute.value)

    # This is shit!
    subproccesor = Thymeleaf::TemplateProcessor.new

    attribute.unlink

    evaluate_in_context(context,enumerable).reverse.each do |element|
      subcontext = ContextHolder.new({variable => element}, context)
      new_node = node.dup
      subproccesor.send(:process_node, subcontext, new_node)
      node.add_next_sibling(new_node)
    end

    node.children.each {|child| child.unlink }
    node.unlink
  end

  private

  def parse_each_expr(context, expr)
    md = expr.match(/\s*(.+?)\s*:\s*\${(.+?)}/)
    raise ArgumentError, "Not a valid each expression" if md.nil?
    md[1..2]
  end

end