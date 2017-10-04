
### 1. List the commands for adding, updating, and deleting data
* CREATE TABLE
* INSERT INTO
* UPDATE
* DELETE FROM
* ALTER TABLE
* DROP TABLE

### 2. Explain the structure for each type of command.

#### CREATE TABLE
```
  CREATE TABLE <tablename> (
      <column1> <type1>,
      <column2> <type2>,
      ...
  );
```

In the `CREATE TABLE` command, you specify:
1. The table name.
2. For each column, you specify the name of the column and the type of its values

#### INSERT INTO

```
INSERT INTO <tablename> (<column1>, <column2>, <column3>)
  VALUES
  <tuple1>,
  <tuple2>,
  ...
```

In the `INSERT INTO` command, you specify:

1. The name of the table you are inserting into.
2. The names of the columns you are providing data for.
3. One or more tuples, where each tuple contains a value for each column (separated by commas, and enclosed in parentheses).

The order of the values in each tuple must be the same as the order of the column names used in the command.

#### UPDATE
```
UPDATE <tablename> SET <column1>=<value1>, <column2>=<value2>, ... WHERE <condition>;
```
In the `UPDATE` command, you must provide:
1. The name of the table being updated.
2. A list of columns to be updated, together with the value of that column in the form `<columnname>=<value>`.
3. A `WHERE` clause specifying which rows to update. The `WHERE` clause is a logical 
expression made up of atomic statements of the form `<column1>=<value1>`, connected using logical connectives such a `AND`. 
The update would apply to those rows satisfying the `WHERE` clause.

### 3. What are some the data types that can be used in tables? Give a real world example of each.
* `DECIMAL`: This is a data type used for real numbers, where the maximum value and the precision is specified ahead of time. For example: weights, temperatures, lengths, test scores could be stored as decimals.
* `VARCHAR`: This is a data type used for character strings of limited, but varying length. For example: names, passwords, colors, types of products, etc.
* `DATE`: This is the data type used for specifying a particular month, day and year. For example: birthdays, holidays, due-dates, etc.
* `BOOLEAN`: This is the data type used for answers to yes/no or true/false questions. For example: Are you over 18? Are you registered to vote? Is this item taxable?

### 4. Think through how to create a new table to hold a list of people invited to a wedding. This table needs to have first and last name, whether they sent in their RSVP, the number of guests they are bringing, and the number of meals (1 for adults and 1/2 for children).
#### 4.1 Which data type would you use to store each of the following pieces of information?

* First and last name: `VARCHAR`
* Whether they sent in their RSVP: `BOOLEAN`
* Number of guests: `SMALLINT`
* Number of meals: `DECIMAL`

#### 4.2 Write a command that makes the table to track the wedding.

```
CREATE TABLE wedding_guests (
    first VARCHAR(50),
    last VARCHAR(50),
    rsvp BOOLEAN,
    guests SMALLINT,
    meals DECIMAL(3,1)
);
```

#### 4.3 Using the table we just created, write a command that adds a column to track whether they were sent a thank you card.
```
ALTER TABLE wedding_guests ADD COLUMN thank_you_sent BOOLEAN;
```

#### 4.4 You have decided to move the data about the meals to another table, so write a command to remove the column storing the number meals from the wedding table.
```
ALTER TABLE wedding_guests DROP COLUMN meals;
```
#### 4.5 The guests are going to need a place to sit at the reception, so write a statement that adds a column for table number.

```
ALTER TABLE wedding_guests ADD COLUMN table SMALLINT;
```
#### 4.6 The wedding is over and we do not need to keep this information, so write a command that deletes the wedding table from the database.
```
DROP TABLE wedding_guests;
```

### 5. Write a command to make a new table to hold the books in a library with the columns ISBN, title, author, genre, publishing date, number of copies, and available copies.

```
CREATE TABLE books (
    ISBN CHAR(10),
    title VARCHAR(300),
    author VARCHAR(100),
    genre VARCHAR(100),
    published DATE,
    copies SMALLINT,
    available SMALLINT
);
```

#### 5.1 Find three books and add their information to the table.

```
INSERT INTO books (ISBN, title, author, genre, published, copies, available)
VALUES
('9-781476-770390', 'Revival', 'Stephen King', 'horror', DATE'2015-05-01', 1, 1),
('9-780375-727207', 'The Fabric of the Cosmos', 'Brian Greene', 'nonfiction', DATE'2005-02-01', 1, 1),
('0-19-504671-4', 'The Nature of Mind', 'David M. Rosenthal, editor', 'nonfiction', DATE'1991-01-01', 1, 1);

```
#### 5.2 Say that someone has just checked out one of the books. Change the available copies column to 1 less.

```
UPDATE books SET available = available - 1 WHERE title='Revival' AND author='Stephen King';
```

#### 5.3 Now one of the books has been added to the banned books list. Remove it from the table.
```
DELETE FROM books WHERE title='The Fabric of the Cosmos' AND author='Brian Greene';
```

### 6. Write a command to make a new table to hold spacecrafts. Information should include id, name, year launched, country of origin, a brief description of the mission, orbiting body, if it is currently operating, and approximate miles from Earth.
```
CREATE TABLE spacecrafts (
    id SMALLINT,
    name VARCHAR(100),
    year_launched DECIMAL(4,0),
    country VARCHAR(100),
    mission TEXT,
    orbiting_body VARCHAR(100),
    in_operation BOOLEAN,
    distance INT
);
```

#### 6.1 Add 3 non-Earth-orbiting satellites to the table.
```
INSERT INTO spacecrafts (id, name, year_launched, country, mission, orbiting_body, in_operation, distance)
VALUES
(1, 'mars probe', '2007', 'USA', 'take pictures of mars', 'Mars', TRUE, 33900000),
(2, 'venus probe', '2011', 'India', 'take pictures of venus', 'Venus', TRUE, 162000000),
(3, 'jupiter probe', '1989', 'USSR', 'take pictures of jupiter', 'Jupiter', FALSE, 365000000)
```
#### 6.2 Remove one of the satellites from the table since it has just been crashed into the planet.

```
DELETE FROM spacecrafts WHERE name = 'mars probe';
```

#### 6.3 Edit another satellite because it is no longer operating and change the value to reflect that.
```
UPDATE spacecrafts SET in_operation=FALSE WHERE name='venus probe';
```

### 7. Write a command to make a new table to hold the emails in your inbox. This table should include an id, the subject line, the sender, any additional recipients, the body of the email, the timestamp, whether or not it’s been read, and the id of the email chain it’s in.
(Note: I'm also going to include a `primary_recipient` field, so that the same table can be used for mail to and from a number of users.)

```
CREATE TABLE emails (
    id INT,
    subject VARCHAR(300),
    sender VARCHAR(100),
    primary_recipient VARCHAR(100),
    cc VARCHAR(300),
    body TEXT,
    received TIMESTAMP,
    read BOOLEAN,
    chain_id INT
);
```

#### 7.1 Add 3 new emails to the inbox.
```
INSERT INTO emails (id, subject, sender, primary_recipient, cc, body, received, read, chain_id)
VALUES
(1, 'book club meeting', 'there will be a meeting this Friday at 6 pm, at the Barnes and Nobles cafe', 'daryl@my_work.com', 'tom@acme.com, harry@google.com, sally@espn.com', TIMESTAMP'2017-09-30 12:11:21', 67),
(2, 'phone bill overdue', 'Your bill for September was $340.25. Please pay immediately. Verizon, 123 Phone St., Wilimington, DE 12345', 'daryl@my_work.com', '', TIMESTAMP'2017-10-01 11:12:13', 78),
(3, 'please donate', 'Hi, I'm running for Congress. If you agree with me on the issues, please contribute to my campaign', 'daryl@my_work.com', 'sam@house.gov', TIMESTAMP'2016-07-30 10:31:21', 45),

```
#### 7.2 You’ve just deleted one of the emails, so write a command to remove the row from the inbox table.
```
DELETE from emails WHERE id=1;
```
#### 7.3 You’ve just sent an email to the wrong person. Using the handy undo feature from your email provider, you quickly correct this and send it to the correct recipient. Write a command to reflect this change in the database.
```
UPDATE emails SET primary_recipient = 'fred@fredco.com';
```