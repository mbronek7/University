
def ATan(x)
    return Math.atan(x) if x.abs <= 1
    print "Wywołano funkcję ATan z |x| > 1"
end

def FATan(x)
    if x < 0
        a = - (Math::PI / 2.0)
     return a - ATan(1.0/x)
    elsif x == 0
     return ATan(x)
    else
        a = (Math::PI / 2.0)
     return a - ATan(1.0/x)
    end
end

