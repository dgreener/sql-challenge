-- Drop tables if they exist

drop table if exists employees;
drop table if exists salaries;
drop table if exists dept_manager;
drop table if exists dept_emp;
drop table if exists departments;
drop table if exists titles;

--Create employees table
CREATE TABLE employees (
    emp_no INT   NOT NULL,
    emp_title_id VARCHAR(50)   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR(50)   NOT NULL,
    last_name VARCHAR(50)   NOT NULL,
    sex VARCHAR(5)   NOT NULL,
    hire_date DATE   NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (emp_no)
);

--Create salaries table
CREATE TABLE salaries (
    emp_no INT   NOT NULL,
    salary INT   NOT NULL,
    CONSTRAINT pk_salaries PRIMARY KEY (emp_no)
);

--Create department manager table
CREATE TABLE dept_manager (
    dept_no VARCHAR(50)   NOT NULL,
    emp_no INT   NOT NULL,
    CONSTRAINT pk_dept_manager PRIMARY KEY (dept_no,emp_no)
);

--Create department employee table
CREATE TABLE dept_emp (
    emp_no INT   NOT NULL,
	dept_no VARCHAR(50)   NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (dept_no,emp_no)
);

--Create department table
CREATE TABLE departments (
    dept_no VARCHAR(50)   NOT NULL,
    dept_name VARCHAR(50)   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (dept_no)
);

--Create titles table
CREATE TABLE titles (
    title_id VARCHAR(50)   NOT NULL,
    title VARCHAR(50)   NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (title_id)
);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE departments ADD CONSTRAINT fk_departments_dept_no FOREIGN KEY(dept_no)
REFERENCES dept_emp (dept_no);

ALTER TABLE titles ADD CONSTRAINT fk_titles_title_id FOREIGN KEY(title_id)
REFERENCES employees (emp_title_id);

SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM dept_manager;
SELECT * FROM dept_emp;
SELECT * FROM departments;
SELECT * FROM titles;

--1) Employee number, last name, first name, sex, and salary of each employee

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

--2) First name, last name, and hire date for the employees who were hired in 1986
SELECT last_name, first_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986-1-1' and '1986-12-31'
ORDER BY hire_date ASC;

--3) Manager of each department along with their department number, department name, employee number, last name, and first name

SELECT dept_manager.dept_no, dept_manager.emp_no, departments.dept_name, employees.last_name, employees.first_name
FROM dept_manager
JOIN employees
ON dept_manager.emp_no = employees.emp_no
JOIN departments
ON dept_manager.dept_no = departments.dept_no
ORDER BY departments.dept_name ASC;

--4) Department number for each employee along with that employee’s employee number, last name, first name, and department name
SELECT dept_emp.dept_no, dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
ORDER BY departments.dept_name ASC;

--5) First name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B 
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
ORDER BY last_name ASC;

--6) List each employee in the Sales department, including their employee number, last name, and first name

SELECT departments.dept_name, departments.dept_no, dept_emp.emp_no, employees.last_name, employees.first_name
FROM employees
JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
JOIN departments
ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name = 'Sales'
ORDER BY employees.last_name ASC;

--7) List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
JOIN departments
ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name = 'Sales' OR departments.dept_name = 'Development'
ORDER BY employees.last_name ASC;

--8) List the frequency counts, in descending order, of all last names
SELECT employees.last_name, COUNT(employees.emp_no) AS number_unique_employees_with_same_last_name
FROM employees
GROUP By employees.last_name
ORDER BY number_unique_employees_with_same_last_name DESC;