
class Dialect

  def self.default_key
    nil
  end

  # Precedence based on order
  def tag_processors
    {}
  end

  # Precedence based on order
  def processors
    {}
  end

end