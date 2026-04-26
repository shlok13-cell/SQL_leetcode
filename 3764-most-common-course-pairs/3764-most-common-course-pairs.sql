# Write your MySQL query statement below
WITH TopPerformers AS (
    -- Identify top-performing students
    SELECT user_id
    FROM course_completions
    GROUP BY user_id
    HAVING COUNT(course_id) >= 5 AND AVG(course_rating) >= 4.0
),
ConsecutiveCourses AS (
    -- Get chronological pair sequences for top performers
    SELECT 
        c.user_id,
        c.course_name AS first_course,
        LEAD(c.course_name) OVER (PARTITION BY c.user_id ORDER BY c.completion_date) AS second_course
    FROM course_completions c
    INNER JOIN TopPerformers tp ON c.user_id = tp.user_id
)
-- Count and sort the pairs
SELECT 
    first_course,
    second_course,
    COUNT(*) AS transition_count
FROM ConsecutiveCourses
WHERE second_course IS NOT NULL
GROUP BY first_course, second_course
ORDER BY transition_count DESC, first_course ASC, second_course ASC;
