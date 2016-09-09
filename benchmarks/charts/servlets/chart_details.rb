
require_relative 'base_servlet'
require_relative '../models/chart_list'

class ChartServlet < BaseServlet

  def do_GET(req, res)
    super

    path = req.path[1..-1].split('/')
    raise HTTPStatus::NotFound if path[1].nil?
    
    template = get_template "chart-details"
    context = {
        :chart      => (ChartLoader.load_bench path[1]),
        :chart_list => ChartList.find,
        :chart_name => path[1].gsub('_th_test', '').gsub('_', ' ')
    }

    res.body = render_template template, context
    raise WEBrick::HTTPStatus::OK
  end

end