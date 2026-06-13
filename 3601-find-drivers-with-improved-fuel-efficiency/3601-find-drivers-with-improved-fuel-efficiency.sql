# Write your MySQL query statement below
WITH efficiency AS (
    SELECT
        driver_id,
        CASE
            WHEN MONTH(trip_date) BETWEEN 1 AND 6
                THEN distance_km / fuel_consumed
        END AS first_half_eff,
        CASE
            WHEN MONTH(trip_date) BETWEEN 7 AND 12
                THEN distance_km / fuel_consumed
        END AS second_half_eff
    FROM trips
),
driver_avg AS (
    SELECT
        driver_id,
        AVG(first_half_eff) AS first_half_avg,
        AVG(second_half_eff) AS second_half_avg
    FROM efficiency
    GROUP BY driver_id
)
SELECT
    d.driver_id,
    d.driver_name,
    ROUND(da.first_half_avg, 2) AS first_half_avg,
    ROUND(da.second_half_avg, 2) AS second_half_avg,
    ROUND(da.second_half_avg - da.first_half_avg, 2) AS efficiency_improvement
FROM driver_avg da
JOIN drivers d
    ON d.driver_id = da.driver_id
WHERE da.first_half_avg IS NOT NULL
  AND da.second_half_avg IS NOT NULL
  AND da.second_half_avg > da.first_half_avg
ORDER BY efficiency_improvement DESC,
         d.driver_name ASC;