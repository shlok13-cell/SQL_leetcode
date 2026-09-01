class Solution:
    def equalPairs(self, grid):
        n = len(grid)

        rows = {}

        # Store rows
        for row in grid:
            row = tuple(row)
            rows[row] = rows.get(row, 0) + 1

        ans = 0

        # Check columns
        for j in range(n):
            column = []

            for i in range(n):
                column.append(grid[i][j])

            column = tuple(column)

            if column in rows:
                ans += rows[column]

        return ans