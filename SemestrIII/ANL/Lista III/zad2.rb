


def calc(a,b,c)
    if b < 0
        sgn = 1
    else
        sgn =-1
    end 
    x1 = (-b + sgn * Math.sqrt(b**2 - 4.0*a*c) ) / (2.0*a) 
    x2 = c/(x1*a)
    printf("x1 -- %d ||| x2 --  %d",x1,x2)
    puts x1
    print x1
    print "\n"
    sprintf("%d",x1)
end 

def calc2(a,b,c)
    x1 = (-b + Math.sqrt(b**2 - 4.0*a*c) ) / (2.0*a) 
    x2 = (-b - Math.sqrt(b**2 - 4.0*a*c) ) / (2.0*a) 
    printf("%d -- %d",x1,x2)
end 
