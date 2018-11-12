require_relative 'stala.rb'
require_relative 'zmienna.rb'

class Wyrazenie
  attr_accessor :number, :other

  def initialize(number, other)
    @number = number
    @other = other
  end

  def is_zero?(value)
    return true if value.to_i.zero?
    false
  end

  def uproszczenie
    if self.class == Dodawanie
      return @other if is_zero?(@number)
      return @number if is_zero?(@other)
    end
    if self.class == Odejmowanie
      return @other if is_zero?(@number)
      return @number if is_zero?(@other)
    end
    if self.class == Dzielenie
      if @other.class == Dzielenie
        if @number.class != Zmienna && @other.to_i == @number.to_i
          return Stala.new(1)
        end
      end
      if @number.class == Dzielenie
        if @other.class != Zmienna && @other.to_i == @number.to_i
          return Stala.new(1)
        end
      end
    end
    if self.class == Mnozenie
      if @other.class == Dzielenie
        return Stala.new(1) if @other.other.to_s == @number.to_s
      end
      if @number.class == Dzielenie
        return Stala.new(1) if @number.other.to_s == @other.to_s
      end
    end
  end

  def to_s
    @number.to_s + @type.to_s + @other.to_s
  end
end
