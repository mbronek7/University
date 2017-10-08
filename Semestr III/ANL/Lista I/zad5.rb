def calc(x,k)
    sum = 0 
    for i in 1..k 
        sum+=(((-1) ** (i-1) ) * (((x-1) ** i) / i))
    end
    sum
end

def ln x
    if  x > 5
      temp = x / Math::E 
     return 1 + 1 + ln(temp/Math::E)
    else
     return 1 + calc((x / Math::E),30)
    end 
end

