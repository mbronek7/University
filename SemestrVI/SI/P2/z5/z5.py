from queue import PriorityQueue
from random import choice
from sys import stdin


fields = wall, goal, start, start_goal, empty = '#GSB '
directions = up, down, left, right = 'UDLR'
neg_dir = {up: down, down: up, left: right, right: left, None: None}
dir_to_displacement = {up: (-1, 0), down: (1, 0), left: (0, -1), right: (0, 1)}


def print_board(board):
    for row in board:
        print(''.join(row))

def bfs(s, e, i, visited):
    frontier = PriorityQueue()
    while s != e:
        for direction in directions:
            dy, dx = dir_to_displacement[direction]
            new_x = s[1] + dx
            new_y = s[0] + dy
            point = tuple((new_y,new_x))
            if i[new_y][new_x] != wall and point not in visited:
                frontier.put(point)
        visited.append(s)
        s = frontier.get()
    return visited

def possilble_start_positions(board):
    possibilities = set()

    for y in range(len(board)):
        row = board[y]

        for x in range(len(row)):
            if row[x] == start:
                possibilities |= {(y, x)}
                row[x] = empty
            elif row[x] == start_goal:
                possibilities |= {(y, x)}
                row[x] = goal

    return tuple(tuple(row) for row in board), tuple(possibilities)


def move(board, possibilities, direction):
    dy, dx = dir_to_displacement[direction]
    return tuple({(y + dy, x + dx) if board[y + dy][x + dx] != wall else (y, x) for y, x in possibilities})


def solved(board, possibilities):
    return all(board[y][x] in {goal, start_goal} for y, x in possibilities)

# wypisz wszystkie punkty docelowe
def get_goals(board):
    return {(y, x) for y in range(len(board)) for x in range(len(board[0])) if board[y][x] == goal}


def solve(board, possibilities, heuristic):
    queue = PriorityQueue()
    goals = get_goals(board)
    queue.put_nowait((heuristic(goals, possibilities, board), 0, possibilities, ''))
    checked = {possibilities}

    while True:
        _, cost, current_possibilities, path = queue.get_nowait()

        for direction in directions:
            new_possibilities = move(board, current_possibilities, direction)

            if new_possibilities not in checked:
                checked |= {new_possibilities}
                new_path = path + direction

                if not solved(board, new_possibilities):
                    new_cost = cost + 1
                    queue.put_nowait((new_cost + heuristic(goals, new_possibilities, board), new_cost, new_possibilities, new_path))
                else:
                    return new_path


def manhattan_dist(pos0, pos1):
    y0, x0 = pos0
    y1, x1 = pos1
    return abs(y0 - y1) + abs(x0 - x1)

def get_path_to_goals(pos, goal, board):
    print(len(bfs(goal, pos, board, [])))
    return len(bfs(goal, pos, board, []))

def best_goal_dist(goals, pos, board):
    return min(get_path_to_goals(pos, goal, board) for goal in goals)


def best_dist_sum(goals, possibilities):     # NOT OPTIMISTIC
    return sum(best_goal_dist(goals, pos) for pos in possibilities)


def max_best_dist(goals, possibilities, board):
    return max(best_goal_dist(goals, pos, board) for pos in possibilities)


def max_best_dist_mult_poss(goals, possibilities, board):       # NOT OPTIMISTIC
    return max_best_dist(goals, possibilities, board) * len(possibilities)


def count_poss_not_on_goals(goals, possibilities):      # NOT OPTIMISTIC
    return len(set(possibilities) - set(goals))


def read_data(filename):
    with open(filename) as data:
        return [[ch for ch in line if ch in fields] for line in data.readlines()]


def solve_from_file(filename, heuristic):
    board = read_data(filename)
    board, possibilities = possilble_start_positions(board)
    path = solve(board, possibilities, heuristic)
    return path


file = open("zad_output.txt", "w")
file.write(solve_from_file('zad_input.txt', max_best_dist_mult_poss))
# file.write(solve_from_file(None, max_best_dist_mult_poss))        # z6
