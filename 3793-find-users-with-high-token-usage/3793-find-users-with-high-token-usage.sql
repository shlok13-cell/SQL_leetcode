# Write your MySQL query statement below
WITH user_stats AS (
    SELECT
        user_id,
        COUNT(*) AS prompt_count,
        ROUND(AVG(tokens), 2) AS avg_tokens
    FROM prompts
    GROUP BY user_id
    HAVING COUNT(*) >= 3
)

SELECT
    u.user_id,
    u.prompt_count,
    u.avg_tokens
FROM user_stats u
JOIN prompts p
    ON u.user_id = p.user_id
GROUP BY
    u.user_id,
    u.prompt_count,
    u.avg_tokens
HAVING MAX(p.tokens) > u.avg_tokens
ORDER BY
    u.avg_tokens DESC,
    u.user_id ASC;