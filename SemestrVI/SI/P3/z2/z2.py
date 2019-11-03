from math import inf
from numpy import zeros
from sys import stdin


def print_img(img):
    for row in img:
        for cell in row:
            if cell:
                print('#', end = '')
            else:
                print('.', end = '')

        print()


def possibilities(n, pattern):
    def aux(n, pattern):
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
        current_possibilities = [block + new_pattern for new_pattern in aux(new_n, pattern[1:])]

        required_len = sum(pattern) + len(pattern) - 1
        if required_len < n:
            return current_possibilities + [[0] + new_pattern for new_pattern in aux(n - 1, pattern)]
        else:
            return current_possibilities

    return aux(n, pattern)


def solve(rows, columns):  # vars are rows
    h, w = len(rows), len(columns)
    possible_rows = [possibilities(w, row) for row in rows]
    possible_columns = [possibilities(h, column) for column in columns]

    def select_row(assigned_rows, possible_rows):
        best_len = inf
        best_y = None

        for y, rows in enumerate(possible_rows):
            if y not in assigned_rows:
                new_len = len(rows)

                if new_len < best_len:
                    best_len = new_len
                    best_y = y

        return best_y

    def is_assignment_complete(assigned_rows):
        return len(assigned_rows) == h

    def reason_columns(possible_columns, y, row):
        return [[column for column in columns if column[y] == row[x]] for x, columns in enumerate(possible_columns)]

    def solve_backtrack(assigned_rows, possible_rows, possible_columns):
        if is_assignment_complete(assigned_rows):
            return assigned_rows

        y = select_row(assigned_rows, possible_rows)

        for row in possible_rows[y]:
            assigned_rows[y] = row
            new_possible_columns = reason_columns(possible_columns, y, row)

            if all(new_possible_columns):
                result = solve_backtrack(assigned_rows, possible_rows, new_possible_columns)

                if result:
                    return result

            del assigned_rows[y]

        return None

    y_to_row = solve_backtrack({}, possible_rows, possible_columns)
    return [y_to_row[y] for y in range(h)]


def solve1(rows, columns):
    h, w = len(rows), len(columns)
    possible_rows = [possibilities(w, row) for row in rows]
    possible_columns = [possibilities(h, column) for column in columns]

    def is_assignment_complete(assigned_rows, assigned_columns):
        if len(assigned_rows) == h:
            return 'r'
        elif len(assigned_columns) == w:
            return 'c'
        else:
            return None

    def select_var(assigned_rows, assigned_columns, possible_rows, possible_columns):
        best_len = inf
        best_i = None
        is_row = True

        for y, rows in enumerate(possible_rows):
            if y not in assigned_rows:
                new_len = len(rows)

                if new_len < best_len:
                    best_len = new_len
                    best_i = y

        for x, columns in enumerate(possible_columns):
            if x not in assigned_columns:
                new_len = len(columns)

                if new_len < best_len:
                    best_len = new_len
                    best_i = x
                    is_row = False

        return is_row, best_i

    def reason(possible_rows, possible_columns, is_row, i, val):
        if is_row:
            return possible_rows, [[column for column in columns if column[i] == val[x]] for x, columns in enumerate(possible_columns)]
        else:
            return [[row for row in rows if row[i] == val[y]] for y, rows in enumerate(possible_rows)], possible_columns

    def lcv_row(y, row, possible_columns):
        return 1 / sum(len([column for column in possibles if column[y] == row[x]]) for x, possibles in enumerate(possible_columns))

    def lcv_column(x, column, possible_rows):
        return 1 / sum(len([row for row in possibles if row[x] == column[y]]) for y, possibles in enumerate(possible_rows))

    def solve_backtrack(assigned_rows, assigned_columns, possible_rows, possible_columns):
        complete = is_assignment_complete(assigned_rows, assigned_columns)
        if complete == 'r':
            return assigned_rows
        elif complete == 'c':
            return {y: [assigned_columns[x][y] for x in range(w)] for y in range(h)}

        is_row, i = select_var(assigned_rows, assigned_columns, possible_rows, possible_columns)
        possibles = possible_rows if is_row else possible_columns

        for val in sorted(possibles[i], key = (lambda possibility: lcv_row(i, possibility, possible_columns)) if is_row else (
                lambda possibility: lcv_column(i, possibility, possible_rows))):
            if is_row:
                assigned_rows[i] = val
            else:
                assigned_columns[i] = val

            new_possible_rows, new_possible_columns = reason(possible_rows, possible_columns, is_row, i, val)

            if all(new_possible_rows) and all(new_possible_columns):
                result = solve_backtrack(assigned_rows, assigned_columns, new_possible_rows, new_possible_columns)

                if result:
                    return result

            if is_row:
                del assigned_rows[i]
            else:
                del assigned_columns[i]

        return None

    y_to_row = solve_backtrack({}, {}, possible_rows, possible_columns)
    return [y_to_row[y] for y in range(h)]


def extract_not_fixed(img, possible_rows, possible_columns):
    not_fixed = set()

    for y in range(len(possible_rows)):
        for x in range(len(possible_columns)):
            if all([row[x] == possible_rows[y][0][x] for row in possible_rows[y]]):
                img[y][x] = possible_rows[y][0][x]
            elif all([column[y] == possible_columns[x][0][y] for column in possible_columns[x]]):
                img[y][x] = possible_columns[x][0][y]
            else:
                not_fixed |= {(y, x)}

    return not_fixed


def solve2(rows, columns):
    h, w = len(rows), len(columns)
    possible_rows = [possibilities(w, row) for row in rows]
    possible_columns = [possibilities(h, column) for column in columns]
    img = zeros((h, w))
    # not_fixed = {(y, x) for y in range(h) for x in range(w)}
    not_fixed = extract_not_fixed(img, possible_rows, possible_columns)

    # not_fixed = deque({(y, x) for y in range(h) for x in range(w)})

    def select_var(possible_rows, possible_columns):
        rows_count, columns_count = {}, {}

        for y, x in not_fixed:
            if y not in rows_count:
                rows_count[y] = len(possible_rows[y])
            if x not in columns_count:
                columns_count[x] = len(possible_columns[x])

        return min(((y, x) for y, x in not_fixed), key = lambda p: rows_count[p[0]] + columns_count[p[1]])

    def reason(possible_rows, possible_columns, y, x, val):
        new_possible_rows = possible_rows[:y] + [[row for row in possible_rows[y] if row[x] == val]] + possible_rows[y + 1:]
        new_possible_columns = possible_columns[:x] + [[column for column in possible_columns[x] if column[y] == val]] + possible_columns[x + 1:]
        return new_possible_rows, new_possible_columns

    def solve_backtrack(possible_rows, possible_columns):
        nonlocal not_fixed

        if not not_fixed:
            return img

        y, x = select_var(possible_rows, possible_columns)
        # y, x = deque.popleft(not_fixed)
        not_fixed -= {(y, x)}

        img[y][x] = 0
        new_possible_rows, new_possible_columns = reason(possible_rows, possible_columns, y, x, 0)

        if all(new_possible_rows) and all(new_possible_columns):
            result = solve_backtrack(new_possible_rows, new_possible_columns)

            if result is not None:
                return result
            else:
                img[y][x] = 1
                result = solve_backtrack(possible_rows, possible_columns)

                if result is not None:
                    return result

        not_fixed |= {(y, x)}
        # deque.append(not_fixed, (y, x))
        return None

    return solve_backtrack(possible_rows, possible_columns)


def read_from_data(data):
    h, w = [int(literal) for literal in data.readline().split()]
    rows_and_columns = [[int(literal) for literal in line.split()] for line in data.readlines()]
    assert len(rows_and_columns) == h + w
    rows, columns = rows_and_columns[:h], rows_and_columns[h:]
    return rows, columns


def read_input(filename):
    if filename:
        with open(filename) as data:
            return read_from_data(data)
    else:
        return read_from_data(stdin)


def solve_from_file(filename):
    rows, columns = read_input(filename)
    print_img(solve1(rows, columns))


def default_solve_from_file(case):
    rows, columns = read_input('tests/1.' + str(case) + '.in')
    print_img(solve1(rows, columns))

solve_from_file('zad_input.txt')
