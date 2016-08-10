require_relative '../../../utils/booleanize'

class RemoveProcessor

  include Thymeleaf::Processor
  
  REMOVE_ALL           = 'all'
  REMOVE_BODY          = 'body'
  REMOVE_TAG           = 'tag'
  REMOVE_ALL_BUT_FIRST = 'but-all-first'
  REMOVE_NONE          = 'none'

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink
    
    expr = EvalExpression.parse(context, attribute.value)
    
    method = case expr
               when REMOVE_ALL
                 :remove_all
               when REMOVE_BODY
                 :remove_body
               when REMOVE_TAG
                 :remove_tag
               when REMOVE_ALL_BUT_FIRST
                 :remove_allbutfirst
               when REMOVE_NONE
                 :remove_none
               else
                 if booleanize expr
                   :remove_all
                 else
                   :remove_none
                 end
               end
    
    send(method, node, context)
  end
  
private
  def remove_all(node, _)
    node.children.each do |child|
      child.unlink
    end
    node.unlink
  end
  
  def remove_body(node, _)
    node.children.each do |child|
      child.unlink
    end
  end
  
  def remove_tag(node, context)
    node.children.reverse.each do |child|
      subprocess_node(context, child)
      node.add_next_sibling child
    end
    node.unlink
  end
  
  def remove_allbutfirst(node, _)
    node.children.drop(1).each do |child|
      child.unlink
    end
  end
  
  def remove_none(_, _)
  end
end