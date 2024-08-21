USE sakila;

# 1. Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.

SELECT 
    CONCAT(cu.first_name, ' ', cu.last_name) 'NOMBRE Y APELLIDO',
    a.address,
    ci.city
FROM customer cu
	INNER JOIN address a ON cu.address_id = a.address_id
	INNER JOIN city ci ON a.city_id = ci.city_id
	INNER JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

# 2. Write a query that shows the film title, language and rating. Rating shall be shown as the full text described 
#     here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.

SELECT 
    f.title,
    l.`name`,
    CASE rating
        WHEN 'G' THEN 'G (General Audiences) – All ages admitted.'
        WHEN 'PG' THEN 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'
        WHEN 'PG-13' THEN 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
        WHEN 'R' THEN 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
        WHEN 'NC-17' THEN 'NC-17 (Adults Only) – No one 17 and under admitted.'
        ELSE 'Not Rated'
    END AS 'rating formated'
FROM film f
	INNER JOIN `language` l ON f.language_id = l.language_id;

# 3. Write a search query that shows all the films (title and release year) an actor was part of. 
#     Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.

SELECT
	f.title, 
    f.release_year, 
    concat(a.first_name, ' ',a.last_name) as nombre 
FROM film_actor fa 
	INNER JOIN film f ON fa.film_id = f.film_id 
    INNER JOIN actor a ON fa.actor_id = a.actor_id 
WHERE lower(concat(a.first_name, ' ',a.last_name)) = lower('JOE SWANK');

# 4. Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. 
#     There should be returned column with two possible values 'Yes' and 'No'.

SELECT 
	f.title, 
	c.first_name, 
    case 
		when r.return_date  is not null then 'Yes'
		else 'No' end as Returned
 FROM rental r 
	INNER JOIN inventory i ON r.inventory_id = i.inventory_id
	INNER JOIN film f ON i.film_id = f.film_id
	INNER JOIN customer c ON r.customer_id = c.customer_id
 WHERE MONTH(rental_date)=5 OR MONTH(rental_date)=6;

# 5. Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.
-- En MySQL, tanto CAST como CONVERT se utilizan para cambiar el tipo de datos de una expresión.
-- Ambas funciones son similares, pero CONVERT tiene una opción adicional para convertir entre diferentes conjuntos de caracteres.
-- Ejemplo:

SELECT 
    CAST(123 AS CHAR) AS cast_example,
    CONVERT(123, CHAR) AS convert_example;

# 6. Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.
-- NVL: Disponible en Oracle, reemplaza NULL con el valor especificado.
-- ISNULL: Disponible en MySQL y SQL Server, similar a NVL.
-- IFNULL: Específica de MySQL, reemplaza NULL con un valor especificado.
-- COALESCE: Disponible en la mayoría de las bases de datos SQL, devuelve la primera expresión no nula en la lista.
-- MySQL Ejemplos:

SELECT 
    IFNULL(NULL, 'default_value') AS ifnull_example,
    COALESCE(NULL, NULL, 'default_value') AS coalesce_example;
