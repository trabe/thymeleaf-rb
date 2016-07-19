
class ChartList

  def self.find(filter = '*')

    chart_list = []

    Dir.glob("#{__dir__}/../../results/#{filter}_th_test") do |file|
      bench_file = File.open file
      bench_file.rewind

      chart_list.push (File.basename file)
    end

    chart_list
  end
  
end