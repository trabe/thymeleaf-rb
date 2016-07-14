
require_relative '../../processor'
require_relative '../../template/template_processor'

module Thymeleaf

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
          utext: UTextProcessor,
          default: DefaultProcessor
      }
    end

    require_relative 'processors/default'
    require_relative 'processors/text'
    require_relative 'processors/utext'
    require_relative 'processors/if'
    require_relative 'processors/unless'
    require_relative 'processors/each'

  end

end