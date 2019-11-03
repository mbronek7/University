from copy import deepcopy
from itertools import permutations
from queue import PriorityQueue, Queue
from time import time


empty, wall, agent, crate, goal, crate_on_goal, agent_on_goal = '.WKBG*+'


def print_board(board):
    for row in board:
        print(''.join(row))


def solved(board):
    return all(crate not in row for row in board)


def agent_move(agent_pos, direction):
    y, x = agent_pos

    if direction == 'U':
        return y-1, x
    elif direction == 'D':
        return y+1, x
    elif direction == 'L':
        return y, x-1
    elif direction == 'R':
        return y, x+1


def remove_crate(board, pos):
    y, x = pos
    if board[y][x] == crate:
        board[y][x] = empty
    elif board[y][x] == crate_on_goal:
        board[y][x] = goal


def add_crate(board, pos):
    y, x = pos
    if board[y][x] == empty:
        board[y][x] = crate
    elif board[y][x] == goal:
        board[y][x] = crate_on_goal


def move(board, agent_pos, direction, allow_pushing):       # allow_pushing indicates if a crate can be pushed (if we control agent) or not (if we control crate)
    h, w = len(board), len(board[0])
    y, x = agent_move(agent_pos, direction)     # new agent position

    if y not in range(h) or x not in range(w):
        return None

    if board[y][x] in {empty, goal}:
        return deepcopy(board), (y, x), direction
    elif board[y][x] == wall:
        return None
    elif board[y][x] in {crate, crate_on_goal}:
        if not allow_pushing:
            return None

        new_setting = move(board, (y, x), direction, False)
        
        if not new_setting:
            return None
        else:
            new_board, new_crate_pos, _ = new_setting
            remove_crate(new_board, (y, x))
            add_crate(new_board, new_crate_pos)
            return new_board, (y, x), direction


def moves(board, agent_pos):
    return [new_setting for direction in 'UDLR' for new_setting in [move(board, agent_pos, direction, True)] if new_setting]


def solve_bfs(board, agent_pos):
    queue = Queue()
    queue.put_nowait((board, agent_pos, ''))
    used_settings = []

    while True:
        board, agent_pos, path = queue.get_nowait()

        if (board, agent_pos) in used_settings:
            continue

        used_settings += [(board, agent_pos)]

        if solved(board):
            return path

        for new_board, new_agent_pos, direction in moves(board, agent_pos):
            if (new_board, new_agent_pos) not in used_settings:
                queue.put_nowait((new_board, new_agent_pos, path + direction))


class Counter:
    def __init__(self):
        self.i = 0

    def counter(self):
        self.i += 1
        return self.i


def trivial_heuristic(board):
    return 0


def count_crates_not_on_goals(board):
    return sum(row.count(crate) for row in board)


def manhattan_distance(pos0, pos1):
    return abs(pos0[0] - pos1[0]) + abs(pos0[1] - pos1[1])


def crates(board):
    h, w = len(board), len(board[-1])       # I'm checking width in last row, because it may be shorter as it may not contain '\n'
    crates = set()
    
    for y in range(h):
        for x in range(w):
            if board[y][x] in {crate, crate_on_goal}:
                crates |= {(y, x)}

    return crates


def goals(board):
    h, w = len(board), len(board[-1])
    goals = set()
    
    for y in range(h):
        for x in range(w):
            if board[y][x] in {goal, crate_on_goal, agent_on_goal}:
                goals |= {(y, x)}

    return goals


def best_manhattan_distance(board):
    return min(sum(manhattan_distance(crate, goal) for crate, goal in zip(crates_perm, goals_perm))
               for crates_perm in permutations(crates(board)) for goals_perm in permutations(goals(board)))


def greedy_manhattan_distance(board):
    crates_list, goals_list = list(crates(board)), list(goals(board))
    distance = 0

    for crate in crates_list:
        distances = [manhattan_distance(crate, goal) for goal in goals_list]
        best_distance = min(distances)
        distance += best_distance
        del goals_list[distances.index(best_distance)]

    return distance


def solve_a_star(board, agent_pos, heuristic):
    queue = PriorityQueue()
    counter = Counter().counter
    queue.put_nowait((heuristic(board), counter(), 0, board, agent_pos, ''))
    used_settings = []

    while True:
        _, _, cost, board, agent_pos, path = queue.get_nowait()

        if (board, agent_pos) in used_settings:
            continue

        if solved(board):
            return path

        used_settings += [(board, agent_pos)]
        new_cost = cost + 1

        for new_board, new_agent_pos, direction in moves(board, agent_pos):
            if (new_board, new_agent_pos) not in used_settings:
                queue.put_nowait((new_cost + heuristic(new_board), counter(), new_cost, new_board, new_agent_pos, path + direction))


def read_file(filename):
    with open(filename) as data:
        lines = [list(line) for line in data.readlines()]

        for i in range(len(lines)):
            line = lines[i]
            if agent in line:
                y = i
                x = line.index(agent)
                line[x] = empty
                break
            elif agent_on_goal in line:
                y = i
                x = line.index(agent_on_goal)
                line[x] = goal
                break

        board = [[ch for ch in line] for line in lines]
        return board, (y, x)



def solve_a_star_from_file(filename, heuristic):
    board, agent_pos = read_file(filename)
    file.write(solve_a_star(board, agent_pos, heuristic))


file = open("zad_output.txt", "w")
solve_a_star_from_file('zad_input.txt', best_manhattan_distance)