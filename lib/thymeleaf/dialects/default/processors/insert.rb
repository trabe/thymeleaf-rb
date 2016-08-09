
class InsertProcessor

  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink

    template, fragment = parse_fragment_expr(context, attribute.value)
    
    node_subcontent = get_node_template(template, node, context)

    node.children.each {|child| child.unlink }
    
    if fragment.nil?
      # Avoid infinite loop when template is "this" and fragment is nil
      return nil if is_self_template? template
    else
      node_subcontent = get_fragment_node(fragment, context, node_subcontent)
    end

    unless node_subcontent.nil?
      node_subcontent.dup.parent = node
    end
  end

  def parse_fragment_expr(_, expr)
    md = expr.match(/\s*(?:([^\n:]+)\s*)?(?:::([^\n]+))?\s*/)
    raise ArgumentError, "Not a valid include expression" if md.nil?
    md[1..2]
  end

private
  
  def get_node_template(template, node, context)
    if is_self_template? template
      root_node node
    else
      subtemplate = parse_expression(context, template)

      get_template subtemplate do |template_file|
        Thymeleaf::Parser.new(template_file).call
      end
    end
  end

  def get_template(template_name)
    template_uri = Thymeleaf.configuration.template_uri(template_name)
    
    File.open template_uri do |template_file|
      template_file.rewind
      yield template_file.read
    end
  end
  
  def root_node(node)
    new_node = node
    until new_node.parent.nil?
      new_node = new_node.parent
    end
    new_node
  end
  
  def is_self_template?(template)
    template.nil? || (template.eql? 'this')
  end
  
  def get_fragment_node(fragment_name, context, node)
    root_context = context.root
    
    if root_context.has_private "fragment_var_#{fragment_name}"
      root_context.get_private "fragment_var_#{fragment_name}" 
    else
      node.at_css fragment_name
    end
  end
end