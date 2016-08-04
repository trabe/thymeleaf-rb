
class IncludeProcessor

  include Thymeleaf::Processor

  def call(node:nil, attribute:nil, context:nil, **_)
    attribute.unlink

    subtemplate = parse_expression(context, attribute.value)
    
    get_template subtemplate do |template_file|
      node_subcontent = Thymeleaf::Parser.new(template_file).call
      
      node.children.each {|child| child.unlink }
      node_subcontent.parent = node
    end
  end

  def get_template(template_name)
    template_uri = Thymeleaf.configuration.template_uri(template_name)
    
    File.open template_uri do |template_file|
      template_file.rewind
      yield template_file.read
    end
  end
end