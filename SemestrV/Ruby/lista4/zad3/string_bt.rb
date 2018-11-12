require_relative 'string_element.rb'

class StringBt < DrzewoBinarne

  def initialize(root_value = nil)
    @root = StringElement.new(root_value)
  end

  def wstaw(node, value, side = nil, father = nil)
    if !side.nil? && node.nil?
      return father.public_send("#{side}=", StringElement.new(value))
    end
    case node.value.size <=> value.size
    when 1 then wstaw(node.left, value, LEFT, node)
    when -1 then wstaw(node.right, value, RIGHT, node)
    when 0 then node
    end
  end
end
