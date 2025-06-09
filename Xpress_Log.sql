/* 
An Employee Payroll System for XpressLogistic Ltd
It is designed to manage and automate the 
financial records for the employees of the company; 
and equally manage salaries, taxes, deductins
bonuses and other payroll-related activities efficiently.
*/

--CHUNK ONE
/*
Step 1: Build "employees table". The structure of this table
describes its columns for managing employee information in the 
payroll system.
*/

CREATE TABLE
	employees (
		employee_id INT PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1),
		employee_name VARCHAR(255) NOT NULL,
		department VARCHAR(100),
		position VARCHAR(50),
		hire_date DATE,
		base_salary DECIMAL(10,2) NOT NULL
		);

--STEP 2: Populate "employees table"

INSERT INTO
	employees (employee_name, department, position, hire_date, base_salary)
		VALUES
			('Pete Cole', 'Finance', 'Asst Manager', '04-04-2023', 6000.00),
			('Jon Fil', 'HR', 'Senior Manager', '01-04-2023', 10000.00),
			('Boupa Di', 'Research', 'Manager', '06-05-2023', 8000.00),
			('Mohd Sal', 'ICT', 'Senior Manager', '02-04-2023', 10000.00),
			('Ria Marez', 'Legal', 'Manager', '02-04-2023', 8000.00);

--CHUNK TWO: Attendance Table

--Step 1A: Create the 'ENUM' data type

create type stat as enum (
  'Present',
  'Absent',
  'Leave'
 	);

/*
Step 1B: Build "attendance table". This structure of this table
presents the columns for tracking employee attendance 
in the payroll system.
*/

CREATE TABLE
	attendance (
		attendance_id INT PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1),
		employee_id INT,
		attendance_date DATE,
		status STAT,
		FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
			);

--CHUNK THREE
--Step 1: Populate the attendance table

INSERT INTO 
	attendance (employee_id, attendance_date, status)
		VALUES 
			('1', '04-04-2024', 'Present'),
			('2', '01-04-2024', 'Present'),
			('3', '06-05-2024', 'Absent'),
			('4', '02-04-2024', 'Leave'),
			('5', '02-04-2024', 'Present');

--CHUNK FOUR
/*
Step 1: Build "salaries" table. This table stores employees' salary details
including base salary, bonuses, deductions, the specific month and year
for the salary record
*/

CREATE TABLE
	salaries (
		salary_id INT PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 100 ),
		employee_id INT,
		base_salary DECIMAL(10,2) NOT NULL,
		bonus DECIMAL(10,2),
		deductions DECIMAL(10,2),
		month VARCHAR(15),
		year INT,
		FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
			);

--STEP 2: Populate the "salaries" table
INSERT INTO
	salaries (employee_id, base_salary, bonus, deductions, month, year)
		VALUES 
			('1', '6000', '200', '50', 'April', '2023'),
	  		('2', '10000', '500', '200', 'April', '2023'),
	  		('3', '8000', '300', '100', 'May', '2023'),
	  		('4', '10000', '500', '200', 'April', '2023'),
	  		('5', '8000', '300', '100', 'April', '2023');

--Chunk 5
/*
Step 1: Build the Payroll Table. This table stores
each employee's record, including the total salary paid and date.
*/

CREATE TABLE
	payroll
		(payroll_id INT PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 2 START 1 ),
		employee_id INT,
		total_salary DECIMAL(10,2),
		payment_date DATE,
		FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
		);

--Performing basic functionalities

--Chunk Six: Adding a new employee to the payroll

INSERT INTO 
	employees (employee_name, department, position, hire_date, base_salary)
		VALUES
			('Jane Gomez', 'Corporate Affairs', 'Manager', '06-05-2023', '8000');

--Chunk Seven: Update Pete Cole's salary

UPDATE 
	employees
SET 
	base_salary = '6500'
WHERE 
	employee_id = '1';
	
--Chunk Eight: Track Attendance

INSERT INTO 
	attendance (employee_id, attendance_date, status)
		VALUES
			('3', '12-02-2024', 'Absent');

--Chunk Nine: Calculate Employee's Salary for January 2024

SELECT 
	(base_salary + bonus) - deductions AS "total_salary"
FROM
	salaries
WHERE employee_id = '2' AND month = 'April' AND year = '2023';	

--Chunk Ten: Update Payroll Table
INSERT INTO 
	payroll (employee_id, total_salary, payment_date)
		VALUES
			('2', '10300', '04-20-2023');

--Chunk Eleven: Generate Payslip for Employee_id 2

SELECT 
	e.employee_id,
	e.employee_name,
	s.base_salary,
	s.bonus,
	s.deductions,
	s.month,
	p.total_salary
FROM 
	employees AS e
INNER JOIN
	salaries AS s
ON 
	e.employee_id = s.employee_id
INNER JOIN
	payroll AS p
ON 
	e.employee_id = p.employee_id
WHERE
	e.employee_id = 2 AND s.month = 'April' AND s.YEAR = 2023;

-Chunk Twelve: Generate Report (Payroll Summary for Sept 2023)

SELECT
	e.employee_id,
	e.employee_name,
	p.total_salary,
	p.payment_date
FROM 
	employees AS e
INNER JOIN
	payroll AS p
ON 
	e.employee_id = p.employee_id
WHERE
	p.payment_date BETWEEN '04-01-2023' AND '04-27-2023';

