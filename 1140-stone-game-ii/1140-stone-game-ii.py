class Solution:
    def stoneGameII(self, piles: list[int]) -> int:
        n = len(piles)
        # Suffix sums from the end of the array
        suffix_sum = [0] * (n + 1)
        for i in range(n - 1, -1, -1):
            suffix_sum[i] = suffix_sum[i + 1] + piles[i]
            
        memo = {}
        
        def dp(i: int, m: int) -> int:
            if i + 2 * m >= n:
                return suffix_sum[i]
            if (i, m) in memo:
                return memo[(i, m)]
            
            max_stones = 0
            for x in range(1, 2 * m + 1):
                # Opponent gets dp(i + x, max(m, x)) from the remaining suffix sum
                stones = suffix_sum[i] - dp(i + x, max(m, x))
                max_stones = max(max_stones, stones)
                
            memo[(i, m)] = max_stones
            return max_stones
            
        return dp(0, 1)
