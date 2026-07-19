class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        i = 0          # pointer for s
        j = 0          # pointer for p
        star = -1      # last '*' position in p
        match = 0      # position in s when '*' was found

        while i < len(s):
            # Characters match or '?'
            if j < len(p) and (p[j] == s[i] or p[j] == '?'):
                i += 1
                j += 1

            # Found '*'
            elif j < len(p) and p[j] == '*':
                star = j
                match = i
                j += 1

            # Mismatch, backtrack to last '*'
            elif star != -1:
                j = star + 1
                match += 1
                i = match

            # No '*' to backtrack
            else:
                return False

        # Remaining pattern should only contain '*'
        while j < len(p) and p[j] == '*':
            j += 1

        return j == len(p)