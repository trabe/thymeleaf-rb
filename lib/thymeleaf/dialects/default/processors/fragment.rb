class FragmentProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    fragment_name = EvalExpression.parse(context, attribute.value)
    
    context.root.set_private DefaultDialect::context_fragment_var(fragment_name), node

    attribute.unlink
  end

end