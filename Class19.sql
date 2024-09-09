# 1. Create a user data_analyst
CREATE USER data_analyst@localhost IDENTIFIED BY 'pepe123';

# 2. Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

# 3. Login with this user and try to create a table. Show the result of that operation.
/*
COMANDOS EN bash: 
	mysql -u data_analyst -p
	USE sakila;
	CREATE TABLE test_table (id INT);
ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'test_table'
*/

# 4. Try to update a title of a film. Write the update script.
/*
COMANDOS EN bash:
	mysql> UPDATE sakila.film SET title = 'Fast and Furious' WHERE film_id = 1;
Query OK, 1 row affected (0,01 sec)
Rows matched: 1  Changed: 1  Warnings: 0
*/

# 5. With root or any admin user revoke the UPDATE permission. Write the command
REVOKE UPDATE ON sakila.*  FROM 'data_analyst'@'localhost';

# 6. Iniciar sesión nuevamente y tratar de hacer la actualización del paso 4
/*
COMANDOS EN bash:
	mysql> UPDATE sakila.film SET title = 'Fast and Furious' WHERE film_id = 1;
ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film
*/



