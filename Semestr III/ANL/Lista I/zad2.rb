require 'mathn'
require 'memoize'
include Memoize

def printres x
    for i in 0...x.size
        print "#{i} wyraz ciągu to #{x[i]}\n"
    end
end 
def sequence n
 if n == 0
     return 1
 elsif n == 1
     return 1/5.0 
 else
     return 26/5.0 * sequence( n-1 ) - sequence( n-2 )
 end
end 

def compute n
    x = Array.new
    for i in 0..n
        x[i] = sequence i
    end
    printres x
end
=begin
Teraz druga metoda implementacji problemu
=end
memoize(:sequence2,"sequence.cache")
def sequence2 n
  if n == 0
      return Rational(1/1)
  elsif n == 1
      return Rational(1,5)
  else
      return Rational(26,5) * sequence2( n-1 ) - sequence2( n-2 )
  end 
end
 
def compute2 n
    x = Array.new
    for i in 0..n
        x[i] = sequence2 i
    end
    printres x
end

