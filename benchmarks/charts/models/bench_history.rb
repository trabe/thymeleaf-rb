
require 'json'

class BenchHistory
  
  attr_accessor :data_list, :name
  
  def initialize(name)
    self.data_list = []
    self.name = name
  end
  
  def add(data)
    self.data_list.push data
  end
  
  def each
    yield self.data_list.each
  end
  
  def to_json
    JSON.generate ({ :label => self.name, :data => self.data_list })
  end
  
end