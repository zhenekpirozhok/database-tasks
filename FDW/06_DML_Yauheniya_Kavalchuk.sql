SELECT * FROM local_remote_table;

INSERT INTO local_remote_table (id, name, age) VALUES (31, 'Olga Kavalchuk', 22);

UPDATE local_remote_table SET age = 40 WHERE name = 'John Doe';

DELETE FROM local_remote_table WHERE name = 'James Anderson';