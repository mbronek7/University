
def calc k
    sum = 0
    for i in 1..k
        sum+=((-1) ** (i-1) ) * (((2.0/Math::E - 1) ** i) / i)
    end
    sum
end
