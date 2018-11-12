require_relative 'wyrazenie.rb'

class Dodawanie < Wyrazenie
  def initialize(number, other)
    super(number, other)
    @type = '+'
  end

  def oblicz
    number.to_i + other.to_i
  end

  def to_i
    oblicz
  end
end
