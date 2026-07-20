from typing import List

class Solution:
    def shiftGrid(self, grid: List[List[int]], k: int) -> List[List[int]]:
        m = len(grid)
        n = len(grid[0])
        total = m * n

        k %= total

        ans = [[0] * n for _ in range(m)]

        for i in range(m):
            for j in range(n):
                index = i * n + j
                new_index = (index + k) % total

                r = new_index // n
                c = new_index % n

                ans[r][c] = grid[i][j]

        return ans