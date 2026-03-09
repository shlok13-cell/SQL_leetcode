class Solution:
    def longestCommonPrefix(self, strs):
        
        if not strs:
            return ""
        
        prefix = ""
        
        for i in range(len(strs[0])):   # check characters of first string
            
            for s in strs:
                if i >= len(s) or s[i] != strs[0][i]:
                    return prefix
            
            prefix += strs[0][i]
        
        return prefix