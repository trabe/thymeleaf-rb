
require_relative 'context_struct'

class ContextHolder < Struct.new(:context, :parent_context)

  def initialize(context, parent_context = nil)
    if context.is_a? Hash
      super(ContextStruct.new(context), parent_context)
    else
      super(context, parent_context)
    end
  end

  def evaluate(expr)
    instance_eval(expr.to_s)
  end

  def method_missing(m, *args)
    if context.respond_to? m
      context.send(m, *args)
    elsif !parent_context.nil?
      parent_context.send(m, *args)
    end
  end
  
  def root
    if parent_context.nil?
      context
    else
      parent_context.root
    end
  end
  
end