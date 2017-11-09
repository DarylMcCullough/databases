# Checkpoint 9 Questions and Answers
## 1. Explain a subquery in your own words.
A subquery is a query to compute some derived value or structure which then feeds into the main query.

## 2. Where can you use a subquery within a SELECT statement?
A subquery can be used in any of the three slots of a SELECT statement: In the `SELECT` portion of a query, you can use a
subquery to compute a kind of derived column. In the `FROM` portion of a query, you can use a subquery to create a computed
or derived table to use. In the `WHERE` portion of a query, you can use a subquery to compute which row or rows to return.

## 3. When would you employ a subquery?
You would use a subquery when you need to combine data from more than one table. A subquery is equivalent to performing a join on
several tables, but is often easier to understand than the equivalent query involving joins.

## 4. Explain a row constructor in your own words.
A row constructor is used to create a single row that is not from any table, by explicitly specifying each of the column values.
There are two purposes of using a row constructor:

1. A row constructor can be used to create a "gold standard" row that you are looking for in a query. In this role, the row constructor
 would be used in the `WHERE` clause of a query.
2. A row constructor can be used to insert values into a table.

## 5. What happens if a row in the subquery result provides a NULL value to the comparison?

If the subquery returns a NULL value, then the comparison result is also NULL.

## 6. What are the ways to use a subquery within a WHERE clause? If you can't remember them, do these flashcards until you can.

1. Using `ALL`: checks if all the results of the subquery match.
2. Using `EXISTS`: checks if there are any results at all from the subquery.
3. Using `NOT EXISTS`: checks if there are no results from the subquery.
4. Using `IN`: checks if the provided row is equal to one of the rows returned by the subquery.
5. Using `NOT IN`: checks if the provided row is not equal to any of the rows returned by the subquery.
6. Using `ANY`: checks if the provided row matches any of the rows returned by the subquery.

## 7. Build an employees table and a shifts table with appropriate primary and foreign keys. Then, write queries to find the following information:
```
CREATE TABLE employees (name VARCHAR(100), id SMALLINT);

CREATE TABLE shifts (shift_id SMALLINT, start TIME, end TIME, day DATE);
```

### 7.1 List all employees and all shifts.

```

INSERT INTO employees (name, id)
VALUES ('DUMMY', 9999);

INSERT INTO shifts (id, start_time, end_time, day)
VALUES (9999, '00:00', '00:00', '2017-01-01');

SELECT employees.id AS employee, employees.name, shifts.id AS shift, shifts.start_time, shifts.end_time, shifts.day
    FROM employees, shifts 
    WHERE (employees.id = 9999 AND shifts.id <> 9999)
            OR (employees.id <> 9999 AND shifts.id = 9999)
    ORDER BY employees.id ASC, shifts.id ASC;
    
DELETE FROM employees WHERE id=9999;
DELETE FROM shifts WHERE id=9999;
```
### 7.2 Create a list of all possible schedules.
```
SELECT * FROM employees, shifts;
```

## 8. Given a dogs table, adoptions table, adopters table, and volunteers table , write queries to retrieve the following information. All tables are described below.

### 8.1 Create a list of all volunteers. If the volunteer is fostering a dog, include each dog as well.

```
SELECT volunteers.*, (SElECT dogs.name FROM dogs WHERE dogs.id=volunteers.foster_id) AS dogs_name FROM volunteers;

```

### 8.2 List the adopter’s name and the pet’s name for each animal adopted within the past month to be displayed as a ‘Happy Tail’ on social media.

```
SELECT adopters.first_name, adopters.last_name,  
    (SELECT cats.name FROM cats WHERE (cats.id, adopters.id) IN 
        (SELECT adoptions.cat, adoptions.adopter FROM adoptions WHERE Adoptions.date >= (now() - interval '1 month'))) AS cat,
    (SELECT dogs.name FROM dogs WHERE (dogs.id, adopters.id) IN 
        (SELECT adoptions.dog, adoptions.adopter FROM adoptions WHERE Adoptions.date >= (now() - interval '1 month'))) AS dog
    FROM adopters;

```

### 8.3 Create a list of adopters who have not yet chosen a dog to adopt and generate all possible combinations of adopters and available dogs.
```
    SELECT adopters.* FROM adopters WHERE adopters.id NOT IN 
        (SELECT adoptions.adopter FROM adoptions);
        
    SELECT adopters.first_name, adopters.last_name, adopters.id AS adopter_id, dogs.name as dog_name, dogs.id AS dog_id FROM adopters, dogs 
        WHERE dogs.id NOT IN (SELECT adoptions.dog FROM adoptions)
        AND adopters.id NOT IN (SELECT adoptions.adopter FROM adoptions);
```

### 8.4 Display a list of all cats and all dogs who have not been adopted.
```
INSERT INTO dogs (id)
VALUES (9999);

INSERT INTO cats(id)
VALUES (9999);

SELECT dogs.id AS dog, dogs.name AS dog_name, cats.id AS cat, cats.name AS cat_name FROM dogs, cats
    WHERE (dogs.id = 9999 AND (cats.id <>  9999 AND cats.id NOT IN (SELECT adoptions.cat FROM adoptions))) OR
            (cats.id = 9999 AND (dogs.id <> 9999 AND dogs.id NOT IN (SELECT adoptions.dog FROM adoptions)));
            
DELETE FROM cats WHERE id = 9999;
DELETE FROM dogs WHERE id = 9999;
```

### 8.5 Create a list of volunteers who are available to foster. If they currently are fostering a dog, include the dog. Also include all dogs who are not currently in foster homes.

This is how you would do it using joins.
```
SELECT volunteers.*, dogs.* FROM volunteers FULL OUTER JOIN dogs ON volunteers.foster_id = dogs.id;
```

I don't see any sensible way to do it using subqueries.

## 9. Write a query to find the name of the person who adopted Seashell given the tables cats, adoptions, and adopters. All tables are described below
```
SELECT adopters.first_name, adopter.last_name FROM adopters WHERE
    adopters.id IN 
        (SELECT adoptions.adopter FROM adoptions WHERE adoptions.cat IN 
            (SELECT cats.id FROM cats WHERE cats.name = 'Seashell'));
```
## 10. Given the tables books (isbn, title, author), transactions (id, checked_out_date, checked_in_date, user_id, isbn), holds (id, isbn, user_id, rank, date), and patrons (id, name, fine_amount), write queries to find the following information:


### 10.1 To discern if the library should buy more copies of a given book, please provide the names and position, in order, of all of the patrons waiting in line for Harry Potter and the Sorcerer’s Stone.
```
SELECT patrons.name, holds.rank FROM patrons INNER JOIN holds ON patrons.id = holds.user_id WHERE
    holds.isbn IN (SELECT books.isbn FROM books WHERE books.title = 'Harry Potter and the Sorcerer’s Stone')
    SORT BY holds.rank;
```

### 10.2 Make a list of all book titles and denote whether or not a copy of that book is checked out.
```
SELECT books.title, EXISTS (SELECT * FROM Transactions WHERE books.isbn = Transactions.isbn) AS checked_out FROM books;

```

### 10.3 In an effort to learn which books take longer to read, the librarians would like you to create a list of total checked out time by book name in the past month.
```
SELECT books.title, SUM(Transactions.checked_in_date - Transactions.checked_out_date) FROM
    Books INNER JOIN Transactions ON Books.isbn = Transactions.isbn 
    WHERE Transactions.checked_in_date IS NOT NULL AND Transactions.checked_in_date >= (now() - interval '1 month');
```
I can't see any sensible way to do this using subqueries.


### 10.4 In order to learn which items should be retired, make a list of all books that have not been checked out in the past 5 years.
```
SELECT Books.* FROM Books WHERE
    Books.isbn NOT IN 
    (SELECT Transactions.isbn FROM Transactions
        WHERE Transactions.checked_out_date IS NULL OR Transactions.checked_out_date <+ (now() - interval '5 years'));
```

### 10.5 List all of the library patrons. If they have one or more books checked out, correspond the books to the patrons.
```
SELECT Patrons.*, Books.title FROM Patrons LEFT OUTER JOIN
    (SELECT Books.title, Transactions.user_id FROM Books INNER JOIN Transactions ON  Books.isbn = Transactions.isbn) as books_checked_out 
    ON Patrons.id = Transactions.user_id;
```

## 11. Given the following tables in an airliner database, find the following information. airplanes (model, seat capacity, range), flights(flight_number, destination, origin, company, distance, flight_time, airplane_model), transactions(id, seats_sold, total_revenue, total_cost, flight_number, date)

### 11.1 To determine the most profitable airplanes, find all airplane models where each flight has had over 100 paying customers in the past month.

```
SELECT airplanes.model FROM airplanes WHERE
    100 <= ALL (
        SELECT transactions.seats_sold FROM transactions 
        WHERE EXISTS (
            SELECT * FROM flights
            WHERE flights.flight_number = transactions.flight_number AND flights.airplane_model = airplanes.model));
```

### 11.2 To determine the most profitable flights, find all destination-origin pairs where 90% or more of the seats have been sold in the past month.
```
SELECT flights.destination, flights.origin from flights WHERE
    0.9 <= ALL (SELECT transactions.seats_sold/airplanes.seat_capacity 
                FROM transactions, airplanes
                     WHERE transactions.flight_number = flights.flight_number 
                    AND airplanes.model = flights.airplane_model);
```

### 11.3 The airline is looking to expand its presence in the US Southeast and globally. Find the total revenue of any flight arriving at or departing from Atlanta.
```
SELECT SUM(transactions.total_revenue) FROM transactions WHERE 
    EXISTS (SELECT * FROM flights WHERE 
                (flights.origin = 'Atlanta' OR flights.destination = 'Atlanta') AND (transactions.flight_number = flights.flight_number));
```

## 12. Compare the subqueries you've written above. Compare them to the joins you wrote in Checkpoint 6. Which ones are more readable? Which were more logical to write?

Some of the queries are much clearer and easier to write using subqueries. Some examples are:
* 8.1 
* The first part of 8.3
* 9.
* 10.1
* 10.2
* 10.4
* 11.1
* 11.2
* 11.3

The other queries were difficult for me to figure out how to write them using subqueries and
were more straight-forward using joins. In particular, it seems that there is no good way to do
something equivalent to an outer join using subqueries (except by putting in dummy rows to represent
the lack of a match).

## Descriptions of tables
dogs table has the columns id, name, gender, age, weight, intake_date, breed, and in_foster. NOTE: Shelter dogs’ breeds are typically guessed by the intake team, so the column may have multiple words. I.E. labrador collie mix

cats table has the columns id, name, gender, age, intake_date, adoption_date

adoptions table has the columns id, adopter, cat, dog, fee, date

adopters table has the columns id, first_name, last_name, address, and phone number

volunteers table has the columns id, name, address, phone_number, available_to_foster, and foster_id