# Write your MySQL query statement below
WITH reaction_counts AS (
    SELECT
        user_id,
        reaction,
        COUNT(*) AS reaction_count
    FROM reactions
    GROUP BY user_id, reaction
),
user_totals AS (
    SELECT
        user_id,
        COUNT(*) AS total_reactions
    FROM reactions
    GROUP BY user_id
),
ranked AS (
    SELECT
        rc.user_id,
        rc.reaction,
        rc.reaction_count,
        ut.total_reactions,
        ROW_NUMBER() OVER (
            PARTITION BY rc.user_id
            ORDER BY rc.reaction_count DESC, rc.reaction
        ) AS rn
    FROM reaction_counts rc
    JOIN user_totals ut
        ON rc.user_id = ut.user_id
)

SELECT
    user_id,
    reaction AS dominant_reaction,
    ROUND(reaction_count * 1.0 / total_reactions, 2) AS reaction_ratio
FROM ranked
WHERE rn = 1
  AND total_reactions >= 5
  AND reaction_count * 1.0 / total_reactions >= 0.60
ORDER BY reaction_ratio DESC, user_id ASC;