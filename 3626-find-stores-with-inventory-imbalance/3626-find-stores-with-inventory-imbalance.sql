# Write your MySQL query statement below
WITH ranked AS (
    SELECT
        store_id,
        product_name,
        quantity,
        price,
        ROW_NUMBER() OVER (
            PARTITION BY store_id
            ORDER BY price DESC
        ) AS expensive_rank,
        ROW_NUMBER() OVER (
            PARTITION BY store_id
            ORDER BY price ASC
        ) AS cheap_rank,
        COUNT(*) OVER (
            PARTITION BY store_id
        ) AS product_count
    FROM inventory
)

SELECT
    s.store_id,
    s.store_name,
    s.location,
    e.product_name AS most_exp_product,
    c.product_name AS cheapest_product,
    ROUND(c.quantity * 1.0 / e.quantity, 2) AS imbalance_ratio
FROM stores s
JOIN ranked e
    ON s.store_id = e.store_id
   AND e.expensive_rank = 1
JOIN ranked c
    ON s.store_id = c.store_id
   AND c.cheap_rank = 1
WHERE
    e.product_count >= 3
    AND e.quantity < c.quantity
ORDER BY
    imbalance_ratio DESC,
    s.store_name ASC;