
WITH master_ratings AS (
-- Top 5 movies that have been rated the most with their ratings
    SELECT 
        r.movie_id,
        m.title,
        m.release_date,
        r.user_id,
        r.rating,
        r.rated_at
    FROM 
        ratings as r
    INNER JOIN 
        movies as m ON r.movie_id = m.id
    WHERE
        r.movie_id IN (
                SELECT id
                FROM (
                    SELECT 
                        m.id,
                        count(*) as number_of_reviews,
                        avg(rating) as avg_rating
                    FROM 
                        ratings as r
                    INNER JOIN 
                        movies as m ON r.movie_id = m.id
                    GROUP BY
                        m.id
                    HAVING
                        count(*) > 20
                    ORDER BY
                        avg_rating DESC
                    LIMIT 5) as sub
                    )

),

master_users AS (
    SELECT 
        u.id,
        u.age,
        u.occupation_id,
        o.name as occupation
    FROM 
        users as u
    INNER JOIN 
        occupations as o ON u.occupation_id = o.id
)

SELECT 
    r.title as movie_title,
    r.release_date as release_date,
    u.occupation as name,
    round(avg(rating),3) as rating,
    count(*) as num_ratings,
    round(avg(CASE 
            WHEN rating >= 4 THEN age
            ELSE NULL
        END),0) as good_age,
    round(avg(CASE 
        WHEN rating < 4 THEN age
        ELSE NULL
    END),0) as bad_age
FROM
    master_ratings as r
INNER JOIN
    master_users as u ON r.user_id = u.id
GROUP BY
    movie_title,
    release_date,
    name
