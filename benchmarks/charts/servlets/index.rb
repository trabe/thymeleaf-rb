
require_relative 'base_servlet'
require_relative '../models/chart_loader'
require_relative '../models/chart_list'

class IndexServlet < BaseServlet
  
  def do_GET(req, res)
    super
    
    chart_example = ChartLoader.load_bench 'test_templates_if_conditional_th_test'
    
    template = get_template "index"
    context = {
        :general_chart => chart_example,
        :chart_list    => ChartList.find
    }
    
    res.body = render_template template, context
    raise WEBrick::HTTPStatus::OK
  end

end