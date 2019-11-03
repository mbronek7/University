# frozen_string_literal: true

class LogicPictures
  def initialize(binary_word, block_size)
    @binary_word = binary_word
    @block_size = block_size
  end
  attr_reader :binary_word, :block_size

  def opt_dist
    min_cost = binary_word.size
    @cost_table = prepare_cost_table
    print @cost_table 
    (1..binary_word.size - block_size + 2).each_with_index do |_x, i|
      cost = compute_cost(i)
      min_cost = cost if cost < min_cost
    end
    min_cost
  end

  private

  def prepare_cost_table
    res = [0]
    binary_word.each do |x|
      res << res.last + x
    end
    res
  end

  def compute_cost(index)
    block_size + @cost_table.last - 2 * @cost_table[index + block_size - 1] + 2 * @cost_table[index - 1]
  end
end

a = LogicPictures.new([0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0], 1)
puts a.opt_dist

def get
  res = []
  File.open('zad4_input.txt').each do |line|
    next if line.empty?

    line = line.split
    next if line[0].nil?

    binword = line[0].each_char.map(&:to_i)
    block_size = line[1].to_i
    a = LogicPictures.new(binword, block_size)
    res << a.opt_dist
  end
  res
end

def output(data)
  File.open('zad4_output.txt', 'w+') do |f|
    f.puts(data)
  end
end

#output(get)
