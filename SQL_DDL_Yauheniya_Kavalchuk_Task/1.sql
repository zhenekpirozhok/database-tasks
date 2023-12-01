DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS area;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS mountain;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS climb;
DROP TABLE IF EXISTS club_event;
DROP TABLE IF EXISTS climber;
DROP TABLE IF EXISTS emergency_contact;
DROP TABLE IF EXISTS climber_climb_m2m;


CREATE TABLE country (
	country_id SERIAL PRIMARY KEY,
	country_name VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE area (
	area_id SERIAL PRIMARY KEY,
	area_name VARCHAR(120) UNIQUE NOT NULL,
	country_id INT NOT NULL,
	FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE city (
	city_id SERIAL PRIMARY KEY,
	city_name VARCHAR(120) UNIQUE NOT NULL,
	country_id INT NOT NULL,
	FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE mountain (
	mountain_id SERIAL PRIMARY KEY,
	mountain_name VARCHAR(120) UNIQUE NOT NULL,
	height INT NOT NULL CHECK (height > 0),
	area_id INT NOT NULL,
	FOREIGN KEY (area_id) REFERENCES area(area_id)
);

CREATE TABLE address (
	address_id SERIAL PRIMARY KEY,
	address VARCHAR(300) NOT NULL,
	city_id INT NOT NULL,
	FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE climb (
    climb_id SERIAL PRIMARY KEY,
    beginning_date TIMESTAMP NOT NULL CHECK (beginning_date > '2000-01-01'::DATE),
    ending_date TIMESTAMP NOT NULL CHECK (ending_date > '2000-01-01'::DATE),
    mountain_id INT NOT NULL,
    FOREIGN KEY (mountain_id) REFERENCES mountain(mountain_id),
    CHECK (ending_date > beginning_date)
);

CREATE TABLE club_event (
	event_id SERIAL PRIMARY KEY,
    beginning_date TIMESTAMP NOT NULL CHECK (beginning_date > '2000-01-01'::DATE),
    ending_date TIMESTAMP NOT NULL CHECK (ending_date > '2000-01-01'::DATE),
    CHECK (ending_date > beginning_date),
	title VARCHAR(300) NOT NULL DEFAULT 'Gathering of the mountaineering club',
	description TEXT,
	address_id INT NOT NULL,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE climber (
    climber_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    full_name VARCHAR(201) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
    telephone_number VARCHAR(15) UNIQUE CHECK (telephone_number ~ '^\+?[0-9]+$'),
    email VARCHAR(60) CHECK (email LIKE '%@%.%'),
    address_id INT NOT NULL,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE emergency_contact (
    contact_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    full_name VARCHAR(201) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
    telephone_number VARCHAR(15) UNIQUE CHECK (telephone_number ~ '^\+?[0-9]+$'),
    relation VARCHAR(20) 
	CHECK (relation IN ('spouse', 'child', 'parent', 'grandparent')),
    climber_id INT NOT NULL,
    FOREIGN KEY (climber_id) REFERENCES climber(climber_id)
);

CREATE TABLE climber_climb_m2m (
	climb_id INT NOT NULL,
	climber_id INT NOT NULL,
	FOREIGN KEY (climber_id) REFERENCES climber(climber_id),
	FOREIGN KEY (climb_id) REFERENCES climb(climb_id),
	PRIMARY KEY (climb_id, climber_id)
);


