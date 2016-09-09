
def assert_syntax_error(message, source, context = {})
  render(source, context)
  raise 'Syntax error expected'
rescue Thymeleaf::Parser::SyntaxError => ex
  assert_equal message, ex.message
end