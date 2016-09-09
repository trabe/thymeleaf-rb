
class ChartList

  RESULTS_DIR = "#{__dir__}/../../results"

  def self.find(filter = '*')

    chart_list = []

    Dir.glob("#{RESULTS_DIR}/#{filter}_th_test") do |file|
      File.open file, 'r' do |bench_file|
        bench_file.rewind
        
        chart_list.push (File.basename file)
      end
    end

    chart_list
  end
  
end