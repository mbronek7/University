require_relative 'zad1'
require 'gnuplot'
class Funkcja
  def plot a, b

    Gnuplot.open do |gp|
     Gnuplot::Plot.new( gp ) do |plot|

         plot.terminal "png"
         plot.output "graph.png"
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

if  __FILE__ == $0
  f = Funkcja.new { |x| x + 3 }
  f.plot -50, 50
end
