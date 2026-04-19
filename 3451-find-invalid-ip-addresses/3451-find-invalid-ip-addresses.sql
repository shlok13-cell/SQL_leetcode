# Write your MySQL query statement below
WITH split_ip AS (
    SELECT 
        log_id,
        ip,
        SUBSTRING_INDEX(ip, '.', 1) AS o1,
        SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 2), '.', -1) AS o2,
        SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 3), '.', -1) AS o3,
        SUBSTRING_INDEX(ip, '.', -1) AS o4,
        LENGTH(ip) - LENGTH(REPLACE(ip, '.', '')) + 1 AS parts
    FROM logs
),
invalid_ip AS (
    SELECT ip
    FROM split_ip
    WHERE 
        parts != 4
        OR o1 NOT REGEXP '^[0-9]+$' OR o2 NOT REGEXP '^[0-9]+$' 
        OR o3 NOT REGEXP '^[0-9]+$' OR o4 NOT REGEXP '^[0-9]+$'
        OR CAST(o1 AS UNSIGNED) > 255
        OR CAST(o2 AS UNSIGNED) > 255
        OR CAST(o3 AS UNSIGNED) > 255
        OR CAST(o4 AS UNSIGNED) > 255
        OR (LENGTH(o1) > 1 AND LEFT(o1,1) = '0')
        OR (LENGTH(o2) > 1 AND LEFT(o2,1) = '0')
        OR (LENGTH(o3) > 1 AND LEFT(o3,1) = '0')
        OR (LENGTH(o4) > 1 AND LEFT(o4,1) = '0')
)
SELECT 
    ip,
    COUNT(*) AS invalid_count
FROM invalid_ip
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC;