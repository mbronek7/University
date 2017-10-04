require 'mathn'
require 'memoize'
include Memoize

def printres x
    for i in 0...x.size
        print "#{i} wyraz ciągu to #{x[i]}\n"
    end
end 
def ciag n
 if n == 0
     return 1
 elsif n == 1
     return 1/5.0 
 else
     return 26/5.0 * ciag( n-1 ) - ciag( n-2 )
 end
end 

def go n
    x = Array.new
    for i in 0..n
        x[i] = ciag i
    end
    printres x
end
=begin
Teraz druga metoda implementacji problemu
=end
memoize(:ciag2,"ciag.cache")
def ciag2 n
  if n == 0
      return Rational(1/1)
  elsif n == 1
      return Rational(1,5)
  else
      return Rational(26,5) * ciag2( n-1 ) - ciag2( n-2 )
  end 
end
 
def go2 n
    x = Array.new
    for i in 0..n
        x[i] = ciag2 i
    end
    printres x
end

