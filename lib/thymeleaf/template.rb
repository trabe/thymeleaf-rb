
require_relative 'processor'

module Thymeleaf
  
  require_relative 'context/context_holder'

  class Template < Struct.new(:template_markup, :context)
    def render
      do_render template_markup
    end
    
    def render_file
      template_markup_uri = Thymeleaf.configuration.template_uri(template_markup)
      
      template_file_open template_markup_uri do |template|
        do_render template
      end
    end
  
  private
    def do_render(template)
      parsed_template = Parser.new(template).call
      context_holder = ContextHolder.new(context)
      TemplateEngine.new.call(parsed_template, context_holder).to_s
    end
    
    def template_file_open(template_file)
      File.open template_file do |template|
        template.rewind
        yield template.read
      end
    end
  end
end