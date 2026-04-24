WITH ordered AS (
    SELECT 
        s.*,
        ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY session_date) AS rn,
        DATEDIFF(session_date,
            LAG(session_date) OVER (PARTITION BY student_id ORDER BY session_date)
        ) AS gap
    FROM study_sessions s
),

valid AS (
    SELECT *
    FROM ordered
    WHERE gap IS NULL OR gap <= 2
),

grouped AS (
    SELECT 
        student_id,
        COUNT(*) AS total_sessions,
        COUNT(DISTINCT subject) AS cycle_length,
        SUM(hours_studied) AS total_hours
    FROM valid
    GROUP BY student_id
    HAVING COUNT(*) >= 6 AND COUNT(DISTINCT subject) >= 3
),

-- Assign position inside cycle
cycle_mark AS (
    SELECT 
        v.*,
        g.cycle_length,
        ((v.rn - 1) % g.cycle_length) AS pos
    FROM valid v
    JOIN grouped g ON v.student_id = g.student_id
),

-- Check repeating pattern
pattern_check AS (
    SELECT 
        c1.student_id,
        COUNT(*) AS mismatches
    FROM cycle_mark c1
    JOIN cycle_mark c2
        ON c1.student_id = c2.student_id
        AND c1.pos = c2.pos
        AND c1.rn > c2.rn
    WHERE c1.subject != c2.subject
    GROUP BY c1.student_id
)

SELECT 
    st.student_id,
    st.student_name,
    st.major,
    g.cycle_length,
    g.total_hours AS total_study_hours
FROM grouped g
JOIN students st ON st.student_id = g.student_id
LEFT JOIN pattern_check pc ON pc.student_id = g.student_id
WHERE pc.mismatches IS NULL
ORDER BY 
    g.cycle_length DESC,
    g.total_hours DESC;