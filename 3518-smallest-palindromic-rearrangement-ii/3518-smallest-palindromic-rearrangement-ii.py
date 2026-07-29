from collections import Counter
from math import comb

class Solution:
    def smallestPalindrome(self, s: str, k: int) -> str:
        LIMIT = k

        cnt = Counter(s)

        half = [0] * 26
        mid = ""

        for ch, v in cnt.items():
            if v & 1:
                mid = ch
            half[ord(ch) - ord('a')] = v // 2

        total = sum(half)

        def count_perm(freq):
            rem = sum(freq)
            ans = 1
            for c in freq:
                if c:
                    ans *= comb(rem, c)
                    if ans > LIMIT:
                        return LIMIT + 1
                    rem -= c
            return ans

        if count_perm(half) < k:
            return ""

        left = []

        for _ in range(total):
            for i in range(26):
                if half[i] == 0:
                    continue

                half[i] -= 1

                ways = count_perm(half)

                if ways >= k:
                    left.append(chr(i + ord('a')))
                    break

                k -= ways
                half[i] += 1

        left = "".join(left)
        return left + mid + left[::-1]