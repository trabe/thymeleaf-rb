require 'nokogiri'

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
      Nokogiri::HTML::fragment(template_markup)
    end
  end




  class TemplateProcessor
    def call(parsed_template, context_holder)
      process_node(context_holder, parsed_template)
      parsed_template
    end

    private

    def process_node(context_holder, node)
      process_attributes(context_holder, node)
      node.children.each {|child| process_node(context_holder, child)}
    end

    def process_attributes(context_holder, node)
      node.attributes.each do |attribute_key, attribute|
        process_attribute(context_holder, node, attribute_key, attribute)
      end
    end

    def process_attribute(context_holder, node, attribute_key, attribute)
      # TODO: Find all proccessors. Apply in precedence order!
      key, processor = * Thymeleaf.configuration.dialects.find_processor(attribute_key)
      processor.call(key: key, node: node, attribute: attribute, context: context_holder)
    end
  end



  class ContextHolder < Struct.new(:context, :parent_context)

    def initialize(context, parent_context = nil)
      if context.is_a? Hash
        super(OpenStruct.new(context), parent_context)
      else
        super(context, parent_context)
      end
    end

    def evaluate(expr)
      instance_eval(expr)
    end

    def method_missing(m, *args)
      if context.respond_to? m
        context.send(m, *args)
      elsif !parent_context.nil?
        parent_context.send(m, *args)
      end
    end
  end



  class Template < Struct.new(:template_markup, :context)
    def render
      parsed_template = Parser.new(template_markup).call
      context_holder = ContextHolder.new(context)
      TemplateProcessor.new.call(parsed_template, context_holder)
    end
  end

  module Processor

    class ExpressionParser
      def initialize(context)
        self.context = context
      end

      def parse(expr)
        expr.gsub(/(\${.+?})/) do |match|
          ContextEvaluator.new(context).evaluate(match[2..-2])
        end
      end

      private
      attr_accessor :context
    end

    class ContextEvaluator
      def initialize(context)
        self.context = context
      end

      def evaluate(expr)
        context.evaluate(expr)
      end

      private
      attr_accessor :context
    end


    def parse_expression(context, expr)
      ExpressionParser.new(context).parse(expr)
    end

    def evaluate_in_context(context, expr)
      ContextEvaluator.new(context).evaluate(expr)
    end
  end


  class DefaultDialect

    def self.default_key
      'th'
    end

    # Precedence based on order for the time being
    def processors
      {
          if: IfProcessor,
          unless: UnlessProcessor,
          each: EachProcessor,
          text: TextProcessor,
          default: DefaultProcessor
      }
    end

    class DefaultProcessor
      include Thymeleaf::Processor

      def call(key:, node:, attribute:, context:)
        node[key] = [node[key], parse_expression(context, attribute.value)].compact.join(' ')
        attribute.unlink
      end
    end

    class TextProcessor
      include Thymeleaf::Processor

      def call(node:, attribute:, context:, **opts)
        node.content = parse_expression(context, attribute.value)
        attribute.unlink
      end
    end

    class IfProcessor
      include Thymeleaf::Processor
      def call(node:, attribute:, context:, **opts)
        attribute.unlink
        unless parse_expression(context, attribute.value)
          node.unlink
        end
      end
    end

    class UnlessProcessor
      include Thymeleaf::Processor

      def call(node:, attribute:, context:, **opts)
        attribute.unlink
        if parse_expression(context, attribute.value)
          node.children.each {|child| child.unlink }
          node.unlink
        end
      end
    end

    class EachProcessor
      include Thymeleaf::Processor

      def call(node:, attribute:, context:, **opts)
        variable, enumerable = parse_each_expr(context, attribute.value)

        # This is shit!
        subproccesor = Thymeleaf::TemplateProcessor.new

        attribute.unlink

        evaluate_in_context(context,enumerable).reverse.each do |element|
          subcontext = ContextHolder.new({variable => element}, context)
          new_node = node.dup
          subproccesor.send(:process_node, subcontext, new_node)
          node.add_next_sibling(new_node)
        end

        node.children.each {|child| child.unlink }
        node.unlink
      end

      private

      def parse_each_expr(context, expr)
        md = expr.match(/\s*(.+?)\s*:\s*\${(.+?)}/)
        raise ArgumentError, "Not a valid each expression" if md.nil?
        md[1..2]
      end

    end
  end
end