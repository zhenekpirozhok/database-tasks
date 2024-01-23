-- 1. Create a view called "sales_revenue_by_category_qtr" that shows the film 
-- category and total sales revenue for the current quarter. The view should 
-- only display categories with at least one sale in the current quarter. 
-- The current quarter should be determined dynamically.

CREATE OR REPLACE VIEW sales_revenue_by_category_qtr AS
SELECT SUM(amount), c.name
FROM payment
JOIN rental USING(rental_id)
JOIN inventory USING(inventory_id)
JOIN film_category USING(film_id)
JOIN category c USING(category_id)
WHERE 
	EXTRACT(QUARTER FROM payment_date) = EXTRACT(QUARTER FROM CURRENT_DATE)
	AND EXTRACT(YEAR FROM payment_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY c.name;

-- 2. Create a query language function called "get_sales_revenue_by_category_qtr" 
-- that accepts one parameter representing the current quarter and returns 
-- the same result as the "sales_revenue_by_category_qtr" view.

CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(cur_quarter INT, cur_year INT)
RETURNS TABLE 
(
	category_name TEXT,
	revenue NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
		SELECT c.name, SUM(amount)
		FROM payment
		JOIN rental USING(rental_id)
		JOIN inventory USING(inventory_id)
		JOIN film_category USING(film_id)
		JOIN category c USING(category_id)
		WHERE 
			EXTRACT(QUARTER FROM payment_date) = cur_quarter
			AND EXTRACT(YEAR FROM payment_date) = cur_year
		GROUP BY c.name;
END;$$

-- 3. Create a procedure language function called "new_movie" that takes 
-- a movie title as a parameter and inserts a new movie with the given title 
-- in the film table. The function should generate a new unique film ID, 
-- set the rental rate to 4.99, the rental duration to three days, 
-- the replacement cost to 19.99, the release year to the current year, 
-- and "language" as Klingon. The function should also verify that the 
-- language exists in the "language" table. Then, ensure that no such 
-- function has been created before; if so, replace it.

CREATE OR REPLACE PROCEDURE new_movie(movie_title TEXT)
LANGUAGE plpgsql
AS $$
DECLARE
    language_id INT;
    currentYear INT := EXTRACT(YEAR FROM CURRENT_DATE);
BEGIN
    SELECT INTO language_id l.language_id FROM language l WHERE name = 'Klingon';
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Language not found';
    END IF;

    INSERT INTO film (title, language_id, rental_rate, rental_duration, replacement_cost, release_year)
    VALUES (movie_title, language_id, 4.99, 3, 19.99, currentYear);
END;
$$

-- Example usage

SELECT *
FROM sales_revenue_by_category_qtr;

SELECT * 
FROM get_sales_revenue_by_category_qtr(2, 2017);

CALL new_movie('Princess and the frog');
