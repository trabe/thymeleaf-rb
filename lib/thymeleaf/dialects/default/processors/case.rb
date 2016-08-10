
class CaseProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink
    
    var_cmp = EvalExpression.parse(context, attribute.value)

    unless case_equals? context, var_cmp
      node.children.each { |child| child.unlink }
      node.unlink
    end
    
  end
  
  def case_equals?(context, var_comparation)
    (context.has_private DefaultDialect::CONTEXT_SWITCH_VAR) &&
        (context.get_private DefaultDialect::CONTEXT_SWITCH_VAR).eql?(var_comparation)
  end
  
  
end