DELETE FROM rental
WHERE inventory_id IN (
	SELECT inventory_id
	WHERE film_id = (
		SELECT MAX(film_id)
		FROM film
	)
);

DELETE FROM inventory
WHERE film_id = (
	SELECT MAX(film_id)
	FROM film
);

DELETE FROM payment
WHERE customer_id = 427;

DELETE FROM rental
WHERE customer_id = 427;