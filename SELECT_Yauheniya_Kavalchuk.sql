-- Which staff members made the highest revenue 
-- for each store and deserve a bonus for the year 2017?

-- #1

WITH StoreStaffRevenue AS (
	SELECT st.store_id, SUM(p.amount) AS total_revenue, s.staff_id
	FROM payment AS p
    JOIN staff AS s ON p.staff_id = s.staff_id
    JOIN store AS st ON st.store_id = s.store_id
    WHERE EXTRACT(YEAR FROM p.payment_date) = 2017
    GROUP BY s.staff_id, st.store_id
)

SELECT ssr.store_id, ssr.staff_id, s.first_name, s.last_name, ssr.total_revenue
FROM StoreStaffRevenue ssr
JOIN staff s ON ssr.staff_id = s.staff_id
WHERE (ssr.store_id, ssr.total_revenue) IN (
    SELECT store_id, MAX(total_revenue) AS max_revenue
    FROM StoreStaffRevenue
    GROUP BY store_id
);

-- #2

WITH StoreStaffRevenue AS (
    SELECT
        st.store_id,
        s.staff_id,
        s.first_name,
        s.last_name,
        SUM(p.amount) AS total_revenue,
        RANK() OVER (PARTITION BY st.store_id ORDER BY SUM(p.amount) DESC) AS revenue_rank
    FROM
        payment AS p
        JOIN staff AS s ON p.staff_id = s.staff_id
        JOIN store AS st ON st.store_id = s.store_id
    WHERE
        EXTRACT(YEAR FROM p.payment_date) = 2017
    GROUP BY
        s.staff_id, st.store_id, s.first_name, s.last_name
)

SELECT
    store_id,
    staff_id,
    first_name,
    last_name,
    total_revenue
FROM
    StoreStaffRevenue
WHERE
    revenue_rank = 1;


-- #3

SELECT
    st.store_id,
    s.staff_id,
    s.first_name,
    s.last_name,
    SUM(p.amount) AS total_revenue
FROM
    payment AS p
JOIN
    staff AS s ON p.staff_id = s.staff_id
JOIN
    store AS st ON st.store_id = s.store_id
WHERE
    EXTRACT(YEAR FROM p.payment_date) = 2017
    AND (
        s.staff_id, st.store_id, SUM(p.amount)
    ) IN (
        SELECT
            s_sub.staff_id,
            st_sub.store_id,
            SUM(p_sub.amount) AS total_revenue
        FROM
            payment AS p_sub
        JOIN
            staff AS s_sub ON p_sub.staff_id = s_sub.staff_id
        JOIN
            store AS st_sub ON st_sub.store_id = s_sub.store_id
        WHERE
            EXTRACT(YEAR FROM p_sub.payment_date) = 2017
        GROUP BY
            s_sub.staff_id, st_sub.store_id
        ORDER BY
            total_revenue DESC
        LIMIT 1
    )
GROUP BY
    st.store_id, s.staff_id, s.first_name, s.last_name;


-- Which five movies were rented more than the others, 
-- and what is the expected age of the audience for these movies?

-- #1

SELECT
    COUNT(r.rental_id) AS times_rented,
    f.title,
    f.rating
FROM
    rental r
JOIN
    inventory i USING (inventory_id)
JOIN
    film f USING (film_id)
GROUP BY
    f.title, f.rating
ORDER BY
    COUNT(r.rental_id) DESC
LIMIT 5;

-- #2

WITH MovieRentalCounts AS (
    SELECT
        f.title,
        f.rating,
        COUNT(r.rental_id) AS times_rented,
        ROW_NUMBER() OVER (ORDER BY COUNT(r.rental_id) DESC) AS row_num
    FROM
        rental r
    JOIN
        inventory i USING (inventory_id)
    JOIN
        film f USING (film_id)
    GROUP BY
        f.title, f.rating
)
SELECT
    title,
    rating,
    times_rented
FROM
    MovieRentalCounts
WHERE
    row_num <= 5;

-- #3

SELECT
    f.title,
    f.rating,
    COUNT(r.rental_id) AS times_rented
FROM
    rental r
JOIN
    inventory i USING (inventory_id)
JOIN
    film f USING (film_id)
WHERE
    (f.title, f.rating) IN (
        SELECT
            f_sub.title,
            f_sub.rating
        FROM
            film f_sub
        JOIN
            inventory i_sub USING (film_id)
        JOIN
            rental r_sub USING (inventory_id)
        GROUP BY
            f_sub.title, f_sub.rating
        ORDER BY
            COUNT(r_sub.rental_id) DESC
        LIMIT 5
    )
GROUP BY
    f.title, f.rating
ORDER BY
    times_rented DESC;


-- Which actors/actresses didn't act for a longer period of time than the others?

-- #1

WITH ActorWorkingPeriod AS (
    SELECT
        actor_id,
        CONCAT_WS(' ', first_name, last_name) AS actor_name,
        MAX(release_year) - MIN(release_year) AS work_period
    FROM
        actor ac
        JOIN film_actor fa USING(actor_id)
        JOIN film f USING(film_id)
    GROUP BY
        actor_name, actor_id
)
SELECT
    *
FROM
    ActorWorkingPeriod
WHERE
    work_period <= (
        SELECT
            AVG(work_period)
        FROM
            ActorWorkingPeriod
    )
ORDER BY
    work_period DESC;


-- #2

SELECT
    actor_id,
    CONCAT_WS(' ', first_name, last_name) AS actor_name,
    MAX(release_year) - MIN(release_year) AS work_period
FROM
    actor ac
    JOIN film_actor fa USING(actor_id)
    JOIN film f USING(film_id)
GROUP BY
    actor_id, actor_name
HAVING
    MAX(release_year) - MIN(release_year) <= (
        SELECT
            AVG(MAX(release_year) - MIN(release_year))
        FROM
            actor ac_sub
            JOIN film_actor fa_sub USING(actor_id)
            JOIN film f_sub USING(film_id)
        GROUP BY
            actor_id
    )
ORDER BY
    work_period DESC;
