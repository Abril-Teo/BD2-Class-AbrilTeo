USE sakila;
select * FROM customer;
select * from address;
select * from city;

#1. Create a view named list_of_customers
CREATE OR REPLACE VIEW list_of_customers AS
SELECT cu.customer_id, CONCAT(cu.first_name, ' ',cu.last_name) 'full name', ad.address, ad.phone, ci.city, co.country, case active when 1 then 'active' else 'inactive'end as status, cu.store_id
	FROM customer cu
    INNER JOIN address ad
		ON 	cu.address_id = ad.address_id
	INNER JOIN city ci
		ON ad.city_id = ci.city_id
	INNER JOIN country co
		ON ci.country_id = co.country_id;

SELECT * FROM list_of_customers;

#2. Create a view named film_details, 
# it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
CREATE OR REPLACE VIEW film_details AS
SELECT f.film_id, f.title, f.description, f.replacement_cost, f.`length`, f.rating, GROUP_CONCAT(distinct c.name) AS category, GROUP_CONCAT(a.first_name, ' ', a.last_name) AS actors
	FROM film_actor fa
    INNER JOIN film f
		ON fa.film_id = f.film_id
	INNER JOIN actor a 
		ON fa.actor_id = a.actor_id
	INNER JOIN film_category fc
		ON f.film_id = fc.film_id
	INNER JOIN category c
		ON fc.category_id = c.category_id
	GROUP BY f.film_id, f.title, f.description, f.replacement_cost, f.rating;
        
SELECT * FROM film_details;

#3. Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT c.name, count(r.rental_id) AS total_rental 
	FROM rental r
	INNER JOIN inventory i 
		ON r.inventory_id = i.inventory_id
	INNER JOIN film f 
		ON i.film_id = f.film_id
	INNER JOIN film_category fc 
		ON fc.film_id = f.film_id
	INNER JOIN category c 
		ON fc.category_id = c.category_id
	GROUP BY c.name;

SELECT * FROM sales_by_film_category;
		
#4. Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
CREATE OR REPLACE VIEW actor_information AS
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) amount_films
	FROM actor a 
    INNER JOIN film_actor fa 
		ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id, a.first_name, a.last_name;
    
SELECT * FROM actor_information;

#5. Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sakila`.`actor_information` AS
    SELECT 
        `a`.`actor_id` AS `actor_id`,
        `a`.`first_name` AS `first_name`,
        `a`.`last_name` AS `last_name`,
        COUNT(`fa`.`film_id`) AS `amount_films`
    FROM
        (`sakila`.`actor` `a`
        JOIN `sakila`.`film_actor` `fa` ON ((`a`.`actor_id` = `fa`.`actor_id`)))
    GROUP BY `a`.`actor_id` , `a`.`first_name` , `a`.`last_name`
	# La vista `actor_information` cuenta el número de películas de cada actor. 
	# Usa un JOIN entre las tablas `actor` y `film_actor` para vincular actores con sus películas. 
	# La función COUNT cuenta las películas y los resultados se agrupan por actor, 
	#  cada fila corresponde a un actor individual con su conteo de películas.

#6. Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
/*
Las vistas materializadas son tablas precomputadas que almacenan los resultados de una consulta. 
Se utilizan principalmente para mejorar el rendimiento de las consultas, ya que eliminan la necesidad de ejecutar 
consultas en tiempo real, lo que resulta en tiempos de respuesta más rápidos, especialmente en operaciones complejas.

Por qué usar vistas materializadas:
- Rendimiento mejorado: Almacenar resultados precomputados reduce el tiempo de ejecución de las consultas.
- Reducción de carga en la base de datos principal: Liberan recursos del sistema al evitar el procesamiento de consultas en la base de datos principal.
- Informes en tiempo real: Proporcionan información actualizada para aplicaciones de análisis y reportes.

Cuándo usar vistas materializadas:
- Consultas ejecutadas con frecuencia: Ahorran tiempo al almacenar resultados de consultas que se repiten.
- Grandes volúmenes de datos: Reducen la cantidad de datos procesados en cada consulta.
- Consultas complejas: Simplifican las consultas con múltiples uniones o agregaciones.

Alternativas a las vistas materializadas:
- Índices: Mejoran el rendimiento de ciertas consultas, pero no siempre son efectivos en consultas complejas.
- Caché: Almacena resultados en memoria, aunque puede no ser tan persistente como las vistas materializadas.
- Desnormalización: Reduce la necesidad de uniones, pero puede causar redundancia y problemas de mantenimiento.

Soporte en sistemas de gestión de bases de datos (DBMS):
La mayoría de los sistemas modernos, como Oracle, MySQL (desde la versión 8.0), PostgreSQL, SQL Server y Teradata, 
ofrecen soporte para vistas materializadas, cada uno con sus características específicas.
*/
