
require_relative 'testfile'

module ThymeleafTest

  class TestDir

    DEFAULT_TEST_FILETYPE = 'th.test'

    def self.find(dir = '**', test_filetype = DEFAULT_TEST_FILETYPE)
      Dir.glob("#{dir}/*.#{test_filetype}") do |file|
        yield TestFile.new file
      end
    end

    def self.find_erb(dir = '**', test_filetype = DEFAULT_TEST_FILETYPE)
      self.find(dir, test_filetype) do |file|
        next unless file.has_erb?
        yield file
      end
    end

  end
end