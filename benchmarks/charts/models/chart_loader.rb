
require 'json'
require_relative 'chart_data'

class ChartLoader
  
  RESULTS_DIR = "#{__dir__}/../../results"
  
  def self.load_bench(bench_name)
    chart_data = ChartData.new
    
    bench_results(bench_name) do |bench_content, axis_name|
        chart_data.x_axis_add axis_name
        json_content = JSON.parse bench_content
        
        json_content.each do |bench_data|
          chart_data.history_add_elem bench_data["name"], bench_data["ips"]
        end
    end
    
    chart_data
  end
  
  def self.load_general_bench
    chart_data = ChartData.new

    bench_list do |benchmark, axis_name|
      chart_data.x_axis.push axis_name.gsub('test_templates_', '').gsub('_th_test', '')
      json_content = JSON.parse benchmark
      
      json_content.each do |bench_data|
        chart_data.history_add_elem bench_data["name"], bench_data["ips"]
      end
    end

    chart_data
  end
  
private
  def self.bench_list
    Dir.glob("#{RESULTS_DIR}/*_th_test").sort.each do |file|
      bench_file = Dir.glob("#{file}/*.json").sort.first

      File.open bench_file, 'r' do |benchmark|
        benchmark.rewind

        bench_name = File.basename file, '.json'
        
        yield benchmark.read, bench_name
      end
    end
  end
  
  def self.bench_results(bench_name)
    Dir.glob("#{RESULTS_DIR}/#{bench_name}/*.json").sort.each do |file|
      File.open file, 'r' do |bench_file|
        bench_file.rewind
        name = File.basename file, '.json'
        
        yield bench_file.read, name
      end
    end
  end
  
end