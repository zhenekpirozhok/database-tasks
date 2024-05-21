-- Create the pg_stat_statements extension for tracking execution statistics of all SQL statements
CREATE EXTENSION pg_stat_statements;

-- Create the pgcrypto extension for cryptographic functions, such as password encryption
CREATE EXTENSION pgcrypto;

-- Create the employees table
-- id: A unique serial identifier for each employee (Primary Key)
-- first_name: The first name of the employee
-- last_name: The last name of the employee
-- email: The email address of the employee
-- encrypted_password: The encrypted password of the employee, stored as text
CREATE TABLE employees (
   id serial PRIMARY KEY,         -- Auto-incrementing primary key
   first_name VARCHAR(255),       -- Employee's first name
   last_name VARCHAR(255),        -- Employee's last name
   email VARCHAR(255),            -- Employee's email address
   encrypted_password TEXT        -- Employee's encrypted password
);
