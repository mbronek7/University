import sys
from itertools import product

def V(i,j):
    return 'V%d_%d' % (i,j)
    
def domains(Vs): #dziedzina
    return [ q + ' in 1..9' for q in Vs ]
    
def all_different(Qs):
    return 'all_distinct([' + ', '.join(Qs) + '])'
    
def get_column(j):
    return [V(i,j) for i in range(9)] 
            
def get_raw(i):
    return [V(i,j) for j in range(9)]

def get_block(c):
    a = [x+c[0] for x in range(0,3)]
    b = [x+c[1] for x in range(0,3)]
    return [V(x,y) for x in a for y in b]
                        
def horizontal():   
    return [ all_different(get_raw(i)) for i in range(9)]

def vertical():
    return [all_different(get_column(j)) for j in range(9)]

def block():
    return [all_different(get_block(j)) for j in product([0,3,6], repeat=2) ]

def print_constraints(Cs, indent, d): #wydrukuj warunki
    position = indent
    print (indent - 1) * ' ',
    for c in Cs:
        print c + ',',
        position += len(c)
        if position > d:
            position = indent
            print
            print (indent - 1) * ' ',

      
def sudoku(assigments):
    variables = [ V(i,j) for i in range(9) for j in range(9)]
    
    print ':- use_module(library(clpfd)).'
    print 'solve([' + ', '.join(variables) + ']) :- '
    
    
    cs = domains(variables) + vertical() + horizontal() + block()
    for i,j,val in assigments:
        cs.append( '%s #= %d' % (V(i,j), val) )
    
    print_constraints(cs, 4, 70),
    print
    print '    labeling([ff], [' +  ', '.join(variables) + ']).' 
    print 
    print ':- solve(X), write(X), nl.'

if __name__ == "__main__":
    raw = 0
    triples = []
    
    for x in sys.stdin:
        x = x.strip()
        if len(x) == 9:
            for i in range(9):
                if x[i] != '.':
                    triples.append( (raw,i,int(x[i])) )
            raw += 1
    sudoku(triples)

