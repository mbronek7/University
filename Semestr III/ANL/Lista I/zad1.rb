
Rez = Struct.new(:x1,:x2,:delta)

def find_solution
    a = rand 
    b = rand 
    c = rand 
    row(a,b,c)
end

def row(a,b,c)
   begin 
   delta = b*b-4*a*c 
   x1 = (-b + Math.sqrt(delta)) / (2*a)
   x2 = (-b - Math.sqrt(delta)) / (2*a)
   Rez.new(x1,x2,delta)
   rescue 
   find_solution
   end
end

def go
  loop do
    result = find_solution
    print result 
  break if result.x1 == 0 || result.x2 == 0
  end
  result
end 
