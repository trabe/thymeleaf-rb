
module Thymeleaf

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

  class NullProcessor
    def call(**opts)
    end
  end

end