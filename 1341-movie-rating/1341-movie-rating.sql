# Write your MySQL query statement below
(
    -- 1. User who rated the greatest number of movies
    SELECT u.name AS results
    FROM Users u
    JOIN MovieRating m ON u.user_id = m.user_id
    GROUP BY u.user_id, u.name
    ORDER BY COUNT(*) DESC, u.name ASC
    LIMIT 1
)

UNION ALL

(
    -- 2. Movie with highest average rating in Feb 2020
    SELECT mv.title AS results
    FROM Movies mv
    JOIN MovieRating m ON mv.movie_id = m.movie_id
    WHERE m.created_at >= '2020-02-01'
      AND m.created_at <= '2020-02-29'
    GROUP BY mv.movie_id, mv.title
    ORDER BY AVG(m.rating) DESC, mv.title ASC
    LIMIT 1
);