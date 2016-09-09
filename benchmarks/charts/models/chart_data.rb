
require_relative 'chart_loader'
require_relative 'bench_history'

require 'json'

class ChartData
  
  attr_accessor :history_list, :x_axis
  
  def initialize
    self.history_list = []
    self.x_axis = []
  end
  
  def add_data(name, item, axis)
    history_add_elem name, item
    x_axis_add axis
  end
  
  def history_add_elem(name, item)
    elem = self.history_list.detect { |hist| hist.name == name }
    
    if elem.nil?
      elem = BenchHistory.new name
      self.history_list.push elem
    end
    
    elem.add item
  end
  
  def x_axis_add(item)
    #FIXME: this is shit
    item = "#{item[0..3]}-#{item[4..5]}-#{item[6..7]} #{item[8..9]}:#{item[10..11]}:#{item[12..13]}"
    
    self.x_axis.push item
  end
  
  def each_history
    yield self.history_list.each
  end

  def each_axis_elem
    yield self.x_axis.each
  end
  
  def x_axis_to_json
    JSON.generate self.x_axis
  end
  
end