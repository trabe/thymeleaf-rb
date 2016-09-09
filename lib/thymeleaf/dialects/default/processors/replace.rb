
require_relative 'insert'

class ReplaceProcessor < InsertProcessor

  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)

    attribute.unlink

    template, fragment = FragmentExpression.parse(context, attribute.value)

    node_subcontent = get_node_template(template, node, context)

    node.children.each {|child| child.unlink }

    if fragment.nil?
      # Avoid infinite loop when template is "this" and fragment is nil
      return nil if is_self_template? template
    else
      node_subcontent = get_fragment_node(fragment, context, node_subcontent)
    end

    unless node_subcontent.nil?
      node_subcontent = node_subcontent.dup
      subprocess_node(context, node_subcontent)

      node.replace node_subcontent
    end
  end
  
end
