from typing import List

class Solution:
    def maxOperations(self, nums: List[int], k: int) -> int:
        nums.sort()
        left, right = 0, len(nums) - 1
        ans = 0

        while left < right:
            s = nums[left] + nums[right]

            if s == k:
                ans += 1
                left += 1
                right -= 1
            elif s < k:
                left += 1
            else:
                right -= 1

        return ans