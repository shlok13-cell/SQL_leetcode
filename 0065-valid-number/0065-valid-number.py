class Solution:
    def isNumber(self, s: str) -> bool:
        seen_digit = False
        seen_dot = False
        seen_exp = False
        digit_after_exp = True

        for i, ch in enumerate(s):
            if ch.isdigit():
                seen_digit = True
                if seen_exp:
                    digit_after_exp = True

            elif ch in ['+', '-']:
                # Sign is valid only at the beginning
                # or immediately after e/E
                if i > 0 and s[i - 1] not in ['e', 'E']:
                    return False

            elif ch == '.':
                # Dot can't appear after exponent
                # or more than once
                if seen_dot or seen_exp:
                    return False
                seen_dot = True

            elif ch in ['e', 'E']:
                # Exponent can't appear twice
                # and must follow at least one digit
                if seen_exp or not seen_digit:
                    return False
                seen_exp = True
                digit_after_exp = False

            else:
                return False

        return seen_digit and digit_after_exp