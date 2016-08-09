
require_relative '../../processor'
require_relative '../../template/template_processor'

module Thymeleaf

  class DefaultDialect

    def self.default_key
      'th'
    end
    
    def tag_processors
      {
          block: BlockProcessor
      }
    end

    # Precedence based on order for the time being
    def processors
      {
          insert:   InsertProcessor,
          replace:  ReplaceProcessor,
          fragment: FragmentProcessor,
          each:     EachProcessor,
          if:       IfProcessor,
          unless:   UnlessProcessor,
          switch:   SwitchProcessor,
          case:     CaseProcessor,
          object:   ObjectProcessor,
          text:     TextProcessor,
          utext:    UTextProcessor,
          remove:   RemoveProcessor,
          default:  DefaultProcessor
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
    require_relative 'processors/insert'
    require_relative 'processors/replace'
    require_relative 'processors/block'
    require_relative 'processors/fragment'

  end

end