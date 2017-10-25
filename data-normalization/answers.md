# Questions

## 1. In your own words, explain the benefits of normalization. Include a real-world scenario where normalization is necessary.

Normalization is a set of criteria for the organization of the information in a database that minimizes redundancy and dependencies
among the values in different columns. The advantages of normalization are:

* For a normalized database, it is easier to keep the information consistent.
* For a normalized database, updating (writing) is more efficient, because usually, only updates need only be made to one value of a row at a time.

An example of redundancy in a database would be a "travel club" database, which lists for each club member:

1. What is the current city the member is visiting
2. What is the current country the member is visiting

If this information were kept in a single table, updating the table would be error-prone, because if the city
is updated independently of the country, then the database would be (at least temporarily) inconsistent.

A normalized database would have two separate tables:

1. A cities table that would list the city id, the city name and the country where it is located
2. A travel table that would list the club member and the id of the city he is currently visiting.

With this organization of the information, it would only be necessary to change the city id in the
travel table when the traveler changes location, and the data would always remain consistent.

## 2. List and explain the different normal forms and how they relate to one another, with regard to your real-world scenario in the first question.

### 2.1 First normal form

The first normal form requires that every column have a single value in it. In the case of the travel database described above: If a traveler is visiting
a number of citites, then the city id for the traveler would become multi-valued. So the database would no longer be normalized. This could be fixed
by introducing a table called `visits`. Each visit would be associated with one traveler and one city. A traveler could then be
associated with multiple visits, and the first normal form would be satisfied.

### 2.2 Second normal form

The second normal form requires that the first normal form be satisfied, and also
that there can be no attributes associated with a subset of the primary key. In our example above, a `visit`
is uniquely determined by the two values: (1) the traveler, and (2) the city. Those two values form the primary key for a visit. Now, suppose
that we want to keep track of the age of the traveler, because there may special youth hostels available to those under 30, and there may be
special hotel discounts for those over 60. If we add an `age` column for the `visits` table, this would violate the second normal form,
because the age depends only on the traveler, not the cty.

To fix this normalization problem, we could create a `traveler`, which would record information about the traveler, such as his age. This
information would then be removed from the `visits` table.

### 2.3 Third normal form

The third normal form requires that the second normal form be satisfied, and also
that a table cannot contain transitive dependencies on non-prime attributes. If the value of column A depends on the value of column B,
and the value of column B depends on the value of column C, then A depends on C transitively. For our `visits` example, suppose that we 
have a column that gives the date of the visit, and another column that lists the season of the year for the visit. The season of the
year is a violation of the third normal form because it is a function of the date. The way that third normal form could be restored is
to have a table of seasons, with the start and end date for each season, and remove `season` from the `visits` table.

### 2.3.5 Boyce Codd Normal form

The Boyce Codd Normal form (BCNF) is a generalization of the third normal form. It requires that the third normal form be
satisfied and also that there can be no functional dependency on a collection of attributes that is not a super key (the attributes contain a primary key). Let's use the
travel database to illustrate this. Let's suppose that we have boolean-valued attributed `holiday` which indicates whether
the travel date is a local holiday. Whether the travel date is a holiday depends on two attributes: (1) the city (different
cities celebrate different holidays), and (2) the travel date. But those two columns do not contain a primary key, since
the primary key is the combination traveler + city. So having a `holiday` column would violate the BCNF.

This could be fixed by creating a `holidays` table that would have columns for `holiday_name`, `city` and `date_celebrated`,
and removing `holiday` from the `visits` table.

## 3. The student_records table below shows the students and their grades in different subjects. The table is already in first normal form (1NF). Convert this table to the third normal form (3NF) using the techniques you learned in this checkpoint.

### Original table:

**student_records**

| entry_id  | 	student_id  | 	professor_id 	| subject 	    | grade 	| professor_name 	| student_email 	            | student_name  |
|-----------|---------------|-------------------|---------------|-----------|-------------------|-------------------------------|---------------|
|1          | 	1           | 	        2 	    | Philosophy 	|   A       | 	William C       | 	john.b20@hogwarts.edu 	    |John B         |
|2          | 	2           | 	2               | 	Philosophy  | 	C 	    | William C         | 	sarah.s20@hogwarts.edu 	    |Sarah S        |
|3          | 	3           | 	1               | 	Economics   | 	A 	    | Natalie M         | 	martha.l20@hogwarts.edu     | 	Martha L    |
|4          | 	4           | 	3               |	Mathematics | 	B       |	Mark W          | 	james.g20@hogwarts.edu 	    |   James G     |
|5          | 	5           |	1               | 	Economics   | 	B       | 	Natalie M       | 	stanley.p20@hogwarts.edu    | 	Stanley P   |

### Refactored

In the refactoring, we take the data that only relates to students and put it into a students table,
and take the data that only relates to professors and put it into a professors table.

**students**

| 	student_id  | student_email 	            | student_name  |
|---------------|-------------------------------|---------------|
| 	1           |	john.b20@hogwarts.edu 	    |John B         |
| 	2           | sarah.s20@hogwarts.edu 	    |Sarah S        |
| 	3           | martha.l20@hogwarts.edu       | 	Martha L    |
| 	4           | james.g20@hogwarts.edu 	    |   James G     |
| 	5           |stanley.p20@hogwarts.edu       | 	Stanley P   |


**professors**

| 	professor_id 	|  professor_name 	| 
|-------------------|-------------------|
| 	2               | William C         |
| 	3               |	Mark W          |
|	1               | 	Natalie M       |

**student_records**

| entry_id  | 	student_id  | 	professor_id 	| subject 	    | grade 	|
|-----------|---------------|-------------------|---------------|-----------|
|1          | 	1           | 	2 	            |   Philosophy 	|   A       |
|2          | 	2           | 	2               | 	Philosophy  | 	C 	    |
|3          | 	3           | 	1               | 	Economics   | 	A 	    |
|4          | 	4           | 	3               |	Mathematics | 	B       |
|5          | 	5           |	1               | 	Economics   | 	B       |

## 4. In your own words, explain the potential disadvantages of normalizing the data above. What are its trade-offs? Discuss this with your mentor.

The biggest disadvantage of normalizing a database is that it makes it necessary to do "joins" in order to compute common queries.
For example, if we want to give the student name, professor name and course name for each course, it would be necessary to join
the students, professors and student_records tables. Joins are potentially time-consuming operations. So computing such a query
might take significantly longer than it would in the original, unnormalized table. On the other hand, updating is quicker and
less error-prone with normalized tables. If a student changes his email address, this change would only require a change to a
single value in the students table, rather than searching for the student in every student records entry (for the data we are
considering, each student only appears once, but potentially the student could appear multiple times.)

## 5. Looking at the tables you have normalized. If you need to denormalize to improve query performance or speed up reporting, how would you carry out denormalization for this database design? Discuss potential strategies with your mentor.


I think that denormalizing a normalized database can be thought of as partially "precomputing" parts of a query. For example,
in the student records database, in a normalized database, the student records table would just be a professor id, and the professor name would require a
query on the `professors` table. However, it's almost always the case that if you are issuing a query involving professors, you would
also want to give the professors' names. So restoring a professor's name column would allow the name to be easily looked up without
performing a `join` on another table. Also, in the `professors` table, it's quite common to want to know what all courses each professor
teaches. So we could add another column giving a list of course ids for courses taught by the professor. This would speed up queries,
at the cost of violating the first normal form.

## 6. Discuss the trade-offs between data normalization and denormalization in this scenario with your mentor.

A way to think about normalization and denormalization is in terms of various stages for using a database and trade-offs
among the time and effort required at each stage:

1. Designing the database.
2. Writing data to the tables.
3. Performing queries (reading) on the database.

With a normalized database, stages 1 and 3 are potentially more difficult and time consuming.
It requires a lot of thought about the data and the domain that the data describes in order to
know the functional dependencies among data values. Those functional dependencies have to be
understood in order to design a normalized database. So creating a normalized database in the first
place requires a lot of effort and possibly research. Also, as described earlier, querying a normalized
databased often requires complex queries involving multiple joins (or nested queries). But stage 2 is
easier for a normalized database, because if a data value needs to be changed, it often can be done on
a single column of a single row of the database. For nonnormalized databases, a change might require
searching the database for all the related changes that must be made.

So roughly speaking, the tradeoff is between complexity of updating versus complexity of querying, with 
normalized databases being easier to update but harder to query. In addition, designing a normalized database
can be a lot of work.