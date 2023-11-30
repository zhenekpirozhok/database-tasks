-- Insert into country
INSERT INTO country (country_name) VALUES
    ('USA'),
    ('Canada'),
    ('France'),
    ('Japan'),
    ('Australia');

-- Insert into area
INSERT INTO area (area_name, country_id) VALUES
    ('Rocky Mountains', 1),
    ('Banff National Park', 2),
    ('Mont Blanc Massif', 3),
    ('Japanese Alps', 4),
    ('Blue Mountains', 5);

-- Insert into city
INSERT INTO city (city_name, country_id) VALUES
    ('Denver', 1),
    ('Banff', 2),
    ('Chamonix', 3),
    ('Tokyo', 4),
    ('Sydney', 5);

-- Insert into mountain
INSERT INTO mountain (mountain_name, height, area_id) VALUES
    ('Mount Elbert', 4399, 1),
    ('Mount Temple', 3544, 2),
    ('Mont Blanc', 4810, 3),
    ('Mount Fuji', 3776, 4),
    ('Mount Kosciuszko', 2228, 5);

-- Insert into address
INSERT INTO address (address, city_id) VALUES
    ('123 Main St, Denver', 1),
    ('456 Mountain Ave, Banff', 2),
    ('789 Summit St, Chamonix', 3),
    ('101 Fuji Blvd, Tokyo', 4),
    ('202 Valley Road, Sydney', 5);

-- Insert into climb
INSERT INTO climb (beginning_date, ending_date, mountain_id) VALUES
    ('2022-01-01', '2022-01-10', 1),
    ('2022-02-01', '2022-02-15', 2),
    ('2022-03-01', '2022-03-20', 3),
    ('2022-04-01', '2022-04-10', 4),
    ('2022-05-01', '2022-05-15', 5);

-- Insert into club_event
INSERT INTO club_event (beginning_date, ending_date, title, description, address_id) VALUES
    ('2022-06-01', '2022-06-05', 'Summer Gathering', 'Annual club meeting', 1),
    ('2022-07-01', '2022-07-10', 'Winter Summit', 'Cold weather adventure', 2),
    ('2022-08-01', '2022-08-15', 'Alpine Festival', 'Celebrating alpine achievements', 3),
    ('2022-09-01', '2022-09-10', 'Cherry Blossom Hike', 'Scenic hike in Japan', 4),
    ('2022-10-01', '2022-10-15', 'Spring Retreat', 'Enjoy the blooming nature', 5);

-- Insert into climber
INSERT INTO climber (first_name, last_name, telephone_number, email, address_id) VALUES
    ('John', 'Doe', '+123456789', 'john.doe@example.com', 1),
    ('Jane', 'Smith', '+987654321', 'jane.smith@example.com', 2),
    ('Alex', 'Johnson', '+111222333', 'alex.johnson@example.com', 3),
    ('Emma', 'Lee', '+444555666', 'emma.lee@example.com', 4),
    ('Michael', 'Davis', '+777888999', 'michael.davis@example.com', 5);

-- Insert into emergency_contact
INSERT INTO emergency_contact (first_name, last_name, telephone_number, relation, climber_id) VALUES
    ('Mary', 'Doe', '+111222333', 'spouse', 1),
    ('Robert', 'Smith', '+222333444', 'child', 2),
    ('Olivia', 'Johnson', '+333444555', 'parent', 3),
    ('William', 'Lee', '+444555666', 'grandparent', 4),
    ('Sophia', 'Davis', '+555666777', 'spouse', 5);

-- Insert into climber_climb_m2m
INSERT INTO climber_climb_m2m (climber_id, climb_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);
