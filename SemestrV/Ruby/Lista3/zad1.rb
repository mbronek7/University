def pierwsze(n)
  [2] + (2..n).select do |x|
    (2..Math.sqrt(x).ceil).each do |j|
      (x % j).zero? ? break : j
    end
  end
end

p "Tablica liczb pierwszych do n = 20 to : #{pierwsze(20)}"

def doskonale(n)
  (6..n).select { |j| j == (1...j).select { |i| (j % i).zero? }.inject(0) { |sum, i| sum + i }  }
end

p "Liczby doskonmałe do n = 1000 to: #{doskonale(10000)}"