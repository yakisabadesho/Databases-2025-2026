-- PART 1

-- Step 1.1
CREATE TABLE employees(
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2)
)

CREATE TABLE departments(
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE projects(
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    budget DECIMAL(10,2),
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

-- Step 1.2
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');

INSERT INTO projects (project_id, project_name, dept_id,
budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);

-- PART 2

-- 2.1
SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;
-- 20 rows, 5 employees X 4 departments

--2.2
--a)
SELECT e.emp_name, d.dept_name
FROM employees e, departments d;
--b)
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON true;

--2.3
SELECT e.emp_name, p.project_name
FROM employees e, projects p;

-- PART 3

--3.1
SELECT e.emp_name, d.dept_name, d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
--4 rows returned, Tom Brown isn't included because he isn't attached to any department

--3.2
SELECT emp_name, dept_name, location
FROM employees
INNER JOIN departments USING (dept_id);
--No difference in output columns compared to the ON version

--3.3
SELECT emp_name, dept_name, location
FROM employees
NATURAL INNER JOIN departments;

--3.4
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id;

--PART 4
--4.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
--Tom Brown appears to not have any department data, having all the department-related columns as <null>

--4.2
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d USING(dept_id);

--4.3
SELECT e.emp_name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

--4.4
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;

--PART 5

--5.1
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

--5.2
SELECT e.emp_name, d.dept_name
FROM departments d
LEFT JOIN employees e ON e.dept_id = d.dept_id;

--5.3
SELECT d.dept_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;

--PART 6

--6.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id;
--There's an employee without a department - Tom Brown, so he has NULL values on the right side
--On the other hand, there's a department without any employees - Marketing. 

--6.2
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p ON d.dept_id = p.dept_id;

--6.3
SELECT
CASE
WHEN e.emp_id IS NULL THEN 'Department without
employees'
WHEN d.dept_id IS NULL THEN 'Employee without
department'
ELSE 'Matched'
END AS record_status,
e.emp_name,
d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;

--PART 7

--7.1
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id AND
d.location = 'Building A';

--7.2
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
--In Query 1 it joins after the filter, but in Query 2 it joins before the filter. This way, in Query 1 it shows all of the employees, regardless of their department being in the Building A or not.

--7.3
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id AND
d.location = 'Building A';

SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
--There's a difference between those queries, namely between query 1 and the inner join version. It doesnt show the employees not in building A, not even as having NULL values.

--PART 8

--8.1
SELECT
d.dept_name,
e.emp_name,
e.salary,
p.project_name,
p.budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

--8.2
ALTER TABLE employees ADD COLUMN manager_id INT;

-Change data
UPDATE employees SET manager_id = 3 WHERE emp_id = 1;
UPDATE employees SET manager_id = 3 WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3 WHERE emp_id = 4;
UPDATE employees SET manager_id = 3 WHERE emp_id = 5;

--Self join
SELECT
e.emp_name AS employee,
m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

--8.3
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;


/*
1.Inner join selects only the rows that belong to both tables, whereas left join selects the entire left table together with the part that relates to the right table. 
I.e. if you have a customer shopping log, using left join you would see the customers who made purchases and the respective purchases along with customers who haven't made any purchases yet,
where if you use inner join it would only show you the customers who made purchases instead showing the purchase-less customers having NULL as purchases.

2.Let's say you have a bunch of employees who want to exchange shifts with each other, but manually determining when any single employee can take another one's shift is a pain in the neck,
therefore you use a cross join on all of the employees and all of the shifts available, so that you have a list of all the possible combinations of workers and shifts on your hand to
explore various staffing options

3.ON affects whether or not rows are joined, WHERE affects whether or not joined rows appear in the result.
Theres no functional difference for an inner join, but for left join, ON would prevent rows from being joined in the first place, resulting in nulls, and a WHERE would eliminate an entire row from results

4.50 rows, each row linked to another row.

5.It matches columns with the same names

6.Incorrect data retrieval, since its based on names and nothing else.

7.SELECT * FROM B RIGHT JOIN A ON B.id = A.id

8.You should use it for database "debugging". Just to see whats up with the tables, what if there are tables that have any rows that are not in other related tables, or what if there are duplicates in different tables etc.
*/


