$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'thymeleaf'
require 'minitest/autorun'

class TestThymeleaf < Minitest::Test

  def render(source, context = {})
    Thymeleaf::Template.new(source, context).render
  end

  require_relative 'assertions/html'
  require_relative 'assertions/html_page'
  require_relative 'assertions/syntax_error'

end