
module Thymeleaf

  class TemplateEngine
    def call(parsed_template, context_holder)
      process_node(context_holder, parsed_template)
      parsed_template
    end

  private
    def process_node(context_holder, node)
      attr_context = process_attributes(context_holder, node)
      children_context = process_tag(attr_context, node)
      
      # TODO: Processing all nodes. Maybe filtering by only-thymeleaf nodes can give better performance?
      node.children.each {|child| process_node(children_context, child)}
    end

    def process_attributes(context_holder, node)
      attr_context = context_holder
      node.attributes.each do |attribute_key, attribute|
        attr_context = process_attribute(attr_context, node, attribute_key, attribute)
      end
      attr_context
    end

    def process_attribute(context_holder, node, attribute_key, attribute)
      # TODO: Find all proccessors. Apply in precedence order!
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_attr_processor(attribute_key)
      
      process_element(context_holder, node, attribute, key, processor)
    end
    
    def process_tag(context_holder, node)
      dialects = Thymeleaf.configuration.dialects
      key, processor = * dialects.find_tag_processor(node.name)

      process_element(context_holder, node, nil, key, processor)
    end
    
    def processor_has_subcontext?(processor)
      processor.respond_to?(:has_subcontext?) && processor.has_subcontext?
    end
    
    def process_element(context_holder, node, attribute, key, processor)
      subcontext = processor.call(key: key, node: node, attribute: attribute, context: context_holder)

      if processor_has_subcontext?(processor)
        subcontext
      else
        context_holder
      end
    end
  end
end