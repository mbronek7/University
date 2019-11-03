import sys

file = open("zad_output.txt", "w+")

def V(i, j):
    return 'V%d_%d' % (i,j)

def domains(Vs):
    return [ q + ' in 0..1' for q in Vs ]

def row(index, columnsNumber, rowSum):
    result = ""
    for j in range(0, columnsNumber):
        if (j != columnsNumber - 1):
            result += V(index, j) + '+'
        else:
            result += V(index, j)
    
    result += " #= "
    result += str(rowSum)
    return result

def gen_rows(rowsNumber, columnsNumber, rowsDescription):
    result = ""
    for i in range(0, rowsNumber):
        result += row(i, columnsNumber, rowsDescription[i])
        result += ",\n"
    return result
    
def column(index, rowsNumber, columnSum):
    result = ""
    for i in range(0, rowsNumber):
        if (i != rowsNumber - 1):
            result += V(i, index) + '+'
        else:
            result += V(i, index)
    
    result += " #= "
    result += str(columnSum)
    return result

def gen_columns(rowsNumber, columnsNumber, columnsDescription):
    result = ""
    for j in range(0, columnsNumber):
        result += column(j, rowsNumber, columnsDescription[j])
        result += ",\n"
    return result

def rects3x1(n, m): # prostokaty 2x2
    result = ""
    for i in range(0, n):
        for j in range(1, m - 1):
            result = result + "(" + V(i, j) + " #= 1) #==> (" + V(i, j - 1) + " + " + V(i, j + 1) + " #> 0),\n"
    
    result += "\n"
    for j in range(0, m):
        for i in range(1, n - 1):
            result = result + "(" + V(i, j) + " #= 1) #==> (" + V(i - 1, j) + " + " + V(i + 1, j) + " #> 0),\n"

    return result

def rectangles(n, m): # wszystkie pola sa prostokatami i nie stykaja sie
    result = ""
    for i in range(0, n - 1):
        for j in range(0, m - 1):
            result = result + V(i, j) + " + " + V(i, j + 1) + " + " + \
            V(i + 1, j) + " + " + V(i + 1, j + 1) + " #\\= 3,\n"

    return result

def print_constraints(Cs, indent, d):
    position = indent
    file.write((indent - 1) * ' ')
    for c in Cs:
        file.write(c + ',')
        position += len(c)
        if position > d:
            position = indent
            file.write('\n')
            file.write( (indent - 1) * ' ')

def print_listDeclaration(Vs):
    for i,j,val in Vs:
        file.write('%s #= %d, ' % (V(i,j), val))


def generate(rows, columns, listDecl):
    rowsNumber = len(rows)
    columnsNumber = len(columns)

    variables = [ V(i,j) for i in range(rowsNumber) for j in range(columnsNumber)]
    constraints = domains(variables)
    rowsStr = gen_rows(rowsNumber, columnsNumber, rows)
    columnsStr = gen_columns(rowsNumber, columnsNumber, columns)
    rectanglesStr = rectangles(rowsNumber, columnsNumber)
    rects3v1Str = rects3x1(rowsNumber, columnsNumber)

    file.write(':- use_module(library(clpfd)).')
    file.write('\n')
    file.write('solve([' + ', '.join(variables) + ']) :- ')

    print_constraints(constraints, 4, 70)
    print_listDeclaration(listDecl)

    file.write('\n')
    file.write(rowsStr)
    file.write('\n')
    file.write(columnsStr)
    file.write('\n')
    file.write(rectanglesStr)
    file.write('\n')
    file.write(rects3v1Str)

    file.write('\n')
    file.write('    labeling([ff], [' +  ', '.join(variables) + ']).') 
    file.write('\n')

    file.write('\n')
    file.write('\n')

    file.write(':- solve(X), write(X), nl.') 


def storms_from_to():
    with open('zad_input.txt') as data:
        rows = data.readline().split()
        rows = [int(i) for i in rows] 
        columns = data.readline().split()
        columns = [int(i) for i in columns] 
        declarations = [line.split() for line in data.readlines()]
        declarations = [ list(map(int, i)) for i in declarations] 
        generate(rows, columns, declarations)

storms_from_to()
file.close()
