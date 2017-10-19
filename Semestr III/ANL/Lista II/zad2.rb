require 'gnuplot'

x = [1/2,4,7/8,15/16,5/8]
y = [0,0,0,0,0]


    Gnuplot.open do |gp|
     Gnuplot::Plot.new( gp ) do |plot|

         plot.terminal "png"
         plot.output "wykresik.png"
         plot.xrange "[-3:3]"
         plot.ylabel "y"
         plot.xlabel "x"


         plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
           ds.with = "points"
         end


     end
    end
