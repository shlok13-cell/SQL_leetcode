WITH RECURSIVE words AS (
    SELECT 
        content_id,
        content_text,
        1 AS pos,
        SUBSTRING_INDEX(content_text, ' ', 1) AS word,
        SUBSTRING(content_text, LENGTH(SUBSTRING_INDEX(content_text, ' ', 1)) + 2) AS rest
    FROM user_content

    UNION ALL

    SELECT 
        content_id,
        content_text,
        pos + 1,
        SUBSTRING_INDEX(rest, ' ', 1),
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ' ', 1)) + 2)
    FROM words
    WHERE rest <> ''
),

processed AS (
    SELECT 
        content_id,
        pos,
        CASE 
            -- ✅ VALID hyphenated word
            WHEN word REGEXP '^[A-Za-z]+(-[A-Za-z]+)+$' THEN
                (
                    SELECT GROUP_CONCAT(
                        CONCAT(
                            UPPER(LEFT(part,1)),
                            LOWER(SUBSTRING(part,2))
                        )
                        ORDER BY idx SEPARATOR '-'
                    )
                    FROM (
                        SELECT 
                            SUBSTRING_INDEX(SUBSTRING_INDEX(word, '-', n), '-', -1) AS part,
                            n AS idx
                        FROM (
                            SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
                        ) nums
                        WHERE n <= 1 + LENGTH(word) - LENGTH(REPLACE(word, '-', ''))
                    ) t
                )

            -- ❌ INVALID → treat whole word
            ELSE CONCAT(
                UPPER(LEFT(word,1)),
                LOWER(SUBSTRING(word,2))
            )
        END AS new_word
    FROM words
)

SELECT 
    u.content_id,
    u.content_text AS original_text,
    GROUP_CONCAT(p.new_word ORDER BY p.pos SEPARATOR ' ') AS converted_text
FROM user_content u
JOIN processed p 
ON u.content_id = p.content_id
GROUP BY u.content_id, u.content_text;