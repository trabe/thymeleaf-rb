class FragmentProcessor
  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    fragment_name = parse_expression(context, attribute.value)
    
    context.root.set_private "fragment_var_#{fragment_name}", node

    attribute.unlink
  end

end