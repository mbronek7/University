class Fixnum

    def czynniki?
        t = [1]
        for i in 2 .. self
            if self % i == 0
                t = t + [i]
            end
        end
        return t
    end


    def ack(y)
      if self == 0
        return y + 1
      end
      if y == 0
        return (self - 1).ack(1)
      end
      return (self - 1).ack(self.ack(y - 1))
    end

    def doskonala?
        suma = 0
        for i in 1...(self - 1)
          suma = suma + i if self % i == 0
        end
        if suma == self
          return true
        end
        return false
    end

    @@cyfry = ["zero", "jeden", "dwa", "trzy", "cztery", "piec", "szesc", "siedem", "osiem", "dziewiec"]

    def slownie
      return '' if self == 0
      (self / 10).slownie + @@cyfry[self % 10] + ' '
    end
end

puts
table =  6.czynniki?
printf("czynniki 6: %s\n", table.to_s)
table = 9.czynniki?
printf("czynniki 9: %s\n", table.to_s)
puts
puts 2.ack(1)
puts 2.ack(2)
puts
puts 6.slownie
puts 123.slownie
puts 1519.slownie
puts
puts 6.doskonala?
puts 21308.doskonala?
