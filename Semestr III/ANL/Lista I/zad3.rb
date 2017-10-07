
def picalc(k)
    sum = 0
    for i in 0..k
        sum+=((-1) ** i) / (2.0 * i + 1)
    end
    sum * 4
end
