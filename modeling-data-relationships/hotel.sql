DROP TABLE IF EXISTS rooms;

DROP TABLE IF EXISTS bookings;

DROP TABLE IF EXISTS guests;

CREATE TABLE rooms
(
    id SMALLINT,
    room_number SMALLINT,
    floor SMALLINT,
    price SMALLINT
);

CREATE TABLE bookings
(
    guest SMALLINT,
    room SMALLINT,
    checkin DATE,
    checkout DATE,
    
    FOREIGN KEY guest REFERENCES guests.id,
    PRIMARY KEY (room, guest)
    KEY room
);

SELECT d.*
FROM (
    SELECT *
    FROM cat c
) d
WHERE c.age < 7

CREATE TABLE guests
(
    id SMALLINT,
    first VARCHAR(50),
    last VARCHAR(50),
    email VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(20),
    country VARCHAR(100),
    phone VARCHAR(20)
);

INSERT INTO guests (id, first, last, email, address, city, state, country, phone)
VALUES
    (1, 'Steven', 'Ambrose', 'sambrose@yahoo.com', '22 Ambrose St.', 'Nome', 'Alaska', 'USA', '(111) 222-3333'),
    (2, 'Mary', 'Beecher', 'mbeecher@gmail.com', '33 Beecher St.', 'Birmingham', 'Alabama', 'USA', '(222) 333-4444'),
    (3, 'Sam', 'Chaffy', 'schaffy@aol.com', '44 Chaffy St.', 'Phoenix', 'Arizona', 'USA', '(333) 444-5555'),
    (4, 'Betty', 'Dagwood', 'bdagwood@hotmail.com', '55 Dagwood Rd.', 'Little Rock', 'Arkansas', 'USA', '(444) 555-6666'),
    (5, 'Tyrone', 'Elmore', 'tyronee@hotmail.com', '66 Elmore Ln.', 'San Francisco', 'California', 'USA', '(555) 666-7777');
    
INSERT INTO rooms (id, room_number, floor, price)
VALUES
    (1, 101, 1, 85),
    (2, 201, 2, 95),
    (3, 301, 3, 105),
    (4, 102, 1, 95),
    (5, 103, 1, 95),
    (6, 104, 1, 105),
    (7, 202, 2, 95);

INSERT INTO bookings (guest, room, checkin, checkout)
VALUES
    (1, 1, '2017-06-22', '2017-06-23'),
    (1, 4, '2017-06-22', '2017-06-23'),
    (2, 5, '2017-05-22', '2017-05-23'),
    (2, 5, '2017-04-22', '2017-04-23'),
    (1, 4, '2017-03-22', '2017-03-23'),
    (3, 4, '2017-02-22', '2017-02-23'),
    (4, 4, '2017-01-22', '2017-01-23'),
    (4, 1, '2016-12-22', '2016-12-23');
