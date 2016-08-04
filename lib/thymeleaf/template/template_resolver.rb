
class TemplateResolver
  
  attr_accessor :prefix, :suffix
  
  def initialize
    self.prefix = ''
    self.suffix = ''
  end
  
  def get_template(template_name)
    "#{self.prefix}#{template_name}#{self.suffix}"
  end
  
end