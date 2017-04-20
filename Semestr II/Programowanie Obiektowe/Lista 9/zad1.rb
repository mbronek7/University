class Funkcja

  def initialize (&block)
      @function = block
  end

  def value (x)   # oblicza wartoscfunkvji w punkcie x 
    @function.call x
  end

  def zerowe a, b, e  # miejsca zerowe w przedziale od a do b z dokladnoscia e
    ((-e...e) === value(a) and return a) or ((-e...e) === value(b) and return b)

    middle = (a + b) / 2.0 # obliczam msrodek przedzialu i bede szedl i na lewo i na prawo

    (-e...e) === value(middle) and return middle

    (value(a) * value(middle) < 0 and zerowe(a, middle, e)) or (value(b) * value(middle) < 0 and zerowe(middle, b, e)) or nil
  end

  def pole a, b
    area = 0.0

    $n = 1000
    @dx = (b - a) / $n.to_f

    $n.times { |x| area += @dx * value( a + x * @dx) } # n razy wykonaj znowu przybliz wartosc

    return area
  end


  def poch x  # pochodna w punkcie 
    $h = 1.0e-10
    return (value(x + $h) - value(x)) / $h  # wzor ogolny na pochodna niedokladna wartosc
  end

end
if __FILE__ == $0
  f = Funkcja.new { |x| x * x * -2 + 5 }
  puts f.value (3)
  puts f.poch 3
  puts f.pole -1, 1
  puts f.zerowe -5, 5, 0.001
  puts f.zerowe 0, 3, 0.00001

end
