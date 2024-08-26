--! Create a sample database and table
CREATE DATABASE sample_db;
\c sample_db;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    position VARCHAR(50),
    salary NUMERIC(10, 2),
    department_id INT
);

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);


--! Insert data into the tables
INSERT INTO employees (name, position, salary, department_id)
VALUES
    ('Alice', 'Developer', 60000, 1),
    ('Bob', 'Designer', 50000, 2),
    ('Charlie', 'Manager', 80000, 1),
    ('David', 'Analyst', 55000, 3),
    ('Eve', 'Developer', 62000, 1);

INSERT INTO departments (department_name)
VALUES
    ('Engineering'),
    ('Design'),
    ('Analytics');



--! Basic CRUD Operations

--! Read all data
SELECT * FROM employees;

--! Read data with condition
SELECT * FROM employees WHERE salary > 55000;

--! Insert new record
INSERT INTO employees (name, position, salary, department_id)
VALUES ('Frank', 'Developer', 64000, 1);

--! Update a record
UPDATE employees SET salary = 70000 WHERE name = 'Bob';

--! Delete a record
DELETE FROM employees WHERE name = 'David';

--! Aggregation Functions

--! SUM of salaries
SELECT SUM(salary) AS total_salary FROM employees;

--! AVG of salaries
SELECT AVG(salary) AS average_salary FROM employees;

--! COUNT of employees
SELECT COUNT(*) AS total_employees FROM employees;

--! GROUP BY with aggregation
SELECT department_id, SUM(salary) AS total_salary_per_department
FROM employees
GROUP BY department_id;



--! Joins

--! INNER JOIN
SELECT employees.name, departments.department_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;

--! LEFT JOIN
SELECT employees.name, departments.department_name
FROM employees
LEFT JOIN departments ON employees.department_id = departments.id;

--! RIGHT JOIN
SELECT employees.name, departments.department_name
FROM employees
RIGHT JOIN departments ON employees.department_id = departments.id;

--! FULL OUTER JOIN
SELECT employees.name, departments.department_name
FROM employees
FULL OUTER JOIN departments ON employees.department_id = departments.id;



--! UNION and INTERSECT

--! UNION: Combine results from two queries
SELECT name FROM employees WHERE salary > 60000
UNION
SELECT name FROM employees WHERE position = 'Developer';

--! INTERSECT: Return common results from two queries
SELECT name FROM employees WHERE salary > 60000
INTERSECT
SELECT name FROM employees WHERE position = 'Developer';



--! Triggers

--! Create a trigger function to log salary changes
CREATE OR REPLACE FUNCTION log_salary_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_changes(employee_id, old_salary, new_salary, change_date)
        VALUES (NEW.id, OLD.salary, NEW.salary, NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--! Create a table to store salary change logs
CREATE TABLE salary_changes (
    id SERIAL PRIMARY KEY,
    employee_id INT,
    old_salary NUMERIC(10, 2),
    new_salary NUMERIC(10, 2),
    change_date TIMESTAMP
);

--! Create a trigger on the employees table
CREATE TRIGGER salary_update_trigger
AFTER UPDATE ON employees
FOR EACH ROW EXECUTE FUNCTION log_salary_changes();



--! View

--! Create a view to simplify complex queries
CREATE VIEW employee_salaries AS
SELECT e.name, e.position, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.id;

--! Use the view
SELECT * FROM employee_salaries;

--! Drop the view if no longer needed
DROP VIEW employee_salaries;


--! Drop the trigger and function if no longer needed
DROP TRIGGER salary_update_trigger ON employees;
DROP FUNCTION log_salary_changes();


--! Drop tables and database if no longer needed
DROP TABLE salary_changes;
DROP TABLE employees;
DROP TABLE departments;
DROP DATABASE sample_db;