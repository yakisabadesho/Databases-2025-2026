-- PART 3
--3.1
CREATE TABLE accounts (
 id SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 balance DECIMAL(10, 2) DEFAULT 0.00
);
CREATE TABLE products (
 id SERIAL PRIMARY KEY,
 shop VARCHAR(100) NOT NULL,
 product VARCHAR(100) NOT NULL,
 price DECIMAL(10, 2) NOT NULL
);
-- Insert test data
INSERT INTO accounts (name, balance) VALUES
 ('Alice', 1000.00),
 ('Bob', 500.00),
 ('Wally', 750.00);
INSERT INTO products (shop, product, price) VALUES
 ('Joe''s Shop', 'Coke', 2.50),
 ('Joe''s Shop', 'Pepsi', 3.00);

--3.2
BEGIN;
UPDATE accounts SET balance = balance - 100.00
 WHERE name = 'Alice';
UPDATE accounts SET balance = balance + 100.00
 WHERE name = 'Bob';
COMMIT;

/*
A)Alice's balance is 900, Bob's is 600
B)Because the whole point of a transaction is being a singular, non-interruptible action. Basically to ensure that nothing happens between the two commands
C)We would be left with Bob's balance not being updated, while Alice's is
*/

--3.3
BEGIN;
UPDATE accounts SET balance = balance - 500.00
 WHERE name = 'Alice';
SELECT * FROM accounts WHERE name = 'Alice';
-- Oops! Wrong amount, let's undo
ROLLBACK;
SELECT * FROM accounts WHERE name = 'Alice';

/*
A)It's 400
B)900
C)When you've entered wrong data or updated the wrong row. When you messed up
*/

--3.4
BEGIN;
UPDATE accounts SET balance = balance - 100.00
 WHERE name = 'Alice';
SAVEPOINT my_savepoint;
UPDATE accounts SET balance = balance + 100.00
 WHERE name = 'Bob';
-- Oops, should transfer to Wally instead
ROLLBACK TO my_savepoint;
UPDATE accounts SET balance = balance + 100.00
 WHERE name = 'Wally';
COMMIT;

/*
A)Alice - 800, Bob - 600, Wally - 850
B)Bob's account wasn't touched, since we rolled back to our savepoint that has been made before updating Bob
C)Saves computing power by not rolling back the entire transaction, lets you keep the changes in check etc.
*/

--3.5 A
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM products WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2 to make changes and COMMIT
-- Then re-run:
SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;

/* Commented out for safety
BEGIN;
DELETE FROM products WHERE shop = 'Joe''s Shop';
INSERT INTO products (shop, product, price)
 VALUES ('Joe''s Shop', 'Fanta', 3.50);
COMMIT;
*/

--3.5 B
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM products WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2 to make changes and COMMIT
-- Then re-run:
SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;

/* Commented out for safety
BEGIN;
DELETE FROM products WHERE shop = 'Joe''s Shop';
INSERT INTO products (shop, product, price)
 VALUES ('Joe''s Shop', 'Fanta', 3.50);
COMMIT;
*/

/*
A) In scenario A, terminal 1 sees 2 products in Joe's shop, each priced around ~3.00, I dont remember
After terminal 2 has commited, terminal 1 sees only 1 product - Fanta priced at 3.50

B)In scenario B, terminal 1 sees a single product - Fanta priced at 3.50. 

C)In READ COMMITTED each query withing the transaction can only see data committed before that query started
Whereas in SERIALIZABLE each query within the transaction can only see data committed before that transaction started.
*/

--3.6
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT MAX(price), MIN(price) FROM products
 WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2
SELECT MAX(price), MIN(price) FROM products
 WHERE shop = 'Joe''s Shop';
COMMIT;

/* Commented out for safety
BEGIN;
INSERT INTO products (shop, product, price)
 VALUES ('Joe''s Shop', 'Sprite', 4.00);
COMMIT;
*/

/* A)Terminal 1 doesn't, because of the isolation level
B) Phantom read is a return of the query that isn't actually committed yet
C)SERIALIZABLE, REPEATABLE READ
*/

--3.7
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM products WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2 to UPDATE but NOT commit
SELECT * FROM products WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2 to ROLLBACK
SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;

/* Commented out for safety
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM products WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2 to UPDATE but NOT commit
SELECT * FROM products WHERE shop = 'Joe''s Shop';
-- Wait for Terminal 2 to ROLLBACK
SELECT * FROM products WHERE shop = 'Joe''s Shop';
COMMIT;
*/

/*
A)It didn't, I didn't really. But if it was supposed to, I guess it could be problematic due to being a "phantom read" and not displaying the actual data
B)A dirty read is a transaction reading data that has been modified by another transaction, but not yet committed
C)Because it will result in dirty reads, and we don't want that
*/

--PART 4
--4.1
BEGIN;
UPDATE accounts
SET balance = balance + 200.00
WHERE name = 'Wally'
AND EXISTS (
SELECT 1
FROM accounts
WHERE name = 'Bob'
AND balance > 199.99);
UPDATE accounts
SET balance = balance - 200.00
WHERE name = 'Bob'
AND EXISTS (
SELECT 1
FROM accounts
WHERE name = 'Bob'
AND balance > 199.99);
COMMIT;

--4.2
BEGIN;
INSERT INTO products (shop, product, price)
VALUES ('Joe''s Shop', 'Red Bull', 3.50);
SAVEPOINT sp_1;
UPDATE products
SET price = price + 1.00
WHERE product = 'Red Bull';
SAVEPOINT sp_2;
DELETE FROM products WHERE product = 'Red Bull';
ROLLBACK TO sp_1;
COMMIT;

SELECT * FROM products;
--1.png

--4.3 
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE accounts
SET balance = balance - 200.00
WHERE name = 'Wally'
SELECT * FROM accounts;
--Wait for the second guy to withdraw
SELECT * FROM accounts;
COMMIT;


/* second guy
BEGIN;
UPDATE accounts
SET balance = balance - 100.00
WHERE name = 'Wally';
COMMIT;
*/
-- Results in an infinite action, an error

--PART 5
/*
1)
Atomic - If you don't COMMIT at the end, nothing gets changed in the database. You disconnect then reconnect to the DB, write a query and it's as if nothing has been written at all
Consistent - A transaction is either done or not. It can't partially alter the DB, since it will only do what it had to do or not do it at all.
Isolated - When you query before the transaction, it shows data. When you query after, it shows data altered by the transaction. No inbetween, you can't barge in while the data's updating or something.
Durable - Data or data changes dont get lost if the system crashes in the middle of a transaction, since it either happened or not.

2)
COMMIT runs the transaction, officializing it and making actual changes
ROLLBACK returns the database to the state before the transaction

3)
When you want to keep specific actions in check, only rolling back to savepoints to not disregard everything you've done in the transaction

4)
SERIALIZABLE - No phantoms, highest isolation
REPEATABLE READ - Reads are guaranteed to be the same if read again, may have phantom reads
READ COMMITED - Sees only committed data, yet can see differing data on reread, phantom reads are present, can't read twice for the same result
READ UNCOMMITTED - Least isolated, sees uncommitted changes from other transactions, unreliable. Comes with dirty reads as well as phantom reads

5)Dirty read is a transaction reading data that has been modified by another transaction, but not yet committed
Allowed by READ UNCOMMITTED

6)Non-repeatable read is a read that can't ensure same data on a reread. For instance - the bank account withdrawal problem from part 4. 
If the isolation level wasn't SERIALIZABLE it would have read 2 different values from Wally's balance, first before being withdrawed by the second terminal, second after. Different values

7)Phantom read is a read where inbetween 2 identical queries another query has been committed and now it reads wrong rows because of that.
Phantom read is allowed by REPEATABLE READ, READ COMMITTED and READ UNCOMMITTED.
It's prevented by SERIALIZABLE

8)To ensure lack of dirty reads

9)It helps with not messing up the database when a bunch of users alter it at once, ensuring that stuff happens sequentially, checking that the previous action has been completed
before proceeding with the next one

10)They stay uncommitted, never making a single change in the DB






