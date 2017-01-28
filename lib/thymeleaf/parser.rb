
require 'nokogiri'

module Thymeleaf

  class Parser < Struct.new(:template_markup)
    def call
      if(template_markup.start_with?('<!DOCTYPE', '<html'))
        Nokogiri::HTML(template_markup, Thymeleaf.configuration.parser.encoding)
      else
        Nokogiri::HTML::fragment(template_markup, Thymeleaf.configuration.parser.encoding)
      end
    end
  end

end
