
require_relative 'dialects'
require_relative 'dialects/default/default_dialect'
require_relative 'template/template_resolver'

module Thymeleaf

  class << self
    attr_accessor :configuration
  end

  # TODO: Replace accessor with getter/setter?

  def self.configure(&block)
    self.configuration ||= Configuration.new
    block.call configuration if block_given?
  end

  class Configuration

    attr_accessor :dialects, :template

    def initialize
      self.dialects = Dialects.new
      self.template = TemplateResolver.new
      add_dialect DefaultDialect
    end

    def add_dialect(*args)
      dialects.add_dialect(*args)
    end
    
    def template_uri(name)
      template.get_template(name)
    end

  end

end