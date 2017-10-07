
def calc(x,k)
    sum = 0
    for i in 1..k 
        sum+=((-1) ** (i-1) ) * (((x-1) ** i) / i)
    end
    sum
end

def ln x
    arg = x/Math::E
    1 + calc(arg,690)
end

