class Zmienna
  attr_accessor :var
  def initialize(var)
    @var = var
  end

  def to_s
    @var.to_s
  end

  def to_i
    raise ArgumentError, "nie można policzyć wartości wyrażenia, ponieważ nie jest znana wartość: #{@var}" unless @var.is_a? Numeric
  end
end
