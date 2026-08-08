from typing import List

class Solution:
    def validSequence(self, word1: str, word2: str) -> List[int]:
        n = len(word1)
        m = len(word2)

        # suf[i] = maximum number of characters we can match
        # from word2[i:] using word1 starting at the current position.
        suf = [0] * (n + 1)

        j = m - 1
        for i in range(n - 1, -1, -1):
            if j >= 0 and word1[i] == word2[j]:
                j -= 1
            suf[i] = m - 1 - j

        ans = []
        j = 0
        changed = False

        for i in range(n):
            if j == m:
                break

            # Can take this index if:
            # 1. Characters are equal, OR
            # 2. We haven't used our one allowed change.
            if word1[i] == word2[j]:
                ans.append(i)
                j += 1

            elif not changed:
                # Check whether taking i as the changed character
                # still allows the remaining characters to be matched.
                if suf[i + 1] >= m - j - 1:
                    ans.append(i)
                    j += 1
                    changed = True

        if j == m:
            return ans

        return []