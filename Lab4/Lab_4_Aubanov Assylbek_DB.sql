--PART 1:

--Task 1.1:
SELECT first_name || ' ' || last_name AS full_name, department, salary FROM employees;;

--Task 1.2:
SELECT DISTINCT department FROM employees;

--Task 1.3:
SELECT project_name, budget,
CASE
WHEN budget > 150000 THEN 'large'
WHEN budget < 150000 AND budget > 100000 THEN 'medium'
ELSE 'small'
END AS budget_category
FROM projects;

--Task 1.4:
SELECT first_name || ' ' || last_name AS full_name, COALESCE (email, 'No email provided') FROM employees;


--PART 2:

--Task 2.1:
SELECT employee_id, first_name || ' ' || last_name AS name FROM employees WHERE hire_date > '2020-01-01';

--Task 2.2:
SELECT employee_id, first_name || ' ' || last_name AS name, salary FROM employees WHERE salary BETWEEN 60000 AND 70000;

--Task 2.3:
SELECT employee_id, first_name || ' ' || last_name AS name FROM employees WHERE first_name LIKE 'S%' OR last_name LIKE 'J%';

--Task 2.4:
SELECT employee_id, first_name || ' ' || last_name AS name FROM employees WHERE manager_id IS NOT NULL AND department = 'IT';


--PART 3:

--Task 3.1:
SELECT UPPER(first_name || ' ' || last_name) AS name, LENGTH(last_name) AS name_length, SUBSTRING(email, 0, 4) FROM employees;

--Task 3.2:
SELECT employee_id, first_name || ' ' || last_name AS employee_name, salary * 12 AS annual_salary, salary AS monthly_salary, salary + (salary * 0.1) AS with_raise FROM employees;

--Task 3.3:
SELECT FORMAT('Project: %s - Budget: $%s - Status: %s', project_name, budget, status) FROM projects;

--Task 3.4:
SELECT first_name || ' ' || last_name AS employee, (CURRENT_DATE - hire_date)/365 AS years_employed FROM employees;


--PART 4:

--Task 4.1:
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department;

--Task 4.2:
SELECT project_name,
CASE
WHEN end_date IS NULL THEN (CURRENT_DATE - start_date)*24
ELSE (end_date - start_date)*24
END AS hours_worked
FROM projects;

--Task 4.3:
SELECT department, count(employee_id) AS employee_amount FROM employees GROUP BY department HAVING COUNT(employee_id)>1;

--Task 4.4:
SELECT MAX(salary) AS max_salary, MIN(salary) AS min_salary, SUM(salary) FROM employees;


--PART 5:

--Task 5.1:
SELECT employee_id, first_name || ' ' || last_name AS employee, salary FROM employees WHERE salary > 65000 
UNION
SELECT employee_id, first_name || ' ' || last_name AS employee, salary FROM employees WHERE hire_date > '2020_01_01';

--Task 5.2:
SELECT employee_id, first_name || ' ' || last_name AS employee_name, department, salary FROM employees WHERE salary > 65000
INTERSECT
SELECT employee_id, first_name || ' ' || last_name AS employee_name, department, salary FROM employees WHERE department = 'IT';

--Task 5.3:
SELECT employee_id FROM assignments
EXCEPT
SELECT employee_id FROM assignments WHERE project_id = 1 OR project_id = 2 OR project_id = 3 OR project_id = 4;


--PART 6:

--Task 6.1:
SELECT employee_id FROM assignments WHERE EXISTS(SELECT project_id);  

--Task 6.2:
SELECT employee_id FROM assignments WHERE EXISTS((SELECT project_id FROM projects WHERE status IN ('Active')));

--Task 6.3:
SELECT employee_id FROM employees WHERE salary = ANY(SELECT salary FROM employees WHERE department = 'IT');


--PART 7:

--Task 7.1:
SELECT e.first_name || ' ' || e.last_name AS employee_name, e.department, e.salary,
RANK() OVER (PARTITION BY e.department ORDER BY e.salary DESC) AS salary_rank,
AVG(a.hours_worked) AS average_hours_worked
FROM employees e
LEFT JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department, e.salary
ORDER BY e.department, salary_rank;

--Task 7.2:
SELECT 
    p.project_id, 
    p.project_name, 
    (p.end_date - p.start_date) AS project_duration,
    COUNT(a.employee_id) AS employee_count
FROM projects p
LEFT JOIN assignments a 
    ON p.project_id = a.project_id
WHERE (p.end_date - p.start_date) > 150
GROUP BY p.project_id, p.project_name, project_duration;


--Task 7.3:
SELECT e.employee_id,
       e.department,
       e.salary,
       stats.employee_count,
       stats.average_salary
FROM employees e
JOIN (
    SELECT department,
           COUNT(*) AS employee_count,
           AVG(salary) AS average_salary,
           MAX(salary) AS max_salary
    FROM employees
    GROUP BY department
) stats
  ON e.department = stats.department
 AND e.salary = stats.max_salary;