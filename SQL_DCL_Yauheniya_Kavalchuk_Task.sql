CREATE USER rentaluser WITH PASSWORD 'rentalpassword';

GRANT SELECT ON customer TO rentaluser;

SELECT * FROM film;

CREATE GROUP rental; 

GRANT SELECT, INSERT, UPDATE ON TABLE rental TO rental;
GRANT USAGE, SELECT ON SEQUENCE rental_rental_id_seq TO rental;

ALTER GROUP rental ADD USER rentaluser;

INSERT INTO rental (
	rental_date,
	inventory_id,
	customer_id,
	return_date,
	staff_id,
	last_update
)
VALUES (
	CURRENT_DATE,
	33, 
	2,
	'14.02.2024'::DATE,
	3,
	CURRENT_DATE
);

UPDATE rental
SET return_date = CURRENT_DATE,
last_update = CURRENT_DATE
WHERE rental_id = 50;

REVOKE INSERT ON rental FROM rental;

ALTER TABLE payment ENABLE ROW LEVEL SECURITY;
ALTER TABLE rental ENABLE ROW LEVEL SECURITY;

CREATE GROUP clients;

GRANT SELECT ON customer TO clients;

CREATE OR REPLACE PROCEDURE create_customer_roles()
LANGUAGE plpgsql
AS $$
DECLARE 
    username TEXT;
	user_id INT;
BEGIN
    FOR username, user_id IN (
        SELECT LOWER(CONCAT_WS('_', 'client', first_name, last_name)) AS username,
		c.customer_id as user_id
        FROM customer c
        WHERE EXISTS (
            SELECT 1
            FROM rental r
            WHERE r.customer_id = c.customer_id
        ) AND EXISTS (
            SELECT 1
            FROM payment p
            WHERE p.customer_id = c.customer_id
        )
    )
    LOOP
		IF username IS NULL OR username = '' THEN
			RAISE EXCEPTION 'Invalid username';
		END IF;

		-- Check if the role already exists
		IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = username) THEN
			EXECUTE 'CREATE ROLE ' || username;
		END IF;

		
		EXECUTE 'GRANT ' || username || ' TO clients';
        
        -- Grant usage on public schema
        EXECUTE 'GRANT USAGE ON SCHEMA public TO ' || username;
        
        -- Grant select privileges on rental and payment tables
        EXECUTE 'GRANT SELECT ON TABLE rental TO ' || username;
        EXECUTE 'GRANT SELECT ON TABLE payment TO ' || username;
        
        -- Set role to the user
        EXECUTE 'ALTER USER ' || username || ' SET ROLE ' || username;

		EXECUTE 'CREATE POLICY ' || username || '_payment_policy ON payment FOR SELECT TO ' || username ||
			' USING (customer_id = ' || user_id || ')';
			
		EXECUTE 'CREATE POLICY ' || username || '_rental_policy ON rental FOR SELECT TO ' || username ||
			' USING (customer_id = ' || user_id || ')';

    END LOOP;
END;
$$;

-- Execute the stored procedure
CALL create_customer_roles();

SELECT * FROM payment;
