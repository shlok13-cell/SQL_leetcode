from typing import List
from bisect import bisect_left

class Solution:
    def gcdValues(self, nums: List[int], queries: List[int]) -> List[int]:
        MAX = max(nums)

        # Frequency of each value
        freq = [0] * (MAX + 1)
        for x in nums:
            freq[x] += 1

        # cnt[d] = numbers divisible by d
        cnt = [0] * (MAX + 1)
        for d in range(1, MAX + 1):
            for multiple in range(d, MAX + 1, d):
                cnt[d] += freq[multiple]

        # exact[d] = number of pairs with gcd exactly d
        exact = [0] * (MAX + 1)

        for d in range(MAX, 0, -1):
            pairs = cnt[d] * (cnt[d] - 1) // 2

            multiple = d * 2
            while multiple <= MAX:
                pairs -= exact[multiple]
                multiple += d

            exact[d] = pairs

        # prefix counts of sorted gcdPairs
        prefix = []
        values = []

        running = 0
        for g in range(1, MAX + 1):
            if exact[g]:
                running += exact[g]
                prefix.append(running)
                values.append(g)

        ans = []
        for q in queries:
            idx = bisect_left(prefix, q + 1)
            ans.append(values[idx])

        return ans