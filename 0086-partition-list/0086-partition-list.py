class Solution:
    def partition(self, head, x):
        less_dummy = ListNode(0)
        greater_dummy = ListNode(0)

        less = less_dummy
        greater = greater_dummy

        while head:
            if head.val < x:
                less.next = head
                less = less.next
            else:
                greater.next = head
                greater = greater.next

            head = head.next

        # End the greater/equal list
        greater.next = None

        # Connect the two lists
        less.next = greater_dummy.next

        return less_dummy.next