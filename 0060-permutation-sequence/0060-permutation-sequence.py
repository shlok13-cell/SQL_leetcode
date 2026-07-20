from math import factorial

class Solution:
    def getPermutation(self, n: int, k: int) -> str:
        nums = [str(i) for i in range(1, n + 1)]
        ans = []

        k -= 1      # Convert to 0-based index

        for i in range(n, 0, -1):
            fact = factorial(i - 1)

            index = k // fact
            ans.append(nums[index])

            nums.pop(index)
            k %= fact

        return "".join(ans)