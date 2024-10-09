USE sakila;
#1. Create two or three queries using address table in sakila db:
/*
include postal_code in where (try with in/not it operator)
eventually join the table with city/country tables.
measure execution time.
Then create an index for postal_code on address table.
measure execution time again and compare with the previous ones.
Explain the results
*/
SELECT address_id, address, postal_code, city
	FROM address
	INNER JOIN city ON address.city_id = city.city_id
WHERE postal_code IN ('77459', '41136', '4085');
	# 0.0016
SELECT address_id, address, postal_code, city, country
	FROM address
	INNER JOIN city 
		ON address.city_id = city.city_id
	INNER JOIN country 
		ON city.country_id = country.country_id
WHERE postal_code NOT IN ('12345' , '54321');
	# 0.0035
CREATE INDEX idx_postal_code ON address(postal_code);
	#1 -> 0.0011
	#2 -> 0.0028


#2.Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?
SELECT first_name FROM actor; -- 0.0017
SELECT last_name FROM actor;  -- 0.00074
# Esto es porque last_name tiene un index entonces se obtiene mas rapido


#3.Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.
SELECT title, `description` FROM film WHERE `description` LIKE '%A Action-Packed Saga%'; -- 0.0037
SELECT * FROM film_text WHERE MATCH (title, `description`) AGAINST ('%A Action-Packed Saga%'); -- 0.12
#Es necesario hacer esto porque en Sakila el índice FullText combina los campos title y description, y si no incluis los dos en la consulta, da un error, 
#porque en el campo description no tiene un índice FullText por separado. 
#Esto también mejora la velocidad, porque el índice FullText permite almacenar y acceder a la información de manera más eficiente cuando se trata de texto extenso.