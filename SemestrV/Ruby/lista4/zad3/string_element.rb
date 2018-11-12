class StringElement
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(v)
    @value = v
    @left = nil
    @right = nil
  end

  def <=>(other)
    value.size <=> other.value.size
  end

  def to_s
    left.to_s + ' ' + value.to_s + ' ' + right.to_s
  end

  def usun(v)
    if v < value
      self.left = left ? left.usun(v) : nil
    elsif v > value
      self.right = right ? right.usun(v) : nil
    else
      if left.nil?
        return right
      elsif right.nil?
        return left
      end
      min = right
      min = min.left until min.left.nil?
      self.value = min.value
      self.right = right.usun(value)
  end
    self
  end
end
