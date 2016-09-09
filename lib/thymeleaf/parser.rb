
require 'nokogiri'

module Thymeleaf

  class Parser < Struct.new(:template_markup)
    def call
      Nokogiri::HTML::fragment(template_markup, Thymeleaf.configuration.parser.encoding)
    end
  end

end