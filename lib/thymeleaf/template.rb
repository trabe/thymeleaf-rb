
require_relative 'template/template_processor'

module Thymeleaf

  require_relative 'context/context_holder'

  class Template < Struct.new(:template_markup, :context)
    def render
      template_markup_uri = Thymeleaf.configuration.template_uri(template_markup)
      do_render template_markup_uri
    end
    
    def render_file
      template_markup_uri = Thymeleaf.configuration.template_uri(template_markup)
      
      File.open template_markup_uri do |template|
        template.rewind
        do_render template.read
      end
    end
  
  private
    def do_render(template)
      parsed_template = Parser.new(template).call
      context_holder = ContextHolder.new(context)
      TemplateProcessor.new.call(parsed_template, context_holder)
    end
  end
end