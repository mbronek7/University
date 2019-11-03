from queue import Queue

import task2
import solver


class HigherLevelSokoban:

    def __init__(self, lower_level_sokoban):
        self.lower_level_sokoban = lower_level_sokoban

    def gen_new_states_with_priority(self, state_with_priority):
        _, state = state_with_priority
        for new_state, action in self.get_possible_changes(state):
            heuristic = self.get_heuristic(new_state)
            yield (heuristic, new_state), action
        
    def get_heuristic(self, state):
        _, crates_ordered = state
        return max(
            min(abs(cx - x) + abs(cy - y) for x, y in self.lower_level_sokoban.destinations)
            for cx, cy in crates_ordered
        )

    def get_possible_changes(self, state):
        """Basically a BFS but finds all goals instead of the first one."""
        to_visit = Queue()
        visited = {state}
        meta = {}

        to_visit.put(state)

        while not to_visit.empty():
            sub_root = to_visit.get()
            if sub_root[1] != state[1]:  # crate was moved
                movements = solver.construct_path(sub_root, meta)
                yield sub_root, ''.join(movements)

            for child, movement in self.lower_level_sokoban.gen_new_states(sub_root):
                if child in visited:
                    continue
                meta[child] = (sub_root, movement)
                to_visit.put(child)
                visited.add(sub_root)


if __name__ == '__main__':
    with open('zad_input.txt') as inp:
        lower_level_sokoban = task2.Sokoban.from_map(inp)
        game = HigherLevelSokoban(lower_level_sokoban)

    solution = solver.find_solution_with_priority(
        root=(0, lower_level_sokoban.initial_state),
        is_goal=lower_level_sokoban.is_a_win,
        get_successors=game.gen_new_states_with_priority,
    )  # Best-First search in this case

    solution_str = ''.join(solution)
    print(solution_str, len(solution_str))  # for insight

    with open('zad_output.txt', 'w+') as out:
        out.write(solution_str)
