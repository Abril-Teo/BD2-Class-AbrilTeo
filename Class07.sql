USE sakila;

-- Find the films with less duration, show the title and rating.
SELECT title, rating
FROM film
WHERE `length`=(SELECT MIN(`length`) FROM film);
-- Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
SELECT title, rating
FROM film AS f1
WHERE length < ALL (SELECT length 
                       FROM film AS f2
                      WHERE f2.film_id <> f1.film_id);

-- Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
SELECT  CONCAT(c1.first_name,'  ', c1.last_name) AS nombre ,ad.address, 
	(SELECT MIN(p.amount) 
     FROM customer c2 
     INNER JOIN payment AS p ON c2.customer_id = p.customer_id 
     WHERE c1.customer_id = c2.customer_id) AS min_payment
FROM customer AS c1
INNER JOIN address AS ad ON c1.address_id = ad.address_id;

-- Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.

SELECT CONCAT(c1.first_name,'  ', c1.last_name) AS nombre ,
	(SELECT MIN(p.amount) 
     FROM customer c2 
     INNER JOIN payment AS p ON c2.customer_id = p.customer_id 
     WHERE c1.customer_id = c2.customer_id) AS min_payment,
	(SELECT MAX(p.amount) 
	FROM customer c2 
	INNER JOIN payment AS p ON c2.customer_id = p.customer_id 
	WHERE c1.customer_id = c2.customer_id) AS max_payment
FROM customer AS c1;


## TEO ABRIL