require 'erb'
require 'ostruct'

class ErbTestRunner

  def self.render(testfile)
    test_binding = self::context_binding(testfile.context) # Sacar a metodo
    ERB.new(testfile.erb_template).result(test_binding)
  end

  def self.context_binding(context)
    OpenStruct.new(context).instance_eval { binding }
  end

end