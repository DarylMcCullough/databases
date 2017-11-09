DROP TABLE IF EXISTS cats;
DROP TABLE IF EXISTS dogs;
DROP TABLE IF EXISTS volunteers;
DROP TABLE IF EXISTS adoptions;
DROP TABLE IF EXISTS adopters;

CREATE TABLE cats (id SMALLINT, name VARCHAR(100), gender VARCHAR(1), age SMALLINT, intake_date DATE, adoption_date DATE);
CREATE TABLE dogs (id SMALLINT, name VARCHAR(50), gender VARCHAR(1), age SMALLINT, intake_date DATE, breed VARCHAR(100), in_foster BOOLEAN);
CREATE TABLE adopters (first_name VARCHAR(100), last_name VARCHAR(100), id SMALLINT);
CREATE TABLE adoptions(id SMALLINT, adopter SMALLINT, cat SMALLINT, dog SMALLINT, fee SMALLINT, date DATE);
CREATE TABLE volunteers(id SMALLINT, name VARCHAR(100), address VARCHAR(100), phone_number VARCHAR(15), available_to_foster BOOLEAN, foster_id SMALLINT);

INSERT INTO cats (id, name, gender, age, intake_date, adoption_date)
VALUES
(1, 'Fluffy', 'F', 2, '2017-08-01', NULL),
(2, 'Mittens', 'M', 1, '2017-08-19', NULL);


INSERT INTO dogs (id, name, gender, age, intake_date, breed, in_foster)
VALUES
(1, 'Ruff', 'M', 4, '2016-01-01', 'schnauzer', TRUE),
(2, 'Daisy', 'F', 3, '2017-03-01', 'dalmation', FALSE);

INSERT INTO adopters(first_name, last_name, id)
VALUES ('Ted', 'Smith', 1);

INSERT INTO adoptions(id, adopter, cat, dog, fee, date)
VALUES
(1, 1, NULL, 2, 20, '2017-10-30');

INSERT INTO volunteers(id, name, address, phone_number, available_to_foster, foster_id)
VALUES
(1, 'Fred Martin', '20 Twentieth St., Ithaca, NY 14650', '(607) 234-5678', TRUE, 1);