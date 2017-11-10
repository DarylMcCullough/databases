## 1. Create a database for the model we built in the example. 
### Create a SQL file that creates the tables and inserts sample data (the questions below will help you create the data).

**Content of hotels.sql**

```
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
    checkout DATE
);

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
```
### Write queries that demonstrate the following scenarios:

### 1.1 Find a guest who exists in the database and has not booked a room.
```
SELECT guests.* FROM guests LEFT OUTER JOIN bookings ON bookings.guest = guests.id WHERE bookings.guest IS NULL;
```

**Result**
| id | first  |  last  |        email        |    address    |     city      |   state    | country |     phone      |
|----|--------|--------|---------------------|---------------|---------------|------------|---------|----------------|
|  5 | Tyrone | Elmore | tyronee@hotmail.com | 66 Elmore Ln. | San Francisco | California | USA     | (555) 666-7777 |


### 1.2 Find bookings for a guest who has booked two rooms for the same dates.
```
SELECT guest, checkin, checkout, array_agg(room) AS rooms FROM bookings GROUP BY guest, checkin, checkout HAVING COUNT(*) = 2;
```

| guest |  checkin   |  checkout  | rooms | 
|-------|------------|------------|-------|
|     1 | 2017-06-22 | 2017-06-23 | {1,4} |

### 1.3 Find bookings for a guest who has booked one room several times on different dates.
```
SELECT guest, room, array_agg(checkin) as checkin, array_agg(checkout) as checkout FROM bookings GROUP BY guest, room HAVING COUNT(*) > 1;
```
**Result**
| guest | room |         checkin         |        checkout        | 
|-------|------|-------------------------|------------------------|
|     2 |    5 | {2017-05-22,2017-04-22} | {2017-05-23,2017-04-23}|
|     1 |    4 | {2017-06-22,2017-03-22} | {2017-06-23,2017-03-23}|


### 1.4 Count the number of unique guests who have booked the same room.

```
SELECT room, COUNT (DISTINCT guest) as guests_who_booked FROM bookings GROUP BY room;
```
**Result**

| room | count |
|------|-------|
|    1 |     2 |
|    4 |     3 |
|    5 |     1 |

## 2. Design a data model for students and the classes they have taken.

> The model should include the students' grades for a given class.
        Work through the questions from the example above.
        Document any assumptions you make about what data should be stored, what data types should be used, etc., and include them in a text file.
        Ask questions of your mentor if you are unsure about parts of your model.
        Draw the model using the notation used in the checkpoint and submit a picture. You can also use a tool like StarUML or quickdatabasediagrams.com if you choose.

The model is depicted in the file `enrollment.png`, created using `quickdatabasediagrams.com`.

In general, there could be many different attributes of a student and a class, including:
* the year of the student (freshman, sophmore, etc.)
* the student's major
* the student's address, email, etc.
* the department the class is in
* when the class is offered
* etc.

But looking at the questions, I decided that I might as well make the model as simple as needed to address the questions.

Obviously, a student can take multiple classes, and a class can have multiple students. So it is a many-many relationship. Therefore,
to represent it in a database, I want to introduce an auxiliary entity, which I'm calling `enroll`, which connects students and classes.

For this model, the only attributes of a class will be an ID and a name. The ID is an int, and the name is a string.
The only attributes of a student will be an ID, a first and last name. The ID is again an int, and the names are strings.
The purpose of the `enroll` entity is to connect students and classes, so it has two foreign keys, one an ID for the class, and another the ID for the student. These
are both ints. Finally, there is a grade, which I will represent as a string (so it can be "A", "A+", "B-", etc.). Obviously, grades could have been numerical, as well,
which would make more sense if we were asked to come up with average grades.

## 3. Build a database for the students/classes data model. 

> Create a SQL file that creates the tables and inserts sample data (the questions below will help you create the data). Write queries that demonstrate the following scenarios:

### 3.1 Find all students who have taken a particular class.

```
SELECT Student.*, Class.ClassID, Class.Name FROM 
    Student RIGHT OUTER JOIN 
    (Class INNER JOIN Enroll ON Class.ClassID = Enroll.ClassID) 
    ON Student.StudentID = Enroll.StudentID
    ORDER BY Class.ClassID;
```

**Result:**
 studentid | firstname | lastname | classid |             name             
-----------|-----------|----------|---------|------------------------------
         1 | Bob       | Anderson |       1 | Intro to Wood Carving
         3 | Donald    | Carver   |       1 | Intro to Wood Carving
         2 | Carol     | Bendix   |       1 | Intro to Wood Carving
         1 | Bob       | Anderson |       2 | Advanced Tic Tac Toe
         2 | Carol     | Bendix   |       3 | Intermediate Paper Airplanes
         1 | Bob       | Anderson |       3 | Intermediate Paper Airplanes
         3 | Donald    | Carver   |       3 | Intermediate Paper Airplanes
         3 | Donald    | Carver   |       4 | History of Onions
         2 | Carol     | Bendix   |       4 | History of Onions

### 3.2 Count the number of each grade (using letter grades A-F) earned in a particular class.

```
SELECT Enroll.ClassID, Class.Name, Enroll.grade, COUNT(*) as num_given FROM
    Enroll INNER JOIN Class on Enroll.ClassID = Class.ClassID
    GROUP BY Enroll.ClassID, Enroll.grade, Class.Name;
```
**Result:**
 classid |             name             | grade | num_given 
---------|------------------------------|-------|-----------
       4 | History of Onions            | C+    |         2
       3 | Intermediate Paper Airplanes | C+    |         1
       2 | Advanced Tic Tac Toe         | B-    |         1
       3 | Intermediate Paper Airplanes | B-    |         1
       3 | Intermediate Paper Airplanes | C     |         1
       1 | Intro to Wood Carving        | B     |         1
       1 | Intro to Wood Carving        | A+    |         2
### 3.3 Find class names and the total number of students who have taken each class in the list.
```
SELECT Class.Name, COUNT(Enroll.StudentID) FROM Class INNER JOIN Enroll ON Class.ClassID = Enroll.ClassID
    GROUP BY Class.Name;
```

**Result:**

|             name             | count |
|------------------------------|-------|
| Intro to Wood Carving        |     3 |
| History of Onions            |     2 |
| Advanced Tic Tac Toe         |     1 |
| Intermediate Paper Airplanes |     3 |

### 3.4 Find the class taken by the largest number of students.

```
SELECT Class.Name, COUNT(Enroll.StudentID) as count FROM Class INNER JOIN Enroll ON Class.ClassID = Enroll.ClassID
    GROUP BY Class.Name
    ORDER BY count DESC
    LIMIT 1;
```

**Result:**

|         name          | count |
|-----------------------|-------|
| Intro to Wood Carving |     3 |
