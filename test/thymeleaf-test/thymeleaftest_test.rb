$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'thymeleaf-test'

class TestThymeleafTestLib < Minitest::Test

  TEST_FILETYPE = 'th.test-test'
  TEST_DIR = 'files'

  TEST_DEFAULT_CONTEXT = '3 * 2 * (5 - 1)'
  TEST_DEFAULT_TH = "$thymeleaf$\n"
  TEST_DEFAULT_ERB = "$erb$\n"
  TEST_DEFAULT_EXPECTED = "$expected$"

  def get_filetest(test_name)
    File.expand_path("../#{TEST_DIR}/#{test_name}.#{TEST_FILETYPE}", __FILE__)
  end

  def load_filetest(test_name)
    file = get_filetest test_name
    File.open file, "r"
  end

end