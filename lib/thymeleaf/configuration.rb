
require_relative 'dialects/dialects'
require_relative 'dialects/default/default_dialect'

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

    attr_accessor :dialects

    def initialize
      self.dialects = Dialects.new
      add_dialect DefaultDialect
    end

    def add_dialect(*args)
      dialects.add_dialect *args
    end

  end

end