import random

def ones( binary_word ):
    count = 0
    for x in binary_word:
        count += x
    return count

def opt_dist( binary_word, D):
    min_val = len(binary_word)

    for i in range(0, len(binary_word) - D+1):
        cost = 0
        cost += ones( binary_word[:i] )
        cost += D - ones(binary_word[i:i+D])
        cost += ones(binary_word[i+D:])
        if cost < min_val:
            min_val = cost
    return min_val


def fillSureFields(n, lines, columns):
    board = [ [0 for x in range(n)] for y in range(n)]

    for i in range(n):
        if columns[i] > n//2:
            mid = n//2
            board[mid][i] = 1
            for d in range(columns[i] - mid):
                board[mid-d][i] = 1
                board[mid+d][i] = 1
    for i in range(n):
        if lines[i] > n//2:
            mid = n//2
            board[i][mid] = 1
            for d in range( lines[i] - mid):
                board[i][mid-d] = 1
                board[i][mid+d] = 1

    return board


def get_column( tab, col ):
    res = []
    for i in range( len(tab[0]) ):
        res.append(tab[i][col])
    return res

def is_correct(board, lines, columns):
    n = len(lines)

    for i in range(n):
        if opt_dist( board[i], lines[i] ):
            return False

        if opt_dist( get_column(board, i), columns[i]):
            return False

    return True


def walkSat(n, lines, columns):
    board = fillSureFields(n, lines, columns)

    broken_row = []


    for i in range(n):
        if opt_dist( board[i], lines[i]) > 0:
            broken_row.append( i )
    err_counter = 0
    while not is_correct(board, lines, columns):
        if err_counter == 200:
            return walkSat(n, lines, columns)
        else:
            err_counter+=1
        broken_row = []
        for i in range(n):
            if opt_dist( board[i], lines[i]) > 0:
                broken_row.append(i)

        if broken_row:
            current_row = random.choice(broken_row)
            broken_row.remove(current_row)

            current_min = 2*n
            current_index = -1

            for i in range(n):
                board[current_row][i] = 1 if board[current_row][i] == 0 else 0
                col = get_column(board, i)

                line_cost = opt_dist(board[current_row], lines[current_row])
                column_cost = opt_dist(col, columns[i])

                sum_cost = line_cost + column_cost
                if current_min > sum_cost :
                    current_min = sum_cost
                    current_index = i

                board[current_row][i] = 1 if board[current_row][i] == 0 else 0

            board[current_row][current_index] = 1 if board[current_row][current_index] == 0 else 0


            if opt_dist( board[current_row], lines[current_row] ) > 0:
                broken_row.append(current_row)
        else:
            broken_column = []
            for i in range(n):
                if opt_dist( get_column(board, i), columns[i]) > 0:
                    broken_column.append( i )
            while broken_column:
                if err_counter == 200:
                    return walkSat(n, lines, columns)
                else:
                    err_counter+=1
                current_column = random.choice(broken_column)
                broken_column.remove(current_column)

                current_min = 2*n
                current_index = -1

                for i in range(n):
                    board[i][current_column] = 1 if board[i][current_column] == 0 else 0
                    col = get_column(board, current_column)

                    line_cost = opt_dist(board[i], lines[i])
                    column_cost = opt_dist(col, columns[current_column])

                    sum_cost = line_cost + column_cost
                    if current_min > sum_cost :
                        current_min = sum_cost
                        current_index = i

                    board[i][current_column] = 1 if board[i][current_column]==0 else 0

                board[current_index][current_column] = 1 if board[current_index][current_column]==0 else 0
                if  opt_dist(get_column(board, current_column), columns[current_column])  > 0:
                    broken_column.append(current_column)

    return board


def input():
    return open('zad5_input.txt').readlines()

input = input()

def printOutput(tab, n):
    for i in range(n):
        printLine(tab[i])

def printLine(line):
    for i in range(len(line)):
        if line[i]:
            file.write('#')
        else:
            file.write('.')
    file.write("\n")

lines = int(input[0][0])
columns = int(input[0][2])

image_block_lines = []
image_block_columns = []

for x in range(1, lines + 1):
    image_block_lines.append(int(input[x]))

for x in range(lines + 1, columns + lines + 1):
    image_block_columns.append(int(input[x]))

file = open('zad5_output.txt', 'w')

printOutput(walkSat(lines, image_block_lines, image_block_columns), columns)

file.close()