require_relative 'element.rb'

class DrzewoBinarne
  attr_accessor :root
  LEFT = "left".freeze
  RIGHT = "right".freeze

  def initialize(root_value = nil)
    @root = Element.new(root_value)
  end

  def wstaw(node, value, side = nil, father = nil)
    if !side.nil? && node.nil?
      return father.public_send("#{side}=", Element.new(value))
    end
    case node.value <=> value
    when 1 then wstaw(node.left, value, LEFT, node)
    when -1 then wstaw(node.right, value, RIGHT, node)
    when 0 then node
    end
  end

  def istnieje?(value, node)
    return false if node.nil?
    case node.value <=> value
    when 1 then istnieje?(value, node.left)
    when -1 then istnieje?(value, node.right)
    when 0 then node
    end
  end

  def usun(value)
    @root.usun(value)
  end

  def to_s
    @root.left.to_s + " " + @root.value.to_s + " " + @root.right.to_s
  end
end
