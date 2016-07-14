
module Thymeleaf

  class TemplateProcessor
    def call(parsed_template, context_holder)
      process_node(context_holder, parsed_template)
      parsed_template
    end

  private
    def process_node(context_holder, node)
      process_attributes(context_holder, node)
      node.children.each {|child| process_node(context_holder, child)}
    end

    def process_attributes(context_holder, node)
      node.attributes.each do |attribute_key, attribute|
        process_attribute(context_holder, node, attribute_key, attribute)
      end
    end

    def process_attribute(context_holder, node, attribute_key, attribute)
      # TODO: Find all proccessors. Apply in precedence order!
      dialects = Thymeleaf.configuration.dialects

      key, processor = * dialects.find_processor(attribute_key)
      processor.call(key: key, node: node, attribute: attribute, context: context_holder)
    end
  end

end