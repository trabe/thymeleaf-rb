
require 'webrick'

DEFAULT_PORT = 9955

require_relative 'servlets/index'
require_relative 'servlets/chart_details'

def server_start(config = {})
  config.update(:Port => DEFAULT_PORT) if config[:Port].nil?
  server = WEBrick::HTTPServer.new(config)

  server.mount('/', IndexServlet)
  server.mount('/chart', ChartServlet)

  yield server if block_given?

  ['INT', 'TERM'].each do |signal|
    trap(signal) { server.shutdown }
  end

  puts "Starting server on http://localhost:#{config[:Port]}"
  server.start
end