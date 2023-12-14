INSERT INTO public.film (
	title,
	description,
	release_year,
	language_id,
	original_language_id,
	rental_duration,
	rental_rate,
	length,
	rating,
	special_features,
	last_update
)
VALUES (
	'The Quantum Banana',
	'In a parallel universe where fruit is the source of all energy, a brilliant scientist discovers a way to travel between dimensions using a banana as a time-traveling device. Chaos ensues when the banana accidentally transports a group of eccentric characters, including a talking cat and a disco-dancing robot, to a medieval kingdom ruled by sentient vegetables.',
	2023,
	1,
	3,
	14,
	4.99,
	240,
	
)

select * from public.film;
