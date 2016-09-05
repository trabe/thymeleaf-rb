require_relative '../../../utils/booleanize'

class RemoveProcessor

  include Thymeleaf::Processor
  
  REMOVE_ALL           = 'all'
  REMOVE_BODY          = 'body'
  REMOVE_TAG           = 'tag'
  REMOVE_ALL_BUT_FIRST = 'all-but-first'
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
    skip_first(node.children) do |child|
      child.unlink
    end
  end
  
  def remove_none(_, _)
  end
  
  def empty_node?(node)
    node.to_s.strip.empty?
  end
  
  def skip_first(node_set)
    i = 0
    node_set.each do |child|
      if i > 0
        yield child
      else
        i += 1 unless empty_node? child
      end
    end
  end
end