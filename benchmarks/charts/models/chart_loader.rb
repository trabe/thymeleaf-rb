
require 'json'
require_relative 'chart_data'

class ChartLoader
  
  def self.load_bench(bench_name)
    
    chart_data = ChartData.new
    
    Dir.glob("#{__dir__}/../../results/#{bench_name}/*.json").sort.each do |file|
      bench_file = File.open file
      bench_file.rewind
      
      bench_name = File.basename file, '.json'
      chart_data.x_axis_add bench_name
      
      json_content = JSON.parse bench_file.read
      
      json_content.each do |bench_data|
        chart_data.history_add_elem bench_data["name"], bench_data["ips"]
      end
    end

    chart_data
  end
  
end