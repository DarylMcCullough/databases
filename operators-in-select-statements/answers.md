
## 1. Write out a generic SELECT statement

```
SELECT <columns> from <tablename> WHERE <condition>;
```

In the above, 

* The `<columns>` should be filled in by a list of column names, separated by commas, or the symbol `*` to mean "all columns".
* The `<tablename>` should be filled in by the name of the table.
* The `<condition>` should be a logical statement, built up out of atomic statements using the logical operators `AND`, `OR` or `NOT`. 
The atomic statements are of the form `<columnname> <comparison> <value>`, where the comparison can be `=`, `!=`, `>`, `>=`, `<`, `<=`, or `LIKE`.

## 2. Create a fun way to remember the order of operations in a SELECT statement, such as a mnemonic.

In the lessons so far, we've only been told about three parts of a `SELECT` statement: `SELECT`, `FROM` and `WHERE`. 
According to [SQL Order of Operations](https://www.bennadel.com/blog/70-sql-query-order-of-operations.htm), there are a few more: `GROUP BY`, `HAVING` and `ORDER BY`.

The order of operations are
1. `FROM`: Decide which table to use.
2. `WHERE`: Decide what criterion for picking rows.
3. `GROUP BY`: Decide how you want the returned data organized (I guess)
4. `HAVING`: This is another condition like `WHERE` but it applies to aggregate operations such as `COUNT`
5. `SELECT`: Decide which columns of the selected rows to return.
5. `ORDER BY`: Decide how to order the result, based on the column values.

(Apparently, there are even more operations, but I don't know what they mean: [Understanding the Logical Order of Operations in SELECT Statements](http://blog.aajtech.com/blog/sql-programming-understanding-the-logical-order-of-operations-in-select-statements/))

My mnemonic for remembering these is **F**orget **W**hat **G**randpa **H**as **S**aid **O**utloud.

## 3. Create a pets database.
* Create a dogs table using this file. 
* From the dogs table with the columns id, name, gender, age, weight, intake_date, breed, and in_foster
* Write statements to select the following pieces of data.
* 
### 3.1 Display the name, gender, and age of all dogs that are part Labrador.

```SELECT name, gender, age from dogs WHERE breed LIKE '%labrador%';```

Result:

|  name  | gender | age | 
|--------|--------|-----|
| Boujee | F      |   3 |
| Marley | M      |   0 |



### 3.2 Display the ids of all dogs that are under 1 year old.

```SELECT id from dogs WHERE age < 1; ```

Result:
|  id   | 
|-------|
| 10002 |
| 10004 |

### 3.3 Display the name and age of all dogs that are female and over 35lbs.

```SELECT name, age FROM dogs WHERE gender = 'F' AND weight > 35;```

Result:

|  name  | age |
|--------|-----|
| Boujee |   3 |

### 3.4 Display all of the information about all dogs that are not Shepherd mixes.
```SELECT * FROM dogs WHERE breed NOT LIKE '%shepherd%';```

Result:
|  id   |   name    | gender | age | weight |       breed        | intake_date | in_foster  |  
|-------|-----------|--------|-----|--------|--------------------|-------------|------------|
| 10001 | Boujee    | F      |   3 |     36 | labrador poodle    | 2017-06-22  | null       |
| 10002 | Munchkin  | F      |   0 |      8 | dachsund chihuahua | 2017-01-13  | 2017-01-31 |
| 10004 | Marley    | M      |   0 |     10 | labrador           | 2017-05-04  | 2016-06-20 |
| 10006 | Marmaduke | M      |   7 |    150 | great dane         | 2016-03-22  | 2016-05-15 |
| 10007 | Rosco     | M      |   5 |    180 | rottweiler         | 2017-04-01  | null       |

### 3.5 Display the id, age, weight, and breed of all dogs that are either over 60lbs or Great Danes.
Intake teams typically guess the breed of shelter dogs, so the breed column may have multiple words (for example, "Labrador Collie mix").

```
SELECT id, age, weight, breed FROM dogs WHERE breed='great dane' OR weight > 60;
```

Result:

|  id   | age | weight |   breed    |
|-------|-----|--------|------------|
| 10006 |   7 |    150 | great dane |
| 10007 |   5 |    180 | rottweiler |


## 4.From the cats table below, what pieces of data would be returned from these queries?

```SELECT name, adoption_date FROM cats;```
| name     | adoption_date |
| -------- |---------------|
| Mushi    | 03-22-2016    |
| Seashell |               |
| Azul     | 04-17-2016    |
| Victoire |  09-01-2016   |
| Nala     |               |


```SELECT name, age FROM cats;```
| name     |age |
| -------- |----|
| Mushi    | 1  |
| Seashell | 7  |
| Azul     | 3  |
| Victoire | 7  |
| Nala     | 1  |

## 5. From the cats table, write queries to select the following pieces of data.
### 5.1 Display all the information about all of the available cats.
```
SELECT * from cats;
```
### 5.2 Choose one cat of each age to show to potential adopters.
```
SELECT * FROM cats WHERE gender='M';
```
(This just happens to work, because there are 3 male cats, of age 1, 3 and 7.)

### 5.3 Find all of the names of the cats, so you don’t choose duplicate names for new cats.
```
SELECT name from cats;
```

## 6. List each comparison operator and explain, in your own words, when you would use it. Include a real world example for each.
* `>`: You would use this operator most often when there is a column with a numerical value, and you want to only select only rows with a large value for this field.
For example, if you're shipping products, maybe smaller items can go by mail, but the larger items must be delivered by truck. So for the truck delivery, you might
run the query `SELECT * from orders WHERE weight > 50;`
* `>=`: This is similarly useful when there is a criterion based on a numerical value. For example, searching for a family car, you want one that seats at least 4. So you 
might do a search `SELECT * from cars WHERE seats >= 4;`
* `<`: You would use this when the criterion has an upper bound. For example, looking for products that cost less than $100: `SELECT * from products WHERE price < 100;`
* `<=`: This is similar but when the criterion is that you have an amount that you are willing to include, or anything smaller. For example, you want a lightweight
laptop that is less than or equal to 2 pounds.
* `=`: This is a more general comparison, because it can be used for any type of value, not just ordered ones. If you are looking for something specific, for example,
a blue car, you can include that in your criterion as follows: `SELECT * from cars WHERE color=blue;`
* `LIKE`: This is specifically for string values. It allows you to compare a name with a pattern, rather than an exact value. For example, if you are looking for a book,
and you don't remember the author, but you know it was something Smith, you can form the pattern "%Smith", which will match "John Smith" or "Steve Smith", etc. In
your query, you can write `SELECT * from books WHERE author LIKE '%Smith';`
* `!=`: This is useful when you want to exclude something based on a specific criterion. For example, you're interested in getting a book, but you don't like horror
novels. You can write a query: `SELECT * from books WHERE genre != 'horror';`


        If you can’t list these from memory, do these flashcards until you can!
## 7.From the cats table (problem 4), what data would be returned from these queries?
```
SELECT name FROM cats WHERE gender = ‘F’;
```
This will return:

| name     |
| -------- |
| Seashell |
| Nala     |

```
SELECT name FROM cats WHERE age <> 3;
```
| name     |
| -------- |
| Mushi    |
| Seashell |
| Victoire |
| Nala     |

```
SELECT ID FROM cats WHERE name != ‘Mushi’ AND gender = ‘M’;
```

| id    |
| ----- |
| 00003 |
| 00004 |


cats

| id    | name     |gender |age |intake_date | adoption_date |
| ----- | -------- | ----- |----|------------|---------------|
| 00001 | Mushi    | M     | 1  | 01-09-2016 | 03-22-2016    |
| 00002 | Seashell | F     | 7  | 01-09-2016 |               |
| 00003 | Azul     | M     | 3  | 01-11-2016 | 04-17-2016    |
| 00004 | Victoire | M     | 7  | 01-11-2016 | 09-01-2016    |
| 00005 | Nala     | F     | 1  | 01-12-2016 |               |


