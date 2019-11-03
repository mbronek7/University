from collections import deque
from numpy import zeros


def print_img(img):
    for row in img:
        for cell in row:
            if cell:
                file.write("#")
            else:
                file.write(".")

        file.write("\n")


def possiblle_settings(n, pattern):
    if not n:
        return [[]]
    if not pattern:
        return [[0] * n]
    block_len = pattern[0]
    block = [1] * block_len
    new_n = n - block_len
    if pattern[1:]:
        block += [0]
        new_n -= 1
    current_possibilities = [
        block + new_pattern for new_pattern in possiblle_settings(new_n, pattern[1:])
    ]
    required_len = sum(pattern) + len(pattern) - 1
    if required_len < n:  # dokładam zera z przodu jak jest mniejsze niz n
        return current_possibilities + [
            [0] + new_pattern for new_pattern in possiblle_settings(n - 1, pattern)
        ]
    else:
        return current_possibilities


def solve(rows, columns):
    height, width = len(rows), len(columns)
    possible_rows = [possiblle_settings(width, row) for row in rows]
    possible_columns = [possiblle_settings(height, column) for column in columns]
    img = zeros((height, width)) #mam wszystkie możliwości w kolumnach i rzędach + img i fixed jako obrazki zlozone z samych zer
    not_fixed = deque() #lista dwukierunkowa

    def match_columns(y, x): #dopasuj kolumne po współrzędnych
        b = img[y][x]
        possible_columns[x] = [
            column for column in possible_columns[x] if column[y] == b
        ]

    def match_rows(y, x): #dopasuj wiersz po współrzędnych
        b = img[y][x]
        possible_rows[y] = [row for row in possible_rows[y] if row[x] == b]

    def find_solution_for(y, x, current_rows):
        row_point = current_rows[0][x]
        if all(row[x] == row_point for row in current_rows): # jezeli wszystkie wiersze spełniają się w tym miejscu tak samo
            img[y][x] = row_point # mamy tu pewniaka
            match_columns(y, x) # dopasowujemy kolumny
        else:
            column_point = possible_columns[x][0][y]

            if all(column[y] == column_point for column in possible_columns[x]): # jezeli wszystkie kolmny sie tu spelniaja tak samo
                img[y][x] = column_point # mamy pewniaka w obrazku
                match_rows(y, x) # dopasowujemy reszte
            else:
                not_fixed.append((y, x)) # odkładamy dany pixel na pozniej

    for y in range(height):
        current_rows = possible_rows[y]
        for x in range(width):
            find_solution_for(y, x, current_rows)

    while not_fixed:  # sa miejsca do naprawienia
        y, x = not_fixed.popleft() # wez pierwszy wlozony do kolejki dwukierunkowej
        current_rows = possible_rows[y]
        find_solution_for(y, x, current_rows)

    return img


def take_columns_and_rows(data):
    height, width = [int(literal) for literal in data.readline().split()]
    rows_and_columns = [
        [int(literal) for literal in line.split()] for line in data.readlines()
    ]
    assert len(rows_and_columns) == height + width
    rows, columns = rows_and_columns[:height], rows_and_columns[height:]
    return rows, columns


def read_data(filename):
    with open(filename) as data:
        rows, columns = take_columns_and_rows(data)
        print_img(solve(rows, columns))


file = open("zad_output.txt", "w")
read_data("zad_input.txt")
#print(possiblle_settings(15,[5]))
