
class InsertProcessor

  include Thymeleaf::Processor
  
  require_relative '../parsers/fragment'

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
      node_subcontent.dup.parent = node
    end
  end


private
  
  def get_node_template(template, node, context)
    if is_self_template? template
      root_node node
    else
      subtemplate = EvalExpression.parse(context, template)

      load_template subtemplate do |template_file|
        Thymeleaf::Parser.new(template_file).call
      end
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
    
    if root_context.has_private DefaultDialect::context_fragment_var(fragment_name)
      root_context.get_private DefaultDialect::context_fragment_var(fragment_name)
    else
      node.at_css fragment_name
    end
  end
end