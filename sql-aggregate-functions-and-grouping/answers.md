## 1. List 5 aggregate functions and explain, in your own words, what they are for.
**Include a real world example for each. If you can’t list these from memory, do these flashcards until you can!**

1. `SUM`: This is used to add up all of the values for a particular column, for all rows satisfying the `WHERE` criterion. An example might be a table giving an expense account for a business. To compute how much the business spent during a time period, we could perform a `SUM` of the `cost` column for all expenses incurred during that time period.
2. `COUNT`: This is used to compute the number of rows satisfying a particular criterion. An example might be a hotel, which has a table of reservations. We could perform a `COUNT` of all the reservations for a particular date to find out if there are any rooms available.
3. `MIN`: This is used to find the minimum value for a particular column, for all rows satisfying some criterion. An example might be a list of items for sale, with their prices. Getting the minimum cost for all items of a particular type could be used to let a customer know whether he can afford to by one of the items.
4. `MAX`: Similarly, this is used to find the maximum value for a particular column, for all rows satisfying some criterion. An example might be a database of available hotel rooms. Each hotel room has a guests-number, the number of guests that can stay in that room. If you perfrom a `MAX` over all rooms, you can get an idea of how many rooms must be reserved for your group.
5. `AVERAGE`: This is used to average some column over all rows satisfying a particular criterion. For example, if you're considering doing a home renovation, the contractor may have a database of all previous jobs. By using `AVERAGE`, you can get an idea of the typical cost and time required for a particualr type of renovation.

## 2. Create a database called iron-bank-foundation.
**Create a donations table, and import CSV data from this file.**

**Commands used:**
* `sudo sudo -u postgres createdb -U postgres -w iron-bank-foundation`: Creates the database
* `sudo sudo -u postgres psql`: Log into psql
* `\c iron-bank-foundation`: Connect to database
* ```CREATE TABLE donations (
      iron-bank-foundation(# donor VARCHAR(100),
      iron-bank-foundation(# amount SMALLINT,
      iron-bank-foundation(# date DATE);```: Creates the table, giving names and types to columns.
* `COPY donations FROM '/home/ubuntu/workspace/sql-aggregate-functions-and-grouping/donations.csv' WITH (DELIMITER ',',  FORMAT CSV, HEADER TRUE);`: loads table from CSV file

**Select the following data from the table:**
### 2.1 Find the total of all donations received in the past year.
```SELECT SUM(amount) FROM donations WHERE date <= DATE'2017-12-31' AND date >= DATE '2017-01-01';```

Result:
| sum | 
|-----|
| 993 |

### 2.2 Find the total donations over time per donor.
**(i.e. Tanysha has donated 3 times with the amounts $25, $30, and $50. Her total is $105. )**

`SELECT donor, COUNT(amount) AS num_donations, SUM(amount) AS total_donations, array_to_string(array_agg1(
amount), ',') AS all_donations FROM donations GROUP BY donor;`

where `array_agg1` is defined by:
```
CREATE AGGREGATE array_agg1 (anyelement)
(
    sfunc = array_append,
    stype = anyarray,
    initcond = '{}'
);
```
[Postgresql GROUP_CONCAT equivalent?](https://stackoverflow.com/questions/2560946/postgresql-group-concat-equivalent)
(It turns out there is already a function `array_agg`, but I didn't know it.)

Results:

|   donor    | num_donations | total_donations | all_donations |
|------------|---------------|-----------------|---------------|
| Samwell    |             1 |              20 | 20            |
| Daario     |             1 |              10 | 10            |
| Brienne    |             1 |              75 | 75            |
| Tyrion     |             3 |             120 | 60,50,10      |
| Petyr      |             1 |              70 | 70            |
| Melisandre |             1 |              45 | 45            |
| Bran       |             1 |              25 | 25            |
| Tormund    |             1 |              50 | 50            |
| Ygritte    |             1 |              30 | 30            |
| Gilly      |             1 |               7 | 7             |
|  Jon       |             1 |              25 | 25            |
| Arya       |             3 |              60 | 15,30,15      |
| Theon      |             2 |              20 | 5,15          |
| Bronn      |             1 |              20 | 20            |
| Margaery   |             1 |             120 | 120           |
| Missandei  |             4 |              90 | 25,30,10,25   |
|  Margaery  |             1 |             120 | 120           |
| Missandei  |             4 |              90 | 25,30,10,25   |
| Sansa      |             1 |              33 | 33            |
| Daenerys   |             2 |             173 | 102,71        |


### 2.3 What is the average donation per donor?
`SELECT AVG(total_amt) as avg_donation FROM (SELECT donor, SUM(amount) as total_amt FROM donations GROUP BY donor) AS foo;`

This first computes the total donation amount per donor, and then averages over the result.
Result:

|    avg_donation     |   
|---------------------|
| 55.1666666666666667 |

### 2.4 How many donations over $100 have been received?
`SELECT COUNT(amount) AS num_donations FROM donations WHERE amount > 100;`

Result:

|num_donations  |
|---------------|
|             2 |

### 2.5 What is the largest donation received in a single instance from a single donor?
`SELECT MAX(amount) AS max_donation FROM donations;`

Result:
| max_donation |
|--------------|
|          120 |

### 2.6 What is the smallest donation we’ve received?
`SELECT MIN(amount) AS min_donation FROM donations;`

Result:
| min_donation |
|--------------|
|            5 |

## 3. How would you determine the display order of data returned by your SELECT statement?
Use `ORDER BY <columname>` to order the results by the value of a particular column.


## 4. What is a real world situation where you would use OFFSET?

We have a database of entrance exams for an elite school. The top 10 scorers get in.
The next 10 scorers get an invitation to try again. To construct the letters to the
second-tier test-takers, you would do a SELECT ordered by score, limit 10 offset 10.

## 5. Why is it important to use ORDER BY when limiting your results?
Typically, you don't want to get a random selection of results. If you want to
see a subset of the results, you typically would want the most important, or 
highest priority, results. So you would use ORDER BY to sort them according to
whatever ranking is important, then limit it to the top results.

## 6. What is the difference between HAVING and WHERE?

`WHERE` is used to select which rows to consider in a `SELECT` statement. It filters
rows based on the values for each column. `HAVING` is a secondary selection, based
on the results of aggregation. So for example, if you have a test result database,
you might want to display the students whose average test score for tests taken in
September is greater than 90. Then you would use `WHERE` to select test results 
from September, and then use `HAVING` on the resulting averages. The full query
would be something like:

`SELECT student, AVG(score) as avg_score from test_scores GROUP BY student HAVNG avg_score > 90;`

## 7. Correct the following SELECT statement:

```     SELECT id, SUM (amount)
     FROM payment
     HAVING SUM (amount) > 200;
```

It should probably be:
```     SELECT id, SUM (amount)
     FROM payment
     GROUP BY id
     HAVING SUM (amount) > 200;
```
## 8. Write queries to retrieve the following information.
### 8.1 From the cats table, list all cats organized by intake date.
`SELECT * FROM cats ORDER BY intake_date;`

### 8.2  Given an adoptions table with the columns id, date, adopter, cat, and fee, determine the 5 most recent adoptions to be featured as “Happy Tails” on social media.
`SELECT * FROM adoptions ORDER BY date DESC LIMIT 5;`

### 8.3 There is a potential adopter looking for an adult female cat. In the most efficient way possible, from the Cats table, list all female cats 2 or more years old.
`SELECT * FROM cats WHERE gender='F' AND age >= 2;`

### 8.4 From the donations table (described in problem #2), find the top 5 donors with the highest cumulative donation amounts to be honored as “Platinum Donors”.

`SELECT donor, SUM(amount) as cum_donation FROM donations GROUP BY donor ORDER BY cum_donation DESC LIMIT 5;`
Result:
|   donor   | cum_donation |
|-----------|--------------|
| Daenerys  |          173 |
| Margaery  |          120 |
| Tyrion    |          120 |
| Missandei |           90 |
| Brienne   |           75 |

## 8.5 From the donations table (described in problem #2), find donors 6-15 with the next highest cumulative donation amounts to be honored as “Gold Donors”.

`SELECT donor, SUM(amount) as cum_donation FROM donations GROUP BY donor ORDER BY cum_donation DESC LIMIT 10 OFFSET 5;`
Result:

|   donor    | cum_donation |
|------------|--------------|
| Petyr      |           70 |
| Arya       |           60 |
| Tormund    |           50 |
| Melisandre |           45 |
|  Sansa     |           33 |
| Ygritte    |           30 |
| Jon        |           25 |
| Bran       |           25 |
| Samwell    |           20 |
| Theon      |           20 |