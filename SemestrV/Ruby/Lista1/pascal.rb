def pascal(number)
  p = [1]
  1.upto(number) do |size|
    puts p.join(' ')
    p = Array.new(size + 1) do |index|
      a = index < p.length ? p.at(index) : 0
      b = index.positive? ? p.at(index - 1) : 0
      a + b
    end
  end
end

pascal(10)
