$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'thymeleaf'
require 'minitest/autorun'
require 'minitest/spec'

class TestThymeleaf < Minitest::Test
  def setup
    @aux = Aux.new

    Thymeleaf.configure do |configuration|
      configuration.add_dialect 'cache', RailsCacheDialect
    end

  end

  def render(source, context = {})
    Thymeleaf::Template.new(source, context).render
  end

  def assert_html(expected, source, context = {})
    assert_equal expected, render(source, context).to_s
  end

  def assert_html_page(expected, source, context = {})
    assert_equal render(expected, {}).to_s, render(source, context).to_s
  end

  def assert_syntax_error(message, source, context = {})
    render(source, context)
    raise 'Syntax error expected'
  rescue Thymeleaf::Parser::SyntaxError => ex
    assert_equal message, ex.message
  end

end

class Aux

  def some_short_text
    'Hi, this is a short text'
  end

  def some_plain_text
    <<-TXT
    Lorem fistrum aliquip al ataquerl ex exercitation. Incididunt veniam a gramenawer elit aliqua tempor ex nisi.
    Dolor diodeno eiusmod no puedor nostrud incididunt dioden.
    TXT
  end

  def some_html_content
    <<-HTML
    <article>
      <!-- A wild comment appeared! -->
      <img src="path/to/image" alt="An image" class="main-image" />
      <h2 class="">Some kind of title</h2>
      <p class="description">A very <b>short</b> description</p>
    </article>
    HTML
  end

end

class RailsCacheDialect
  def default_key
    'rails-cache'
  end

  def processors
    {
        fetch: FetchProccessor
    }
  end

  class FetchProccessor
    def call(node:, attribute:, **opts)
      attribute.unlink
    end
  end
end