require_relative 'thymeleaftest_test'

class TestDirLibTest < TestThymeleafTestLib

  def test_find_empty_dir
    counter = 0
    ThymeleafTest::TestDir::find(".") do
      counter += 1
    end
    assert_equal counter, 0
  end

  def test_find
    counter = 0
    file_counter = 0

    ThymeleafTest::TestDir::find("**", TEST_FILETYPE) do |file|
      assert file.is_a? ThymeleafTest::TestFile
      counter += 1
    end
    Dir.glob("**/*.#{TEST_FILETYPE}") do
      file_counter += 1
    end
    assert_equal counter, file_counter
  end

  def test_find_erb
    counter = 0
    ThymeleafTest::TestDir::find_erb("**", TEST_FILETYPE) do |file|
      assert file.is_a? ThymeleafTest::TestFile
      assert file.has_erb?
      counter += 1
    end
    assert counter > 0
  end

end