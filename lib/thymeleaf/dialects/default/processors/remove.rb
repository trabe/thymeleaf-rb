require_relative '../../../utils/booleanize'

class RemoveProcessor

  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink
    
    expr = parse_expression(context, attribute.value)
    
    method = case expr
               when 'all'
                 :remove_all
               when 'body'
                 :remove_body
               when 'tag'
                 :remove_tag
               when 'but-all-first'
                 :remove_allbutfirst
               when 'none'
                 :remove_none
               else
                 if booleanize expr
                   :remove_all
                 else
                   :remove_none
                 end
               end
    
    send(method, node)
  end
  
  def remove_all(node)
    node.children.each do |child|
      child.unlink
    end
    node.unlink
  end
  
  def remove_body(node)
    node.children.each do |child|
      child.unlink
    end
  end
  
  def remove_tag(node)
    node.children.reverse.each do |child|
      node.add_next_sibling child
    end
    node.unlink
  end
  
  def remove_allbutfirst(node)
    node.children.drop(1).each do |child|
      child.unlink
    end
  end
  
  def remove_none(_)
  end
end