
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
          object: ObjectProcessor,
          each: EachProcessor,
          if: IfProcessor,
          unless: UnlessProcessor,
          switch: SwitchProcessor,
          case: CaseProcessor,
          text: TextProcessor,
          utext: UTextProcessor,
          remove: RemoveProcessor,
          default: DefaultProcessor
      }
    end

    require_relative 'processors/default'
    require_relative 'processors/object'
    require_relative 'processors/text'
    require_relative 'processors/utext'
    require_relative 'processors/if'
    require_relative 'processors/unless'
    require_relative 'processors/switch'
    require_relative 'processors/case'
    require_relative 'processors/each'
    require_relative 'processors/remove'

  end

end