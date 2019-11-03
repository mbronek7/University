from collections import deque
from random import choice


fields = wall, goal, start, start_goal, empty = '#GSB '
directions = up, down, left, right = 'UDLR'
neg_dir = {up: down, down: up, left: right, right: left, None: None}
dir_to_displacement = {up: (-1, 0), down: (1, 0), left: (0, -1), right: (0, 1)}


def print_board(board):
    for row in board:
        print(''.join(row))

def possible_start_possitions(board):
    possibilities = set()

    for y in range(len(board)):
        row = board[y] # dla kazdego wiersza

        for x in range(len(row)): # dla kazdej pozycji w wierszu
            if row[x] == start:
                possibilities |= {(y, x)}
                row[x] = empty
            elif row[x] == start_goal:
                possibilities |= {(y, x)}
                row[x] = goal
    return tuple(tuple(row) for row in board), tuple(possibilities)


def move(board, possibilities, direction):
    dy, dx = dir_to_displacement[direction]
    return tuple(set((y + dy, x + dx) if board[y + dy][x + dx] != wall else (y, x) for y, x in possibilities))

#losowa/zachanne ruchy zmniejszajce niepewność | sekwencja ruchow po to by ograniczyc mozliwe miejsca startowe do 2
# po tej sekwencji zostaną mi dwie pozycje na ktorychmoglem sobie stanac
def random_reduce_number_of_possible_positions(board, possibilities):
    moves = ''
    direction = None

    while len(possibilities) > 2:
        direction = choice([new_direction for new_direction in directions if new_direction != neg_dir[direction]])
        moves += direction
        possibilities = move(board, possibilities, direction)
    return moves, possibilities

def solved(board, possibilities):
    return all(board[y][x] == goal for y, x in possibilities)

def solve_bfs(board, possibilities, max_moves_count):
    queue = deque([(possibilities, '')])
    checked = {possibilities}

    while True:
        current_possibilities, path = queue.popleft()
        if solved(board, current_possibilities) or len(path) > max_moves_count:
            return path

        for direction in directions:
            new_possibilities = move(board, current_possibilities, direction)

            if new_possibilities not in checked:
                queue.append((new_possibilities, path + direction))
                checked |= {new_possibilities}


def solve(board, possibilities, max_moves_count):
    moves, possibilities = random_reduce_number_of_possible_positions(board, possibilities)
    return moves + solve_bfs(board, possibilities, max_moves_count - len(moves)) # zwracam to co dało mi dojscie do 2 mozliwych pozycji startowych + wynik z BFS-a

def read_data(filename):
    with open(filename) as data:
        return [[ch for ch in line if ch in fields] for line in data.readlines()]

def solve_from_file(filename, max_moves_count):
    board = read_data(filename)
    board, possibilities = possible_start_possitions (board)

    while True:
        path = solve(board, possibilities, max_moves_count)
        path_len = len(path)

        if path_len <= max_moves_count:
            return path

file = open("zad_output.txt", "w")
file.write(solve_from_file('zad_input.txt', 150))