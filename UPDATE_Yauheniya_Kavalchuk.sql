UPDATE public.film
SET rental_duration = 21,
rental_rate = 9.99
WHERE title = 'The Quantum Banana';

UPDATE public.customer
SET first_name = 'YAUHENIYA',
last_name = 'KAVALCHUK',
email = 'yauheniyakavalchuk@gmail.com',
address_id = 84
WHERE customer_id = 427;

UPDATE public.customer
SET create_date = CURRENT_DATE
WHERE customer_id = 427;