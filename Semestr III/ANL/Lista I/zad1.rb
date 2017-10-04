
def row(a,b,c)
   x = Array.new
   delta = b*b-4*a*c
   x[0] = (-b + Math.sqrt(delta)) / (2*a)
   x[1] = (-b - Math.sqrt(delta)) / (2*a)
   x[2] = delta
   x
end

