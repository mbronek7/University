# // Zakładamy, że a > 0 i b > 0.
# a0 = a
# b0 = b

# // Inicjalizacja. Utrzymujemy niezmienniki p*a0 + q*b0 = a oraz r*a0 + s*b0 = b
# p = 1; q = 0;
# r = 0; s = 1;

# // algorytm
# while (b != 0)
  # c = a mod b
  # quot = floor( a/b )
  # a = b
  # b = c
  # r_tmp = r; s_tmp = s;
  # r = p - quot * r
  # s = q - quot * s
  # p = r_tmp; q = s_tmp;

# // Wówczas NWD(a0, b0) = p*a0 + q*b0

def NWD(a,b)
    a0 = a
    b0 = b
    p, q = 1, 0
    r, s = 0, 1
    # Inicjalizacja. Utrzymujemy niezmienniki p*a0 + q*b0 = a oraz r*a0 + s*b0 = b 
    while (b != 0)
        c = a % b
        quot = a / b
        a = b
        b = c
        r_tmp , s_tmp = r,s
        r = p - quot * r
        s = q - quot * s
        p, q= r_tmp, s_tmp
    end
    return "#{p} -- #{q} ---- NWD:#{p * a0 + q * b0}"
end 
