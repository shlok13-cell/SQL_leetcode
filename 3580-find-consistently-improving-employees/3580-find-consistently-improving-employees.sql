# Write your MySQL query statement below
WITH last_three AS (
    SELECT
        employee_id,
        review_date,
        rating,
        ROW_NUMBER() OVER (
            PARTITION BY employee_id
            ORDER BY review_date DESC
        ) AS rn
    FROM performance_reviews
),

reviews AS (
    SELECT
        employee_id,
        MAX(CASE WHEN rn = 3 THEN rating END) AS r1,
        MAX(CASE WHEN rn = 2 THEN rating END) AS r2,
        MAX(CASE WHEN rn = 1 THEN rating END) AS r3,
        COUNT(*) AS cnt
    FROM last_three
    WHERE rn <= 3
    GROUP BY employee_id
)

SELECT
    e.employee_id,
    e.name,
    (r3 - r1) AS improvement_score
FROM reviews r
JOIN employees e
    ON e.employee_id = r.employee_id
WHERE cnt = 3
  AND r1 < r2
  AND r2 < r3
ORDER BY improvement_score DESC, name ASC;