-- Aubanov Assylbek 24B031659

-- PART 1

-- Task 1.1:
CREATE TABLE employees (
employee_id SERIAL PRIMARY KEY,
first_name VARCHAR,
last_name VARCHAR,
age INT CHECK (age >= 18 AND age <= 65),
salary NUMERIC CHECK (salary > 0)
);

-- Task 1.2:
CREATE TABLE products_catalog (
product_id SERIAL PRIMARY KEY,
product_name VARCHAR,
regular_price NUMERIC,
discount_price NUMERIC,
CONSTRAINT valid_discount CHECK (regular_price > 0 AND discount_price > 0 AND discount_price < regular_price)
);

-- Task 1.3:
CREATE TABLE bookings (
booking_id SERIAL PRIMARY KEY,
check_in_date DATE,
check_out_date DATE,
num_guests INT,
CONSTRAINT num_guests_check CHECK (num_guests >= 1 AND num_guests <= 10),
CONSTRAINT check_in_out_valid CHECK (check_out_date > check_in_date)
);

-- Task 1.4:
-- 1

/*
INSERT INTO employees (first_name, last_name, age, salary)
VALUES ('Jonah','James',44,100000);
INSERT INTO employees (first_name, last_name, age, salary)
VALUES ('Albert','Birkin',29,120000);
INSERT INTO bookings (check_in_date,check_out_date, num_guests)
VALUES ('2025-02-24', '2025-02-26', 2);
INSERT INTO bookings (check_in_date,check_out_date, num_guests)
VALUES ('2025-02-25', '2025-02-28', 1);
INSERT INTO products_catalog(product_name,regular_price, discount_price)
VALUES ('Bushwacker1', 2000, 1500);
INSERT INTO products_catalog(product_name,regular_price, discount_price)
VALUES ('Crowbar', 1000, 700);

-- 2,3
-- Violates age between 18 and 65 constraint, also violates salary greater than zero constraint
INSERT INTO employees (first_name, last_name, age, salary)
VALUES ('Ram','Shrub',66,0);

-- Violates num_guests between 1 and 10 constraint, also the check_oud_date is before the check_in_date
INSERT INTO bookings (check_in_date,check_out_date, num_guests)
VALUES ('2025-02-24', '2025-02-10', 12);

-- Violates the valid_discount constraint by having both regular and discount prices be not greater than 0
INSERT INTO products_catalog(product_name,regular_price, discount_price)
VALUES ('Shovel', 0, 0);
*/

-- PART 2

-- Task 2.1:
CREATE TABLE customers (
customer_id SERIAL PRIMARY KEY,
email VARCHAR NOT NULL,
phone VARCHAR,
registration_date DATE NOT NULL);

-- Task 2.2:
CREATE TABLE inventory (
item_id SERIAL NOT NULL,
item_name VARCHAR NOT NULL,
quantity INT NOT NULL CHECK (quantity >= 0),
unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
last_updated TIMESTAMP NOT NULL);

-- Task 2.3:
/*
-- 1
INSERT INTO customers (email, phone, registration_date)
VALUES ('johnjones@jonah.com', '11248', '2023-01-23');
-- 2
INSERT INTO inventory (item_name)
VALUES ('shirtA');
-- 3
INSERT INTO customers (email, registration_date)
VALUES ('john@pork.nz', '2020-09-01');
*/

-- PART 3

-- Task 3.1:
CREATE TABLE users (
user_id SERIAL PRIMARY KEY,
username VARCHAR UNIQUE,
email VARCHAR UNIQUE,
created_at TIMESTAMP);

-- Task 3.2:
CREATE TABLE course_enrollments (
enrollment_id SERIAL PRIMARY KEY,
student_id INT,
course_code VARCHAR,
semester VARCHAR,
CONSTRAINT unique_enrollment UNIQUE (student_id, course_code, semester)
);

-- Task 3.3:
-- 1,2
ALTER TABLE users
ADD CONSTRAINT unique_username UNIQUE (username),
ADD CONSTRAINT unique_email UNIQUE (email);

-- 3
/*
INSERT INTO users (username, email)
VALUES ('Sal', 's@al.com');

INSERT INTO users (username, email)
VALUES ('Sal', 's@al.com');
*/

-- PART 4

-- Task 4.1:
CREATE TABLE departments (
dept_id SERIAL PRIMARY KEY,
dept_name VARCHAR NOT NULL,
location VARCHAR);

/*
INSERT INTO departments (dept_name, location)
VALUES 
('Health & safety', '2nd Block 1st floor'),
('Accounting', '1st Block under the staircase'),
('HR', '1st Block room 14');

-- 1
INSERT INTO departments (dept_id, dept_name)
VALUES (2, 'R&D');

--2
INSERT INTO departments (dept_id, dept_name)
VALUES (NULL, 'R&D');
*/

-- Task 4.2:
CREATE TABLE student_courses(
student_id INT,
course_id INT,
enrollment_date DATE,
grade VARCHAR,
PRIMARY KEY (student_id, course_id)
);

-- Task 4.3:
/*
1)Unique columns cant have duplicate values, can have NULL values unless manually set otherwise
and you can have multiple unique constraints in one table, either single column or composite.
Primary key is similar in the way that it cant have duplicate values, but it also can never be NULL
and you can only have a single primary key constraint in the table.

2)Use composite primary key when the uniqueness of the row only checks out by having multiple columns connected,
like in the Task 3.2 where it only made sense for a specific student to be in a specific semester in a specific course_code, 
not otherwise, since none of the columns are unique in the way that matters.

Use singular when each row in the table can have a unique identifier, i.e. when creating a table with a list of students,
that all have their own ID.

3)Primary key declares identity, its there to uniquely define a row. Unique key on the other hand is just a constraint
for other columns or column groups that need to be unique by demand. It would be inconvenient to have only one of those 
constraints and not the other
*/

-- PART 5

-- Task 5.1:
CREATE TABLE employees_dept (
emp_id SERIAL PRIMARY KEY,
emp_name VARCHAR NOT NULL,
dept_id INT,
hire_date DATE,
FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
);

/*
-- 1
INSERT INTO employees_dept (emp_name, dept_id, hire_date)
VALUES ('Kaan', 2, '2021-06-01');

-- 2
INSERT INTO employees_dept (emp_name, dept_id, hire_date)
VALUES ('Ghislaine', 10, '2009-09-30');
*/

-- Task 5.2:
CREATE TABLE authors (
author_id SERIAL PRIMARY KEY,
author_name VARCHAR NOT NULL,
country VARCHAR);

CREATE TABLE publishers (
publisher_id SERIAL PRIMARY KEY,
publisher_name VARCHAR NOT NULL,
city VARCHAR);

CREATE TABLE books (
book_id SERIAL PRIMARY KEY,
title VARCHAR NOT NULL,
author_id INT,
publisher_id INT,
publication_year INT,
isbn VARCHAR UNIQUE,
FOREIGN KEY (author_id) REFERENCES authors (author_id),
FOREIGN KEY (publisher_id) REFERENCES publishers (publisher_id)
);

/*
INSERT INTO authors (author_name, country)
VALUES 
('Ryogo Narita', 'Japan'),
('Arthur Doyle', 'Great Britain');

INSERT INTO publishers (publisher_name, city)
VALUES 
('Jump', 'Chiyoda'),
('Penguin', 'Birmingham');

INSERT INTO books (title, author_id, publisher_id, publication_year, isbn)
VALUES 
('DRRR!!', 1, 1, 2009, '523757328'),
('A study in Scarlet', 2, 2, 1879, '12958');
*/

-- Task 5.3:
CREATE TABLE categories (
category_id SERIAL PRIMARY KEY,
category_name VARCHAR NOT NULL);

CREATE TABLE products_fk (
product_id SERIAL PRIMARY KEY,
product_name VARCHAR NOT NULL,
category_id INT,
FOREIGN KEY (category_id) REFERENCES categories (category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
order_id SERIAL PRIMARY KEY,
order_date DATE NOT NULL);

CREATE TABLE order_items (
item_id SERIAL PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT CHECK (quantity > 0),
FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE,
FOREIGN KEY (product_id) REFERENCES products_fk (product_id)
);

/*
INSERT INTO categories (category_name)
VALUES ('Outside'), ('Inside');

INSERT INTO products_fk (product_name, category_id)
VALUES ('Lawnmower', 1), ('Plant pot', 2);

INSERT INTO orders (order_date)
VALUES ('2025-09-28'),('2025-10-01');

INSERT INTO order_items (order_id, product_id, quantity)
VALUES 
(1, 1, 3), (2, 2, 1);

/*
-- 1 Failed with RESTRICT successfully
DELETE FROM categories WHERE category_id = 1;

-- 2 First I check the state of the order_items table, then delete from ordersm then check again
SELECT * FROM order_items;
DELETE FROM orders WHERE order_id = 1;
SELECT * FROM order_items;


-- 3 -> When I tried to run a delete from command it didnt let me delete because of RESTRICT. When I deleted an order from orders, the corresponding row in order_items got deleted too automatically

*/

-- PART 6

-- Task 6.1:
CREATE TABLE customers (
customer_id SERIAL PRIMARY KEY,
name VARCHAR NOT NULL,
email VARCHAR UNIQUE,
phone VARCHAR,
registration_date DATE NOT NULL);

CREATE TABLE products (
product_id SERIAL PRIMARY KEY,
name VARCHAR NOT NULL,
description VARCHAR,
price INT NOT NULL CHECK (price >= 0),
stock_quantity INT CHECK (price >= 0)
);

CREATE TABLE orders (
order_id SERIAL PRIMARY KEY,
customer_id INT NOT NULL,
order_date DATE NOT NULL,
total_amount INT,
status VARCHAR,
FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON DELETE CASCADE
);

CREATE TABLE order_details (
order_detail_id SERIAL PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT,
unit_price INT,
FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE,
FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
);


/*
INSERT INTO customers (name, email, phone, registration_date)
VALUES 
('Jonah','jon@ah.au', NULL, '2020-02-22'),
('Koko','hekmatyar@hotmail.com', 421415, '2015-11-24'),
('Celty Sturluson', 'clty@kstn.jp', 428379, '2009-10-02'),
('Denis Simonov', 'kenka@yokunaine.ru', 742819, '2011-04-12'),
('Simon', 'simon@mail.ru', 757285, '2011-04-13'); 

INSERT INTO products (name, description, price, stock_quantity)
VALUES 
('Lawnmower', NULL, 10000, 50),
('Bushwacker', 'wacks bushes', 9500, 32),
('Shovel', 'gardening shovel', 2000, 120),
('Plant pot', NULL, 300, 200),
('Chiba seeds', '30 in each pack', 400, 160);

INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES
(1, '2025-10-10', 160000, 'pending'),
(2, '2025-09-10', 214900, 'shipped'),
(3, '2025-09-29', 10000, 'delivered'),
(4, '2025-10-02', 300, 'cancelled'),
(5, '2025-10-12', 120000, 'processing')

INSERT INTO order_details (order_id, product_id, quantity, unit_price)
VALUES 
(1,1,3,100000),
(2,2,1,96005),
(3,3,12,10000),
(4,4,2,25000),
(5,5,100, 300)


-- NOT NULL constraint, gives out an error
INSERT INTO customers (name)
VALUES (NULL);

-- Price non negative constraint, also gives out an error
INSERT INTO products (price)
VALUES (-6);

-- ON DELETE constraint cascades from other tables automatically
DELETE FROM products WHERE product_id = 2;






