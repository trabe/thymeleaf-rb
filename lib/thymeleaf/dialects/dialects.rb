
module Thymeleaf

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
      return [key, null_processor] if match.nil?

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

    def null_processor
      @null_prccesor ||= NullProcessor.new
    end

    def dialect_processors(dialect)
      dialect.processors.reduce({}) do |processors, (processor_key, processor)|
        processors[processor_key.to_s] = processor.new
        processors
      end
    end
  end

end