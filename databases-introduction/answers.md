
# Exercises

## 1. Given the values table below, which data types and meanings are the same? Which are different?

In the values table, the types of the first, third and fourth values are VARCHAR (or CHAR), and
the type of the second value, 42, is INT. Since all values in the same column have the same type,
the type of these values would have to be either VARCHAR or CHAR.

## 2. Explain in your own words when a database might be used. Explain when a text file might be used.

A database is useful when you have lots of pieces of data, and each of the pieces has the same
structure. Examples might be data about club members (name, email, phone number) or data about
purchases (what type of item, how many, price per item, etc.).

On the other hand, if the data does not have a definite structure, then a database might not
be appropriate. For example, an essay would best be stored in a text file.

## 3. Describe one difference between SQL and other programming languages.

SQL is more declarative than most other programming languages. In SQL, you describe
what information you are interested in (for example, the names and addresses of club
members who are having birthdays this month) but you don't need to explicitly say how
that data is collection---how you iterate over the data.

## 4. In your own words, explain how the pieces of a database system fit together at a high level.

A database system has two major parts:

1. The data itself, which is partitioned into databases, which are partitioned into tables, which are partitioned into rows and columns.
2. The query engine, which takes commands from a user in the form of queries, interprets the commands, and returns the data specified.

## 5. Explain the meaning of table, row, column, and value.

Roughly speaking, a table is a collection of data objects all of the same type.
The type of object is specified by giving a number of named fields (the columns) and a simple 
datatype for each field. Each object in the table is specified by giving a value of the
appropriate type for each field.

A table is analogous to an array of hashes in Ruby, except that there are some additional
constraints:

1. Every hash in the collection must have the same keys (which are represented as column names).
2. The datatype of the value associated with a key must be the same for each hash.
3. The values of the hashes must be simple datatypes (strings and integers, etc., instead of complex objects)

## 6. List 3 data types that can be used in a table.

1. `CHAR(n)`: The type of character strings of length `n`.
2. `INT`: The type of small integers (there is a limited number of digits available).
3. `DATE`: The type of calendar dates (year/month/day)

## 7. Given the payments table below, answer the following questions:

### 7.1 What is the result, if we select all the dates and amounts?

|date       | 	amount  |
|-----------|-----------|
|5/1/2016 	|   1500.00	|
|5/10/2016  | 	37.00   |
|5/15/2016 	| 	124.93 	|
|5/23/2016 	| 	54.72   |

### What is the result, if we select all amounts greater than 500?

| 	amount  |
|-----------|
|1500.00 	|


### What is the result, be if we select all purchases made at Mega Foods?

|date       |payee                  | 	amount  | 	memo        |
|-----------|-----------------------|-----------|---------------|
|5/15/2016 	|Mega Foods             | 	124.93 	|Groceries      |

## Given the users table below, write the following SQL queries and their results:

### Select the email and sign-up date for the user named DeAndre Data.

`SELECT email, signup FROM users WHERE name = 'DeAndreData';`

### Select the user ID for the user with email 'aleesia.algorithm@uw.edu'.

`SELECT userid FROM users WHERE email = 'aleesia.algorithm@uw.edu';`

### Select all the columns for the user ID equal to 4.

`SELECT userid FROM users WHERE userid = 4;`

### values
| value         |
|---------------|
|Chen           |
|Jones          |
|42             |
|Viola Davis    |

## payments

|date       |payee                  | 	amount  | 	memo        |
|-----------|-----------------------|-----------|---------------|
|5/1/2016 	|West Hill Apartments 	|1500.00 	|Rent           |
|5/10/2016  | 	Best Toy Store      | 	37.00   |Beanie Babies  |
|5/15/2016 	|Mega Foods             | 	124.93 	|Groceries      |
|5/23/2016 	|Shoes R Cool           | 	54.72   |Athletic shoes |

## users

|userid | 	name 	        |email                          | 	signup  |
|-------|-------------------|-------------------------------|-----------|
|1 	    |Aleesia Algorithm 	|aleesia.algorithm@uw.edu 	    |2014-10-24 |
|2 	    |DeAndre Data 	    |datad@comcast.net 	            |2008-01-20 |
|3 	    |Chris Collection 	|chris.collection@outlook.com 	|2012-01-20 |
|4 	    |Brandy Boolean 	|bboolean@nasa.gov 	            |1999-10-15 |  