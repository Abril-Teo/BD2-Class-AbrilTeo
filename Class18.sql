#Class 18
USE sakila;
-- 1. Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.
DROP PROCEDURE IF EXISTS AmountOfCopies;
DELIMITER //
CREATE PROCEDURE AmountOfCopies(
		IN filmName VARCHAR(20),
        IN storeId INT)
BEGIN
	SELECT COUNT(*)
		FROM inventory i
        INNER JOIN film f
			ON f.film_id = i.film_id
	WHERE f.title = filmName
	AND i.store_id = storeId;
END //
DELIMITER ;
CALL AmountOfCopies('ACE GOLDFINGER', 2);


-- 2. Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. 
-- You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.
DROP PROCEDURE IF EXISTS CustomersByCountry;
DELIMITER //
CREATE PROCEDURE CustomersByCountry(
		OUT customersList VARCHAR(1000),
        IN countryName VARCHAR(50))
BEGIN 
	DECLARE v_finished INT DEFAULT 0;
    DECLARE v_customer VARCHAR(100) DEFAULT "";
    DECLARE v_separator VARCHAR(3) DEFAULT "";
    DECLARE cursor_customers CURSOR FOR 
		SELECT CONCAT(c.first_name, ' ',c.last_name)
			FROM customer c
			INNER JOIN address ad
				ON c.address_id = ad.address_id
			INNER JOIN city ci
				ON ad.city_id = ci.city_id
			INNER JOIN country co
				ON ci.country_id = co.country_id
		WHERE co.country = countryName;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
    SET customersList = '';
	OPEN cursor_customers;
    get_customer: LOOP
			FETCH cursor_customers INTO v_customer;
            IF v_finished = 1 THEN 
				LEAVE get_customer;
			END IF;
            
            SET customersList = CONCAT(customersList, v_separator ,v_customer);
            SET v_separator = ';  ';
	END LOOP get_customer;
    CLOSE cursor_customers;
END //
DELIMITER ;
SET @customersList = '';
CALL CustomersByCountry(@customersList, 'Colombia');
SELECT @customersList;

-- 3. Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.
/*
La función inventory_in_stock verifica si un ítem específico (identificado por su inventory_id) en la tienda está disponible para alquilar.

Cómo funciona:
1. Primero, la función consulta la tabla `rental` para ver si existen alquileres asociados con el inventory_id dado. 
   Si no hay alquileres para ese inventory_id, la función devuelve TRUE, lo que significa que el ítem está disponible.
2. Si existen alquileres, la función revisa si alguno de ellos tiene un return_date que todavía es NULL, lo que significa que el ítem no ha sido devuelto.
   Si todos los alquileres tienen un return_date (ninguno es NULL), la función devuelve TRUE, ya que el ítem ha sido devuelto y está nuevamente en stock.
3. Si alguno de los alquileres aún tiene un return_date en NULL, la función devuelve FALSE, lo que significa que el ítem todavía está alquilado.

Ejemplo de uso:
SELECT inventory_in_stock(10); 
-- Esto verifica si el ítem con inventory_id 10 está en stock.

El procedimiento film_in_stock devuelve la cantidad de copias disponibles de una película específica en una tienda particular.

Cómo funciona:
1. El procedimiento recibe dos parámetros de entrada: p_film_id y p_store_id.
2. Recupera el inventory_id de todas las copias de la película que coinciden con el film_id y store_id proporcionados desde la tabla `inventory`.
3. Para cada inventory_id encontrado, utiliza la función inventory_in_stock para verificar si la copia está disponible para alquilar.
4. Cuenta cuántas copias están disponibles y almacena ese número en la variable p_film_count.

Ejemplo de uso:
CALL film_in_stock(5, 1, @available);
-- Esto verifica cuántas copias de la película con film_id 5 están disponibles en la tienda 1 y almacena el resultado en la variable @available.
*/



