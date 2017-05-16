class Kolekcja

  def initialize array
    @array = array
  end

  def swap i, j
    @array[i], @array[j] = @array[j], @array[i]
  end

  def length
    @array.length
  end

  def get i
    @array[i]
  end

  def permut
    @array.permutation.to_a
  end

end

class Sortowanie
  def self.sort kolekcja
    for i in 0...(kolekcja.length)
      for j in i...(kolekcja.length)
        ((kolekcja.get i) > (kolekcja.get j)) and kolekcja.swap i, j
      end
    end
  end

  def self.bad_sort kolekcja
    n = kolekcja.permut
    n.each do |tab|
      for i in 0...(tab.length - 1)
        break if tab[i] > tab[i + 1]
        return tab if i == tab.length - 2
      end
    end
  end

end

arr1 = [8,7,6,5,4,3,2,1]
arr2 = [8,7,6,5,4,3,2,1]

Sortowanie.sort Kolekcja.new arr1
print arr1, "\n"
print Sortowanie.bad_sort Kolekcja.new arr2
