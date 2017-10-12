## 1. How do you find data that is held in two separate data tables?
You can execute a `SELECT` statement that joins the data from both tables.

## 2. Explain, in your own words, the difference between

1. a CROSS JOIN, 
2. an INNER JOIN, 
3. a LEFT OUTER JOIN, 
4. a RIGHT OUTER JOIN, and 
5. a FULL OUTER JOIN.

## Give a real world example for each.

### 2.1 CROSS JOIN
This type of join gives all possible ways to relate rows in one table with rows in another table.
So if there are `n` rows in the first table, and `m` rows in the second table, then there will be `n x m`
results in the cross join.

You could imagine a restaurant having an `entrees` table listing all their main courses, and for each choice, having
columns listing the price, the calories, the fat content, etc. There might be a `desserts` table listing similar 
information for desserts. Then if you do a cross join on the two tables, you would get a table of all possible
two-course meals (entree + dessert).

### 2.2 INNER JOIN
This type of join combines information from two different tables by joining rows based on a common value of some
column. The results of an inner join would have values for every column in either table.

To give a simple example, a veterinarian might have a table of visits, which lists the name of a pet and
what the purpose of the visit was, and a second table of pets, which lists the name of a pet and what type of animal
it is (and maybe other characteristics such as the size, weight, health problems, etc.). By doing a join of the tables
on the common column `pet_name`, the vet can get a more complete description of the visit and the pet.

## 2.3 LEFT OUTER JOIN
This type of join gives a result that contains all the rows of the left (first) table, joined to the matching results of the right (second) table.
If a row in the left table has no match in the right table, then it will appear in the result with nulls corresponding to the columns on the 
right table.

An example might be an online store in which customers can join a supersaver club to get discounts. There might be a table of orders,
which would list the name and address of the customer placing the order, the item ordered, etc., and a second table of club members, which would
list the name and address of the member, when they joined, what their discount rate was, etc. A left join of the first table with the second
on name and address would result in a table listing all orders, and for those orders from club members, would also give membership information.

## 2.4 RIGHT OUTER JOIN
This type of join is exactly like the LEFT OUTER JOIN, except that the roles of the left and right tables is swapped.

I can reuse the example above. With a RIGHT OUTER JOIN of the two tables, we would get a list of all club members, and for
those club members who placed orders, it would also give information about what they ordered.

## 2.5 FULL OUTER JOIN
A full outer join gives all the information in both the left and right tables. If a row of the left table matches a row of the right table,
then the two rows are stuck together. If a row from either the left or right doesn't match, then they are included in the result with nulls
for whichever table lacks information about that object.

An example of a full outer join might be: a school has two different clubs, say the chorus and the band. Both clubs will
be participating in a music festival at another school. You could use a full outer join between the chorus table and the
band table to get information about all students who will go on the trip. Joining on student name and id would prevent duplicate
information for students who are in both clubs.

### 3. Define primary key and foreign key. Give a real world example for each.
In a table, a primary key is some column where the values are guaranteed not to repeat, so that
the values can be used to look up a particular row. An example might be a table of customers, and
each customer has his email address as his primary key.

A foreign key is a primary key from one table that is used as a column of another table. For
example, there might be a `customers` table, as described above, listing all the customers for
a business. Then there might be an `orders` table which lists all product orders (quantity, type, etc.)
The orders table then might have a column called `customer_email` to indicate which customer placed
the order. That would be a foreign key pointing into the `customer` table.

## 4. Define aliasing.

Aliasing just means giving a simple name to complex expressions or query results in order to use them
as part of a larger query. It can make the query more compact.

## 5. Change this query so that you are using aliasing:

### Original
```
SELECT professor.name, compensation.salary, compensation.vacation_days FROM professor JOIN compensation ON professor.id = compensation.professor_id;
```

### Modified
```
SELECT p.name, c.salary, c.vacation_days from professor as p JOIN compensation as c ON p.id = c.professor_id;
```

## 6. Why would you use a NATURAL JOIN? Give a real world example.

A natural join of two tables makes the assumption that if the tables use the same column names, then you want to join on those values.

An example might be if you have two tables that both have a "name" column and an "email" column. Joining on those two values is sensible,
because probably each row corresponds to information about a user with that name and email, and so it is appropriate to combine the information.

In general, it seems to me to be slightly risky to do a natural join, because the tables might have column names that are accidentally
the same. 

## 7. Build an Employees table and a Shifts table with appropriate primary and foreign keys.

```
CREATE TABLE employees (name VARCHAR(100), preferred_shift SMALLINT);

CREATE TABLE shifts (shift_id SMALLINT, start TIME, end TIME);
```

### Then, write queries to find the following information:
### 7.1 List all employees and all shifts.

```
SELECT * FROM employees FULL OUTER JOIN shifts;
```

### 7.2 Create a list of all possible schedules.
```
SELECT e.name, s.shift_id, s.start, s.end FROM employees as e CROSS JOIN shifts as s;
```

## 8. Given the Dogs table (described below), the Adoptions table (described below), the Adopters table (which has the columns first_name, last_name, address, and phone number), and the Volunteers table (which has the columns id, name, address, phone_number, available_to_foster, and foster_id), please write queries to retrieve the following information.

### 8.1 Create a list of all volunteers. If the volunteer is fostering a dog, include each dog as well.
```
SELECT v.first_name, v.last_name, v.address, v.phone_number, d.id, d.name from Volunteers as v LEFT OUTER JOIN Dogs as d ON v.foster_id = d.id;
```

### 8.2 List the adopter’s name and the pet’s name for each animal adopted within the past month to be displayed as a ‘Happy Tail’ on social media.
```
SELECT Adoptions.adopter, Dogs.name FROM Adoptions INNER JOIN Dogs ON Adoptions.dog = Dogs.id WHERE Adoptions.date >= (now() - interval '1 month');
```
From [Working with Dates and Times](http://postgresguide.com/tips/dates.html)

### 8.3 Create a list of adopters who have not yet chosen a dog to adopt and generate all possible combinations of adopters and available dogs.

```
SELECT Adopters.*, Dogs.* FROM
    (Adopters LEFT OUTER JOIN Adoptions ON Adopters.id = Adoptions.adopter
        WHERE Adoptions.adopter IS NULL)
    CROSS JOIN
    (Adoptions RIGHT OUTER JOIN Dogs ON Adoptions.dog = Dogs.id WHERE Adoptions.dog IS NULL);
```

The idea behind the above is that `(Adopters LEFT OUTER JOIN Adoptions ON Adopters.id = Adoptions.adopter WHERE Adoptions.adopter IS NULL)`
returns a derived table of all adopters with no adoptions. Similarly,   `(Adoptions RIGHT OUTER JOIN Dogs ON Adoptions.dog = Dogs.name WHERE Adoptions.dog IS NULL)`
returns a derived table of all dogs that have not been adopted. Then you do a CROSS JOIN of those two tables to get all possible matches of
adopter with dog.

I'm assuming that Adoptions.adopter returns the last name of the adopter.

### 8.4 Display a list of all cats and all dogs who have not been adopted.

```
SELECT Cats.*, Dogs.* FROM
    (Cats LEFT OUTER JOIN Adoptions ON Cats.id = Adoptions.cat WHERE Adoptions.cat IS NULL) 
    FULL OUTER JOIN
    (Dogs LEFT OUTER JOIN Adoptions ON Dogs.id = Adoptions.dog WHERE Adoptions.dog IS NULL);
```

### 8.5 Create a list of volunteers who are available to foster. If they currently are fostering a dog, include the dog. Also include all dogs who are not currently in foster homes.

```
SELECT Volunteers.*, Dogs.* FROM
    Volunteers FULL OUTER JOIN Dogs on Volunteers.foster_id = Dogs.id;
```

## 9. Write a query to find the name of the person who adopted Seashell given the tables Cats (depicted below), Adoptions (depicted below), and Adopters which has columns for id, address, phone number, and name.

* Dogs table has the columns id, name, gender, age, weight, intake_date, breed, and in_foster.
* NOTE: Shelter dogs’ breeds are typically guessed by the intake team, so the column may have multiple words. I.E. labrador collie mix
* Cats table has the columns id, name, gender, age, intake_date, adoption_date
* Adoptions table has the columns id, adopter, cat, dog, fee, date

 ```
 SELECT Adopters.first_name, Adopters.last_name FROM
    (Adopters INNER JOIN Adoptions ON Adopters.id = Adoptions.adopter)
    INNER JOIN
    Cats ON Adoptions.cat = Cats.id
    WHERE Cats.name = 'Seashell'
 ```

## 10. Given the tables Books (isbn, title, author), Transactions(id, checked_out_date, checked_in_date, user_id, isbn), Holds(id, isbn, user_id, rank, date), and Patrons(id, name, fine_amount), write queries to find the following information:

### 10.1 To discern if the library should buy more copies of a given book, please provide the names and position, in order, of all of the patrons waiting in line for Harry Potter and the Sorcerer’s Stone.

```
SELECT Patrons.name, Holds.rank FROM 
    (Books INNER JOIN Holds ON Books.isbn = Holds.isbn WHERE Books.title = 'Harry Potter and the Sorcerer''s Stone')
    INNER JOIN Patrons ON Holds.user_id = Patrons.id
    ORDER BY Holds.rank;
```

### 10.2 Make a list of all book titles and denote whether or not a copy of that book is checked out.

```
SELECT Books.title, 
    (Transactions.checked_out_date IS NOT NULL AND Transactions.checked_in_date IS NULL) AS checked_out
    FROM 
    Books LEFT OUTER JOIN Transactions ON Books.isbn = Transactions.isbn
```

### 10.3 In an effort to learn which books take longer to read, the librarians would like you to create a list of total checked out time by book name in the past month.
```
SELECT Books.title, SUM(Transactions.checked_in_date - Transactions.checked_out_date) FROM
    Books INNER JOIN Transactions ON Books.isbn = Transactions.isbn 
    WHERE Transactions.checked_in_date IS NOT NULL AND Transactions.checked_in_date >= (now() - interval '1 month');
```

### 10.4 In order to learn which items should be retired, make a list of all books that have not been checked out in the past 5 years.
```
    SELECT Books.* FROM
        Books LEFT OUTER JOIN Transactions on Books.isbn = Transactions.isbn
        WHERE Transactions.checked_out IS NULL OR Transactions.checked_out <= (now() - interval '5 years');
```
### 10.5 List all of the library patrons. If they have one or more books checked out, correspond the books to the patrons.
```
SELECT array_agg(Books.title)
```
