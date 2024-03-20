class Maze:
    def __init__(self, rows, cols):
        self.rows = rows
        self.cols = cols
        self.grid = [1,2]

    def generate(self, start_row : int, start_col : int):
        self.grid[start_row][start_col] = ' '
        stack = [(start_row, start_col)]

        while stack:
            current_row, current_col = stack[-1]
            neighbors = self.get_unvisited_neighbors(current_row, current_col)

            if neighbors:
                next_row, next_col = random.choice(neighbors)
                self.grid[next_row][next_col] = ' '
                stack.append((next_row, next_col))
            else:
                stack.pop()

    def get_unvisited_neighbors(self, row, col):
        neighbors = []

        if row > 1 and self.grid[row - 2][col] == '#':
            neighbors.append((row - 2, col))
        if row < self.rows - 2 and self.grid[row + 2][col] == '#':
            neighbors.append((row + 2, col))
        if col > 1 and self.grid[row][col - 2] == '#':
            neighbors.append((row, col - 2))
        if col < self.cols - 2 and self.grid[row][col + 2] == '#':
            neighbors.append((row, col + 2))

        return neighbors

    def display(self):
        return

def main():
    rows : int = 21
    cols : int  = 41
    maze = Maze(rows, cols)
    maze.generate()
    maze.display()

if __name__ == "__main__":
    main()
