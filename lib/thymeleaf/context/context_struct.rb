
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

  def to_h
    @hash_table
  end

end
