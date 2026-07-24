class Solution:
    def processStr(self, s: str, k: int) -> str:
        lengths = []
        length = 0

        # Compute the length after each operation
        for ch in s:
            if 'a' <= ch <= 'z':
                length += 1
            elif ch == '*':
                if length > 0:
                    length -= 1
            elif ch == '#':
                length *= 2
            elif ch == '%':
                pass
            lengths.append(length)

        if k >= length:
            return '.'

        # Walk backwards to locate the kth character
        for i in range(len(s) - 1, -1, -1):
            ch = s[i]
            prev = lengths[i - 1] if i > 0 else 0
            cur = lengths[i]

            if 'a' <= ch <= 'z':
                # This character was appended
                if cur == prev + 1 and k == cur - 1:
                    return ch
                # Otherwise, k stays the same

            elif ch == '#':
                # Result became old + old
                if prev > 0 and k >= prev:
                    k -= prev

            elif ch == '%':
                # Reverse
                if prev > 0:
                    k = prev - 1 - k

            else:  # '*'
                # Deleted the last character; surviving indices are unchanged
                pass

        return '.'