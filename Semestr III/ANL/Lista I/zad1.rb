require 'gnuplot'

Rez = Struct.new(:x1,:x2,:delta)

class Function
 
  def initialize(&block)
     @function = block
  end

  def value (x)   
    @function.call x
  end
 
def plot a, b

    Gnuplot.open do |gp|
     Gnuplot::Plot.new( gp ) do |plot|

         
         plot.xrange "[#{a}:#{b}]"
         plot.ylabel "y"
         plot.xlabel "x"

         x = (a..b) .collect { |v|v.to_f }
         y = x.collect { |v| value(v)}

         plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
          ds.with = "lines"
         end


     end
    end
  end
end

def row(a,b,c)
   begin 
   delta = b*b-4*a*c 
   x1 = (-b + Math.sqrt(delta)) / (2.0*a)
   x2 = (-b - Math.sqrt(delta)) / (2.0*a)
   Rez.new(x1,x2,delta)
   rescue 
   print "delta < 0"
   end
end

def show_results
    f = File.open("zad1_dane.txt","r")
    f.each_line do |line|
        line = line.chomp.split(",")
        a,b,c = eval(line[0]).to_f,eval(line[1]).to_f,eval(line[2]).to_f
        zerowe = row(a,b,c)
        print "Dla a = #{line[0]}\n b = #{line[1]}\n c = #{line[2]}\n#{zerowe.x1} -- pierwsze miejsce zerowe\n#{zerowe.x2} -- drugie miejsce zerowe\n" 
        gets
        function = Function.new{|x| a*x**2 + b*x + c}
        function.plot -50, 50
    end
    f.close
end
