
require 'ostruct'

class ContextStruct < OpenStruct

  def initialize(hash=nil)
    @table = {}
    @hash_table = {}

    if hash && (hash.is_a? Hash)
      hash.each do |k,v|

        if v.is_a?(Array)
          other = Array.new
          v.each do | entry |
            other.push((entry.is_a?(Hash) ? self.class.new(entry) : entry))
          end
          v = other
        end

        @table[k.to_sym] = (v.is_a?(Hash) ? self.class.new(v) : v)
        @hash_table[k.to_sym] = v
        new_ostruct_member(k)

      end
    end
  end
  
  def set_private(private_var, value)
    value = ContextStruct.new(value) if value.is_a? Hash
    send(:"\##{private_var}=", value)
  end
  
  def get_private(private_var)
    send(:"\##{private_var}")
  end
  
  def has_private(private_var)
    begin
      !(get_private private_var).nil?
    rescue
      false
    end
  end

  def get_object_var
    begin
      get_private('context_obj')
    rescue
      nil
    end
  end

  def set_object_var(var)
    set_private('context_obj', var)
  end

  def to_h
    @hash_table
  end

end
