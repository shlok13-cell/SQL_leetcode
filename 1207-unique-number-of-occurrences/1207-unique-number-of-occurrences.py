class Solution:
    def uniqueOccurrences(self, arr):
        count = {}

        for num in arr:
            count[num] = count.get(num, 0) + 1

        return len(count.values()) == len(set(count.values()))