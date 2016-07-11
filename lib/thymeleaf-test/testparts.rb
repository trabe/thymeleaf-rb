
module ThymeleafTest

  class TestParts

    PART_CONTEXT  = 0
    PART_TH       = 1
    PART_EXPECTED = 2
    PART_ERB      = 3

    attr_accessor :parts

    def initialize(parts)
      self.parts = parts
      self.parts.shift if has_prefix_section?(parts)
    end

    def get_context
      self.parts[PART_CONTEXT]
    end

    def get_th
      self.parts[PART_TH]
    end

    def get_expected
      self.parts[PART_EXPECTED]
    end

    def get_erb
      self.parts[PART_ERB]
    end

    def has_context?
      self.count >= PART_CONTEXT
    end

    def has_th?
      self.count >= PART_TH
    end

    def has_expected?
      self.count >= PART_EXPECTED
    end

    def has_erb?
      self.count >= PART_ERB
    end

    def count
      self.parts.count
    end

    def any?
      !self.empty?
    end

    def empty?
      self.count == 0
    end

  private
    def has_prefix_section?(parts)
      parts.count > 3 && parts[0].empty?
    end
  end

end