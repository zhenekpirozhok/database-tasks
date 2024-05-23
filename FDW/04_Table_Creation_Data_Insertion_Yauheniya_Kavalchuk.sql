-- Create the remote_table with columns id, name, and age
CREATE TABLE remote_table (
    id serial PRIMARY KEY,     -- Auto-incrementing primary key
    name VARCHAR(255),         -- Name of the individual
    age INTEGER                -- Age of the individual
);

-- Insert initial data into the remote_table
INSERT INTO remote_table (name, age) VALUES
    ('John Doe', 35),
    ('Jane Smith', 28),
    ('Lucy Brown', 42),
    ('Michael Johnson', 50),
    ('Emily Davis', 23),
    ('David Martinez', 30),
    ('Sophia Garcia', 27),
    ('Daniel Rodriguez', 40),
    ('Ava Wilson', 33),
    ('James Anderson', 45),
    ('Isabella Thomas', 29),
    ('Alexander Hernandez', 38),
    ('Mia Moore', 31),
    ('Oliver Taylor', 36),
    ('Emma Lee', 26),
    ('Liam White', 41),
    ('Charlotte Harris', 34),
    ('Benjamin Martin', 32),
    ('Amelia Thompson', 22),
    ('Lucas Martinez', 37),
    ('Harper Jackson', 25),
    ('Ethan Lewis', 39),
    ('Abigail Clark', 24),
    ('Mason Walker', 47),
    ('Ella Young', 21),
    ('Logan Hall', 43),
    ('Aria Allen', 28),
    ('Jacob King', 48),
    ('Sofia Wright', 35),
    ('William Scott', 44);
