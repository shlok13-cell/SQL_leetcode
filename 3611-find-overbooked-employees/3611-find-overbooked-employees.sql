# Write your MySQL query statement below
WITH weekly_meetings AS (
    SELECT
        employee_id,
        YEARWEEK(meeting_date, 1) AS week_no,
        SUM(duration_hours) AS total_hours
    FROM meetings
    GROUP BY employee_id, YEARWEEK(meeting_date, 1)
),

meeting_heavy AS (
    SELECT
        employee_id,
        COUNT(*) AS meeting_heavy_weeks
    FROM weekly_meetings
    WHERE total_hours > 20
    GROUP BY employee_id
    HAVING COUNT(*) >= 2
)

SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    mh.meeting_heavy_weeks
FROM meeting_heavy mh
JOIN employees e
ON mh.employee_id = e.employee_id
ORDER BY mh.meeting_heavy_weeks DESC,
         e.employee_name ASC;