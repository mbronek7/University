from collections import deque
from functools import lru_cache
from math import inf
from random import choice
from sys import stdin


fields = wall, goal, start, start_goal, empty = '#GSB '
directions = up, down, left, right = 'UDLR'
neg_dir = {up: down, down: up, left: right, right: left, None: None}
dir_to_displacement = {up: (-1, 0), down: (1, 0), left: (0, -1), right: (0, 1)}


def print_maze(maze):
    for row in maze:
        print(''.join(row))


def extract_possibilities(maze):
    possibilities = set()

    for y in range(len(maze)):
        row = maze[y]

        for x in range(len(row)):
            if row[x] == start:
                possibilities |= {(y, x)}
                row[x] = empty
            elif row[x] == start_goal:
                possibilities |= {(y, x)}
                row[x] = goal

    return tuple(tuple(row) for row in maze), tuple(possibilities)


@lru_cache(maxsize = None)
def move(maze, possibilities, direction):
    dy, dx = dir_to_displacement[direction]
    return tuple(set((y + dy, x + dx) if maze[y + dy][x + dx] != wall else (y, x) for y, x in possibilities))


def reduce_uncertainty_moves_poss(maze, possibilities, times):
    moves = ''
    last_uncertainty = inf

    for i in range(times):
        dir_to_poss = {}

        for direction in directions:
            dir_to_poss[direction] = move(maze, possibilities, direction)

        best_dir, new_possibilities = min(dir_to_poss.items(), key = lambda p: len(p[1]))
        new_uncertainty = len(new_possibilities)

        if new_uncertainty < last_uncertainty:
            moves += best_dir
            possibilities = new_possibilities
            last_uncertainty = new_uncertainty
        else:       # new_uncertainty is NEVER > last_uncertainty, but it can be ==
            direction = choice(directions)
            moves += direction
            possibilities = dir_to_poss[direction]
            # break

        # if len(possibilities) < 3:
        #     break

    return moves, possibilities


def random_reduce_uncertainty_moves_poss(maze, possibilities):
    moves = ''
    direction = None

    while len(possibilities) > 2:
        direction = choice([new_direction for new_direction in directions if new_direction != neg_dir[direction]])
        moves += direction
        possibilities = move(maze, possibilities, direction)

    return moves, possibilities


def solved(maze, possibilities):
    return all(maze[y][x] == goal for y, x in possibilities)


def solve_bfs(maze, possibilities, max_moves_count):
    queue = deque([(possibilities, '')])
    checked = {possibilities}

    while True:
        current_possibilities, path = queue.popleft()

        if solved(maze, current_possibilities) or len(path) > max_moves_count:      # if len is too big, return incomplete path (it should be rejected anyway)
            return path

        for direction in directions:
            new_possibilities = move(maze, current_possibilities, direction)

            if new_possibilities not in checked:
                queue.append((new_possibilities, path + direction))
                checked |= {new_possibilities}


def solve(maze, possibilities, max_moves_count):
    moves, possibilities = random_reduce_uncertainty_moves_poss(maze, possibilities)
    return moves + solve_bfs(maze, possibilities, max_moves_count - len(moves))


def read_from_data(data):
    return [[ch for ch in line if ch in fields] for line in data.readlines()]


def read_input(filename):
    if filename:
        with open(filename) as data:
            return read_from_data(data)
    else:
        return read_from_data(stdin)


def solve_from_file(filename, max_moves_count):
    maze = read_input(filename)
    maze, possibilities = extract_possibilities(maze)

    while True:
        path = solve(maze, possibilities, max_moves_count)
        path_len = len(path)

        if path_len <= max_moves_count:
            return path_len, path

    move.cache_clear()

file = open("zad_output.txt", "w")

file.write(solve_from_file('zad_input.txt', 150)[1])        # for validator with --stdio