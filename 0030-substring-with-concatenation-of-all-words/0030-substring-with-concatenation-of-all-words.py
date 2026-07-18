from collections import Counter, defaultdict
from typing import List

class Solution:
    def findSubstring(self, s: str, words: List[str]) -> List[int]:
        if not s or not words:
            return []

        word_len = len(words[0])
        num_words = len(words)
        total_len = word_len * num_words

        if len(s) < total_len:
            return []

        word_count = Counter(words)
        result = []

        # Try each possible starting offset
        for offset in range(word_len):
            left = offset
            current = defaultdict(int)
            count = 0

            # Move window one word at a time
            for right in range(offset, len(s) - word_len + 1, word_len):
                word = s[right:right + word_len]

                if word in word_count:
                    current[word] += 1
                    count += 1

                    # Too many occurrences of a word
                    while current[word] > word_count[word]:
                        left_word = s[left:left + word_len]
                        current[left_word] -= 1
                        count -= 1
                        left += word_len

                    # Found a valid window
                    if count == num_words:
                        result.append(left)

                        left_word = s[left:left + word_len]
                        current[left_word] -= 1
                        count -= 1
                        left += word_len

                else:
                    # Reset window
                    current.clear()
                    count = 0
                    left = right + word_len

        return result