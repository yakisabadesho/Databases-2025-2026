-- PART 1
-- Done

--PART 2
--2.1
CREATE INDEX emp_salary_idx ON employees(salary);

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees';
-- 2 Indexes exist as of right now, employees_pkey and emp_salary_idx

--2.2
CREATE INDEX emp_dept_idx ON employees(dept_id);

SELECT * FROM employees WHERE dept_id = 101;

--Querying with joins from other tables becomes much faster with indexing

--2.3
SELECT
tablename,
indexname,
indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- The indexes created automatically are primary keys, like departments_pkey

--PART 3
--3.1
CREATE INDEX emp_dept_salary_idx ON employees(dept_id, salary);

SELECT emp_name, salary
FROM employees
WHERE dept_id = 101 AND salary > 52000;

--It won't be very useful since multicolumn indexes work best when there are constraints on the leading (leftmost) columns, which salary isn't.
--It would be useful if we queried only dept_id though

--3.2
CREATE INDEX emp_salary_dept_idx ON employees(salary, dept_id);

SELECT * FROM employees WHERE dept_id = 102 AND salary > 50000;

SELECT * FROM employees WHERE salary > 50000 AND dept_id = 102;

--The order does matter. To put it simply, the query will deliver faster when querying with the order of the MC index, rather than the other way around OR using the rightmost index.

-- PART 4
--4.1
ALTER TABLE employees ADD COLUMN email VARCHAR(100);
UPDATE employees SET email = 'john.smith@company.com' WHERE emp_id = 1;
UPDATE employees SET email = 'jane.doe@company.com' WHERE emp_id = 2;
UPDATE employees SET email = 'mike.johnson@company.com' WHERE emp_id = 3;
UPDATE employees SET email = 'sarah.williams@company.com' WHERE emp_id = 4;
UPDATE employees SET email = 'tom.brown@company.com' WHERE emp_id = 5;

CREATE UNIQUE INDEX emp_email_unique_idx ON employees(email);

/*
INSERT INTO employees (emp_id, emp_name, dept_id, salary, email)
VALUES (6, 'New Employee', 101, 55000, 'john.smith@company.com');

[23505] ERROR: duplicate key value violates unique constraint "employees_pkey"
  Detail: Key (emp_id)=(6) already exists.
*/

--4.2
ALTER TABLE employees ADD COLUMN phone VARCHAR(20) UNIQUE;

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees' AND indexname LIKE '%phone%';

-- It created a unique btree index

--PART 5
--5.1
CREATE INDEX emp_salary_desc_idx ON employees(salary DESC);

SELECT emp_name, salary
FROM employees
ORDER BY salary DESC;

--It improves query performance by scanning the index in the way of the order by

--5.2
CREATE INDEX proj_budget_nulls_first_idx ON projects(budget NULLS FIRST);

SELECT project_name, budget
FROM projects
ORDER BY budget NULLS FIRST;

--PART 6
--6.1
CREATE INDEX emp_name_lower_idx ON employees(LOWER(emp_name));

SELECT * FROM employees WHERE LOWER(emp_name) = 'john smith';

--It would manually lower every row

--6.2
ALTER TABLE employees ADD COLUMN hire_date DATE;
UPDATE employees SET hire_date = '2020-01-15' WHERE emp_id = 1;
UPDATE employees SET hire_date = '2019-06-20' WHERE emp_id = 2;
UPDATE employees SET hire_date = '2021-03-10' WHERE emp_id = 3;
UPDATE employees SET hire_date = '2020-11-05' WHERE emp_id = 4;
UPDATE employees SET hire_date = '2018-08-25' WHERE emp_id = 5;

CREATE INDEX emp_hire_year_idx ON employees(EXTRACT(YEAR FROM hire_date));

SELECT emp_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2020;

--PART 7
--7.1
ALTER INDEX emp_salary_idx RENAME TO employees_salary_index;

SELECT indexname FROM pg_indexes WHERE tablename = 'employees';

--7.2
DROP INDEX emp_salary_dept_idx;
--You might wanna drop when it's redundant. Creating a lot of indexes also creates a big overhead on the data


--7.3
REINDEX INDEX employees_salary_index;

--PART 8
--8.1
SELECT e.emp_name, e.salary, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 50000
ORDER BY e.salary DESC;

CREATE INDEX emp_salary_filter_idx ON employees(salary) WHERE salary > 50000;

--8.2
CREATE INDEX proj_high_budget_idx ON projects(budget)
WHERE budget > 80000;

SELECT project_name, budget
FROM projects
WHERE budget > 80000;

--It's more compact and optimised for really specific use, so it adds less overhead and improves performance when querying for only high budget projects a lot by only scanning the needed range

--8.3
EXPLAIN SELECT * FROM employees WHERE salary > 52000;

-- It shows Seq Scan. It means that it scans the entire table as stored on disk

--PART 9
--9.1
CREATE INDEX dept_name_hash_idx ON departments USING HASH (dept_name);

SELECT * FROM departments WHERE dept_name = 'IT';

--When theres a lot of lookup and not much inserting 

--9.2
CREATE INDEX proj_name_btree_idx ON projects(project_name);

CREATE INDEX proj_name_hash_idx ON projects USING HASH (project_name);

SELECT * FROM projects WHERE project_name = 'Website Redesign';

SELECT * FROM projects WHERE project_name > 'Database';

--PART 10
--10.1
SELECT
schemaname,
tablename,
indexname,
pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

--dept_name_hash_idx and proj_name_has_idx are the largest, since they are HASH indexes and store 32kb hash values

--10.2
DROP INDEX IF EXISTS proj_name_hash_idx;

--10.3
CREATE VIEW index_documentation AS
SELECT
tablename,
indexname,
indexdef,
'Improves salary-based queries' as purpose
FROM pg_indexes
WHERE schemaname = 'public'
AND indexname LIKE '%salary%';
SELECT * FROM index_documentation;

/*
Summary questions:
1)Default index type is B-tree
2)Improve lookup of high-salary employees with partial indexing, index the foreign keys to join two tables with employees and departments, improve case-insensitive string lookup
3)When it's not needed - i.e. when the amount of rows is small and expected to stay this way. Also when you insert way more than you look up stuff 
4)It removes, updates or inserts the indexes according to the action
5)Use a command like 
SELECT indexname, indexdef
FROM pg_indexes;

*/


















