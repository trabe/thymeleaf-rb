
require_relative 'template_processor'

module Thymeleaf

  require_relative 'context_holder'

  class Template < Struct.new(:template_markup, :context)
    def render
      Thymeleaf.configure
      parsed_template = Parser.new(template_markup).call
      context_holder = ContextHolder.new(context)
      TemplateProcessor.new.call(parsed_template, context_holder)
    end
  end
end