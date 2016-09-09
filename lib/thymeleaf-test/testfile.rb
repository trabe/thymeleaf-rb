
require_relative 'testparts'

module ThymeleafTest

  class WrongTestFileFormat < StandardError
  end


  class TestFile

    CONTENT_SEPARATOR = /^---\n/

    attr_writer :test_name

    def initialize(file)
      @file = file
    end

    def has_context?
      !parts.get_context.nil?
    end

    def has_erb?
      !parts.get_erb.nil?
    end

    def has_th?
      !parts.get_th.nil?
    end

    def has_expected?
      !parts.get_expected.nil?
    end

    def context
      eval(parts.get_context)
    end

    def th_template
      parts.get_th
    end

    def erb_template
      parts.get_erb
    end

    def expected_fragment
      parts.get_expected
    end

    def test_name(add_uniqueid = false)
      @test_name ||= begin
        test_name = if file.is_a? File
                      file.path.clone
                    else
                      file.to_s.clone
                    end
        test_name.gsub!(/[\/.]/, '_')
        test_name
      end
      if add_uniqueid == :add_uniqueid
        "#{@test_name}_#{uniqueid}"
      else
        @test_name
      end
    end


  private

    attr_accessor :file

    def parts
      @parts ||= begin
        @file = File.open @file unless @file.is_a? File
        @file.rewind

        content = @file.read

        parts = TestParts.new content.split(CONTENT_SEPARATOR)
        @file = @file.path

        unless parts.any?
          raise WrongTestFileFormat
        end

        parts
      end
    end

    def uniqueid
      now_f = Time.now.to_f
      now_i = now_f.to_s.delete('.').to_i
      now_i.to_s(36)
    end

  end

end
