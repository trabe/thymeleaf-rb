require 'nokogiri'
require 'awesome_print'

module Thymeleaf

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
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



  class Dialects
    def initialize
      self.registered_dialects = {}
      self.registered_processors = {}
    end

    def add_dialect(*args)
      key, dialect_class = * if args.length == 1
        [ args[0].default_key, args[0] ]
      elsif args.length == 2
        args
      else
        raise ArgumentError
      end

      dialect = dialect_class.new

      registered_dialects[key] = dialect
      registered_processors[key] = dialect_processors(dialect)
    end

    def find_processor(key)
      match = dialect_matchers.match(key)

      # TODO: check performance null object vs null check
      return [key, null_procesor] if match.nil?

      dialect_key, processor_key = *match[1..2]

      dialect_processors = registered_processors[dialect_key]
      raise ArgumentError, "No dialect found for key #{key}" if dialect_processors.nil?

      processor = dialect_processors[processor_key] || dialect_processors['default']
      raise ArgumentError, "No processor found for key #{key}" if processor.nil?

      [processor_key, processor]
    end

  private

    attr_accessor :registered_dialects, :registered_processors

    def dialect_matchers
      /^data-(#{registered_dialects.keys.join("|")})-(.*)$/
    end

    def null_procesor
      @null_prccesor ||= NullProcessor.new
    end

    def dialect_processors(dialect)
      dialect.processors.reduce({}) do |processors, (processor_key, processor)|
        processors[processor_key.to_s] = processor.new
        processors
      end
    end
  end

  class NullProcessor
    def call(**opts)
    end
  end


  class Parser < Struct.new(:template_markup)
    def call
      Nokogiri::HTML(template_markup)
    end
  end


  class TemplateProcessor
    def call(parsed_template, context_holder)
      process_node(parsed_template.root)
      parsed_template
    end

  private

    def process_node(node)
      process_attributes(node)
      node.children.each {|child| process_node(child)}
    end

    def process_attributes(node)
      node.attributes.each do |attribute_key, attribute|
        # TODO: Find all proccessors. Apply in precedence order!
        key, processor = * Thymeleaf.configuration.dialects.find_processor(attribute_key)
        ap [key, processor]
        processor.call(key: key, node: node, attribute: attribute)
      end
    end
  end




  class ContextHolder < Struct.new(:context)
  end



  class Template < Struct.new(:template_markup, :context)
    def render
      parsed_template = Parser.new(template_markup).call
      context_holder = ContextHolder.new(context)
      TemplateProcessor.new.call(parsed_template, context_holder)
    end
  end


  class DefaultDialect

    def self.default_key
      'th'
    end

    def processors
      {
        text: TextProcessor,
        each: EachProcessor,
        default: DefaultProcessor
      }
    end

    class DefaultProcessor
      def call(key:, node:, attribute:)
        ap ["default", key, node, attribute]
        node[key] = [node[key], attribute.value].compact.join(' ')
        attribute.unlink
      end
    end

    class TextProcessor
      def call(node:, attribute:, **opts)
        node.content = attribute.value
        attribute.unlink
      end
    end

    class EachProcessor
      def call(attribute:, **opts)
        ap ["each"]
        attribute.unlink
      end
    end
  end
end



# Let's see some output!

test_template = <<-TH
<!DOCCTYPE html>
<html>
  <head>
    <title data-th-text="${title}">Title placeholder</title>
    <meta charset=UTF-8" />
  </head>

  <tbody>
    <span data-cache-fetch="cache_key">
    <tr data-th-each="product : ${products}">
      <td data-th-text="${product.name}" data-th-class="fair" class="label">Oranges</td>
      <td data-th-text="${product.price}" data-th-class="value">0.99</td>
    </tr>
  </tbody>
</html>
TH

test_context = {
}

class RailsCacheDialect

  def default_key
    'rails-cache'
  end

  def processors
    {
      fetch: FetchProccessor
    }
  end

  class FetchProccessor
    def call(node:, attribute:, **opts)
      ap ["text-processor", node, attribute]
    end
  end
end


Thymeleaf.configure do |configuration|
  configuration.add_dialect 'cache', RailsCacheDialect
end

ap Thymeleaf.configuration.dialects
ap Thymeleaf::Template.new(test_template, test_context).render
