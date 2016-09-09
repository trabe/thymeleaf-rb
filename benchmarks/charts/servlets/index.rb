
require_relative 'base_servlet'
require_relative '../models/chart_loader'
require_relative '../models/chart_list'

class IndexServlet < BaseServlet
  
  def do_GET(req, res)
    super
    
    template = get_template "index"
    context = {
        :general_chart => ChartLoader.load_general_bench,
        :chart_list    => ChartList.find
    }
    
    res.body = render_template template, context
    raise WEBrick::HTTPStatus::OK
  end

end