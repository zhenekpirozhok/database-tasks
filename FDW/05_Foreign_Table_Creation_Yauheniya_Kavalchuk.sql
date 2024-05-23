-- Create a foreign table that references a table in the foreign server
CREATE FOREIGN TABLE local_remote_table (
   id INTEGER,             -- Column for the ID, matching the remote table's ID column
   name VARCHAR(255),      -- Column for the name, matching the remote table's name column
   age INTEGER             -- Column for the age, matching the remote table's age column
)
SERVER same_server_postgres -- Specify the foreign server to which this table refers
OPTIONS (
   schema_name 'public',   -- The schema name in the foreign database where the remote table is located
   table_name 'remote_table' -- The name of the table in the foreign database
);
