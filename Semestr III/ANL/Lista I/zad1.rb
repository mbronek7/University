
Rez = Struct.new(:x1,:x2,:delta)

def row(a,b,c)
   begin 
   delta = b*b-4*a*c 
   x1 = (-b + Math.sqrt(delta)) / (2*a)
   x2 = (-b - Math.sqrt(delta)) / (2*a)
   puts Rez.new(x1,x2,delta)
   rescue 
   print "delta < 0"
   end
end

def show_results
    f = File.open("zad1_dane.txt","r")
    f.each_line do |line|
        line = line.chomp.split(",")
        a,b,c = eval(line[0]).to_f,eval(line[1]).to_f,eval(line[2]).to_f
        row(a,b,c)
    end
    f.close
end
