# Write your MySQL query statement below
WITH user_summary AS (
    SELECT
        user_id,
        MIN(event_date) AS first_date,
        MAX(event_date) AS last_date,
        MAX(monthly_amount) AS max_historical_amount,
        SUM(CASE WHEN event_type = 'downgrade' THEN 1 ELSE 0 END) AS downgrade_count
    FROM subscription_events
    GROUP BY user_id
),

latest_event AS (
    SELECT
        user_id,
        plan_name AS current_plan,
        monthly_amount AS current_monthly_amount,
        event_type,
        event_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_date DESC, event_id DESC
        ) AS rn
    FROM subscription_events
)

SELECT
    l.user_id,
    l.current_plan,
    l.current_monthly_amount,
    u.max_historical_amount,
    DATEDIFF(u.last_date, u.first_date) AS days_as_subscriber
FROM latest_event l
JOIN user_summary u
    ON l.user_id = u.user_id
WHERE l.rn = 1
    AND l.event_type <> 'cancel'
    AND u.downgrade_count >= 1
    AND l.current_monthly_amount < 0.5 * u.max_historical_amount
    AND DATEDIFF(u.last_date, u.first_date) >= 60
ORDER BY days_as_subscriber DESC, l.user_id ASC;