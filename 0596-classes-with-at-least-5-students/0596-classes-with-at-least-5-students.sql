# Write your MySQL query state
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5;