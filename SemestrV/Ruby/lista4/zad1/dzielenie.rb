require_relative 'wyrazenie.rb'

class Dzielenie < Wyrazenie
  def initialize(number, other)
    super(number, other)
    @type = '/'
  end

  def oblicz
    number.to_f / other.to_f
  end

  def to_i
    oblicz.to_f
  end
end
