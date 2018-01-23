class Array2D
   def initialize(d1,d2)
    @data = Array.new(d1) { Array.new(d2) }
   end

  def [](x, y)
    @data[x][y]
  end

  def []=(x, y, value)
    @data[x][y] = value
  end
end

class Function
  def initialize (&block)
      @function = block
  end

  def value (x)   
    @function.call x
  end

  def romberg(a,b,n)
     h=b-a
     r = Array2D.new(n+1,n+1)
     r.[]=(0,0,0.5 * h * (self.value(a) + self.value(b)) )
     printf("%.10f\n", r.[](0,0) )

     (1..n).each do |i|
         
         h *= 0.5
         sum = 0
         
         (1..2**i-1).step(2).each do |k|
             sum+=self.value(a + k * h)
         end

         r.[]=(i,0,(0.5 * r.[](i-1,0)) + (sum * h))
         printf("%.10f", r.[](i,0))

         (1..i).each do |j|
             r.[]=(i,j, r.[](i,j-1) + (r.[](i,j-1) - r.[](i-1,j-1)) / ((4 ** j)-1.0))
             printf(" %.10f", r.[](i,j))
         end
         puts
     end
  end

end

A = Function.new { |x| 2018 * x**5  + 2017 * x**4 - 2016 * x**3 + 2015 * x }
A.romberg(-2,3,15)
