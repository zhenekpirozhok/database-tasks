-- Select all records from the employees table
SELECT * FROM employees;

-- Update the last name of the employee with the email 'jane.smith@example.com' to 'Brown'
UPDATE employees SET last_name = 'Brown' WHERE email = 'jane.smith@example.com';

-- Delete the employee record with the email 'john.doe@example.com'
DELETE FROM employees WHERE email = 'john.doe@example.com';

-- Select all records from the pg_stat_statements view to see the statistics of all SQL statements executed
SELECT * FROM pg_stat_statements;
