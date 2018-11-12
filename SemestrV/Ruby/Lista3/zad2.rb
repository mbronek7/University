def rozklad(n)
  return [n] if n < 1

  p = 2
  temp = []
  w = 0
  until p > n
    if (n % p).zero?
      w += 1
      n /= p
    else
      if w != 0
        temp.push([p, w])
        w = 0
      end
      p += 1
    end
  end
  temp.push([[p, w]])
end

p "Rozkład dla n = 756 to #{rozklad(756)}"

class Integer
  def divisiors
    tab = [1]
    2.upto(Math.sqrt(self).floor) do |i|
      if (self % i).zero?
        tab.push(i, self/i)
      end
    end
    tab.sort
  end
  end

def d(n)
  n.divisiors.inject(:+)
end

def zaprzyjaznione(n)
  temp = []
  (1..n).select do |a|
    b = d(a)
    temp.push(a) if a != b && d(b) == a
  end
  temp.each_slice(2).to_a
end

p "Pary liczb zaprzyjażnionych do n = 1300 to: #{zaprzyjaznione(1300)}"
