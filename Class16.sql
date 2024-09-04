USE sakila;

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 

(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),

(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),

(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

#1- Insert a new employee to , but with an null email. Explain what happens.
insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1002,'Abril','Teo','x5000',NULL,'1',1002,'Presidente');
#Error Code: 1048. Column 'email' cannot be null
#Esto pasa ya que email esta declarado con la constraint not null, y nosotros intentamos crear una instancia con un email NULL.

# Run the first the query
UPDATE employees SET employeeNumber = employeeNumber - 20;
#2- Al employeeNumber se le resta 20 a todas las filas al numero almacendado en ese campo ejemplo 902 era el id y si lo ejecutas va a ser 882
UPDATE employees SET employeeNumber = employeeNumber + 20;
# El proceso incrementa los valores uno a uno, lo que puede llevar a un conflicto si el número generado ya existe, 
# ya que las claves primarias no pueden duplicarse. Aunque el valor se ajustaría con un incremento posterior, 
# realizar el aumento de uno en uno puede generar errores.


#3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
alter table employees 
add column age int DEFAULT 18, 
add constraint check_age check (age between 16 and 70);

UPDATE employees SET age = 18;

#4- Describe the referential integrity between tables film, actor and film_actor in sakila db.
/*
La integridad referencial entre las tablas film, actor y film_actor se asegura mediante una clave foránea que enlaza film y actor a través de una tabla intermedia. 
Esta tabla intermedia almacena las claves primarias de ambas tablas y evita que se elimine un film o un actor sin antes eliminar las entradas correspondientes en film_actor.
*/



#5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. 
#Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, 
#can connect to MySQL and change this table).
alter table employees add column lastUpdate datetime default now();
alter table employees add column lastUpdateUser varchar(255) default "";
select * from employees;
delimiter $$
create trigger before_update_employees
before update on employees
for each row
begin
	set new.lastUpdate=now();
    set new.lastUpdateUser= current_user();
end$$
delimiter ;

delimiter $$
create trigger before_insert_employees
before insert on employees
for each row
begin
	set new.lastUpdate=now();
    set new.lastUpdateUser= current_user();
end$$
delimiter ;


#6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.
show triggers;
select * from film_text;
select * from film;
/*
Hay un trigger asociado a cada acción en la tabla `film` (es decir, `update`, `insert`, y `delete`). 
Este trigger se encarga de crear, modificar o eliminar una entrada en la tabla `film_text`,
que contiene únicamente el nombre y la descripción, manteniéndola sincronizada con los cambios en la tabla `film`.
*/
#cuando se crea
DELIMITER $$

CREATE TRIGGER ins_film
AFTER INSERT ON film
FOR EACH ROW
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (NEW.film_id, NEW.title, NEW.description);
END$$

DELIMITER ;
#cuando se cambia
DELIMITER $$

CREATE TRIGGER upd_film
AFTER UPDATE ON film
FOR EACH ROW
BEGIN
    IF (OLD.title != NEW.title) OR (OLD.description != NEW.description) OR (OLD.film_id != NEW.film_id)
    THEN
        UPDATE film_text
            SET title = NEW.title,
                description = NEW.description,
                film_id = NEW.film_id
        WHERE film_id = OLD.film_id;
    END IF;
END$$

DELIMITER ;
#cuando se borra
DELIMITER $$

CREATE TRIGGER del_film
AFTER DELETE ON film
FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = OLD.film_id;
END$$

DELIMITER ;