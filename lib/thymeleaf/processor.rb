
module Thymeleaf

  module Processor

    require_relative 'processor/expression_parser'
    require_relative 'processor/context_evaluator'

    def parse_expression(context, expr)
      ExpressionParser.new(context).parse(expr)
    end
    
    def parse_expression_variable(context, expr)
      ExpressionParser.new(context).parse(expr, :single_expression)
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