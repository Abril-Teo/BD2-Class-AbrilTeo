DROP DATABASE IF EXISTS imdb;
CREATE DATABASE imdb;
USE imdb;

CREATE TABLE Film (
	film_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    descripcion TEXT,
    release_year YEAR,
    CONSTRAINT film_pk PRIMARY KEY (film_id)
);


CREATE TABLE Actor (
	actor_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    CONSTRAINT actor_pk PRIMARY KEY (actor_id)
);

CREATE TABLE Film_actor (
	actor_id INT NOT NULL,
    film_id INT NOT NULL,
    CONSTRAINT film_actor_pk PRIMARY KEY (actor_id, film_id)
);

ALTER TABLE Film
  ADD last_update DATE
    AFTER release_year; 

ALTER TABLE Actor
  ADD last_update DATE
    AFTER last_name; 
    
ALTER TABLE Film_actor ADD
	CONSTRAINT fk_film_actor_actor
    FOREIGN KEY (actor_id)
    REFERENCES Actor (actor_id);
    
ALTER TABLE Film_actor ADD
	CONSTRAINT fk_film_actor_film
    FOREIGN KEY (film_id)
    REFERENCES Film (film_id);
    
    
    
INSERT INTO Film (title, descripcion, release_year, last_update) VALUES 
('The Shawshank Redemption', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 1994, '2023-04-01'),
('The Godfather', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.', 1972, '2023-04-02'),
('The Dark Knight', 'When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.', 2008, '2023-04-03'),
('12 Angry Men', 'A jury holdout attempts to prevent a miscarriage of justice by forcing his colleagues to reconsider the evidence.', 1957, '2023-04-04'),
('Schindler\'s List', 'In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.', 1993, '2023-04-05');


INSERT INTO Actor (first_name, last_name, last_update) VALUES 
('Tom', 'Hanks', '2023-04-01'),
('Marlon', 'Brando', '2023-04-02'),
('Heath', 'Ledger', '2023-04-03'),
('Henry', 'Fonda', '2023-04-04'),
('Liam', 'Neeson', '2023-04-05');


INSERT INTO Film_actor (actor_id, film_id) VALUES 
(1, 1),
(2, 2), 
(3, 3),
(4, 4), 
(5, 5); 

