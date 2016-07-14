$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

require 'thymeleaf-test'

class TestUtilsBooleanize < TestThymeleaf

  require 'thymeleaf/utils/booleanize'

  def self.add_test name, &block
    define_method "test_booleanize_#{name}", &block
  end
end

# True words
{
  :true             => 'true',
  :true_with_spaces => '  true   ',
  :true_upper       => ' TRUE  ',
  :true_upper_lower => ' tRuE ',
  :true_yes         => 'yes ',
  :true_yes_upper   => 'YES ',
  :true_one         => ' 1 ',
  :true_number      => '25',
  :true_any_word    => ' thymeleaf ',
  :true_negative    => ' -35 '
}.each_pair do |test_name, test_word|
  TestUtilsBooleanize.add_test test_name.to_s do
    assert (booleanize test_word)
  end
end

# False words
{
    :false              => 'false',
    :false_with_spaces  => '  false   ',
    :false_upper        => ' FALSE  ',
    :false_upper_lower  => ' FalSE ',
    :false_yes          => 'no ',
    :false_yes_upper    => 'NO ',
    :false_zero         => ' 0 ',
    :false_nil          => 'nil ',
    :false_f            => ' f ',
    :false_n            => ' n ',
    :false_neg_zero     => '-0'
}.each_pair do |test_name, test_word|
  TestUtilsBooleanize.add_test test_name.to_s do
    refute (booleanize test_word)
  end
end