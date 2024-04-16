USE sakila;

# 1. List all the actors that share the last name. Show them in order
SELECT first_name, last_name 
FROM actor a1
WHERE EXISTS (SELECT * FROM actor a2
				WHERE a1.last_name = a2.last_name 
				AND a1.actor_id <> a2.actor_id)
ORDER BY a1.last_name;
                
# 2. Find actors that don't work in any film
SELECT * 
FROM actor a
WHERE NOT EXISTS (SELECT * FROM film_actor fa
						WHERE a.actor_id = fa.actor_id);


# 3. Find customers that rented only one film
SELECT c.first_name,c.last_name,count(r.customer_id) AS cant_compras 
FROM rental r 
INNER JOIN customer c ON c.customer_id=r.customer_id
GROUP BY r.customer_id 
HAVING 1=count(r.customer_id);

# 4. Find customers that rented more than one film
SELECT c.first_name,c.last_name,count(r.customer_id) AS cant_compras 
FROM rental r 
INNER JOIN customer c ON c.customer_id=r.customer_id
GROUP BY r.customer_id 
HAVING 1<count(r.customer_id);

# 5. List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD
SELECT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE  f.title IN ('BETRAYED REAR','CATCH AMISTAD')  
GROUP BY a.actor_id;

# 6. List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
SELECT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE  f.title IN ('BETRAYED REAR')  
AND a.actor_id not IN (
    SELECT actor_id 
    FROM film_actor fa
    INNER JOIN film f ON fa.film_id = f.film_id
    WHERE f.title='CATCH AMISTAD'
);

# 7. List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
SELECT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'BETRAYED REAR'
AND a.actor_id IN (
    SELECT actor_id 
    FROM film_actor fa
    INNER JOIN film f ON fa.film_id = f.film_id
    WHERE f.title='CATCH AMISTAD'
);

# 8. List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
			SELECT fa.actor_id
            FROM film_actor fa
            INNER JOIN film f ON fa.film_id = f.film_id
            WHERE f.title = 'BETRAYED REAR')
AND a.actor_id NOT IN (
			SELECT fa.actor_id
            FROM film_actor fa
            INNER JOIN film f ON fa.film_id = f.film_id
            WHERE f.title = 'CATCH AMISTAD');

# TEO ABRIL CLASS 6