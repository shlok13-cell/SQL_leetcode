class Solution(object):
    def maxProfit(self, prices):
        min_price = float
        max_profit = 0

        for price in prices:
            # update price if found new min
            if price < min_price:
                min_price = price
            # Calculate profit 
            else:
                profit = price - min_price
                max_profit = max(max_profit, profit)

        return max_profit