-- Create a foreign server object to reference a PostgreSQL database on the same server
CREATE SERVER same_server_postgres
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (dbname 'db_two');

-- Create a user mapping for the current user to access the foreign server
CREATE USER MAPPING FOR CURRENT_USER
SERVER same_server_postgres
OPTIONS (USER 'current_user', password 'password');
