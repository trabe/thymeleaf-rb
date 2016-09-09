
require_relative '../../../lib/thymeleaf'


class BaseServlet < WEBrick::HTTPServlet::AbstractServlet
  
  def prevent_caching(res)
    res['ETag']          = nil
    res['Last-Modified'] = Time.now + 100**4
    res['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'
    res['Pragma']        = 'no-cache'
    res['Expires']       = Time.now - 100**4
  end
  
  def get_template(template_name)
    template_file = File.open "#{__dir__}/../templates/#{template_name}.th.html"
    template_file.rewind

    template_file.read
  end
  
  def do_GET(req, res)
    prevent_caching res
  end
  
  def render_template(template, context)
    Thymeleaf::Template.new(template, context).render.to_s
  end

end