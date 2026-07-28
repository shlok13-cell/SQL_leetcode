import math
from typing import List

class Solution:
    def numPoints(self, darts: List[List[int]], r: int) -> int:
        n = len(darts)

        if n == 1:
            return 1

        ans = 1

        def count_points(cx, cy):
            cnt = 0
            for x, y in darts:
                if (x - cx) ** 2 + (y - cy) ** 2 <= r * r + 1e-7:
                    cnt += 1
            return cnt

        for i in range(n):
            x1, y1 = darts[i]

            for j in range(i + 1, n):
                x2, y2 = darts[j]

                dx = x2 - x1
                dy = y2 - y1

                d = math.hypot(dx, dy)

                
                if d > 2 * r:
                    continue

                
                mx = (x1 + x2) / 2.0
                my = (y1 + y2) / 2.0

                
                h = math.sqrt(r * r - (d / 2) ** 2)

                
                ux = -dy / d
                uy = dx / d

               
                cx1 = mx + h * ux
                cy1 = my + h * uy
                ans = max(ans, count_points(cx1, cy1))

                
                cx2 = mx - h * ux
                cy2 = my - h * uy
                ans = max(ans, count_points(cx2, cy2))

        return ans