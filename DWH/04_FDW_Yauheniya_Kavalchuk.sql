CREATE EXTENSION postgres_fdw;

-- Create server to link to the Northwind database
CREATE SERVER northwind_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (dbname 'northwind');

-- Create a user mapping for the current user to access the foreign server
CREATE USER MAPPING FOR CURRENT_USER
SERVER northwind_server
OPTIONS (USER 'postgres', password 'password');

-- Import foreign schemas (tables)
IMPORT FOREIGN SCHEMA public
FROM SERVER northwind_server
INTO staging;