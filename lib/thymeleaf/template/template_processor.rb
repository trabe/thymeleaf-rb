
module Thymeleaf

  class TemplateProcessor
    def call(parsed_template, context_holder)
      process_node(context_holder, parsed_template)
      parsed_template
    end

  private
    def process_node(context_holder, node)
      children_context = process_attributes(context_holder, node)
      
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
      key, processor = * dialects.find_processor(attribute_key)
      
      subcontext = processor.call(key: key, node: node, attribute: attribute, context: context_holder)
      
      if processor_has_subcontext?(processor)
        subcontext
      else
        context_holder
      end
    end
    
  private
    def processor_has_subcontext?(processor)
      processor.respond_to?(:has_subcontext?) && processor.has_subcontext? == true
    end
  end

end