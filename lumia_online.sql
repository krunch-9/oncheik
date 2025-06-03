/* 
The Online Store Database Project is designed to 
streamline and manage e-commerce operations efficiently.
This database system focused on maintaining key entities like products,
customers, orders, payments, and inventory, ensuring seamless business
operations for an online business, "Lumia".
The system enables the tracking of product information, customer
details, order processing, payment tracking, and inventory
management. By implementing this project, tasks like adding 
new products, managing customer orders, processing payments, and monitoring
inventory levels efficiently can be handled by the business.
*/

--CHUNK ONE
/* 
Step 1: Build "products table". The table frame
stores info related to products available in the store, cutting across
product ID, name, description, price and category, aiding to manage
the product catalog effectively.
*/

CREATE 
	TABLE products (
		product_id SERIAL NOT NULL PRIMARY KEY,
		name VARCHAR(25) NOT NULL,
		description TEXT,
		price DECIMAL(10, 2) NOT NULL,
		category VARCHAR(50)
			);

--Populate Products Table:

INSERT INTO
	products (name, description, price, category) 
		VALUES
			('Phone', 'Black 128GB', '1200', 'Electronic'),
			('TV', 'Art Mode Smart AI TV 55 inch', '250', 'Electronic'),
			('Bed', 'Double Ottoman Frame', '500', 'Furniture'),
			('Dining', 'Stockholm Extending Dining', '1695', 'Furniture'),
			('Book', 'Biography', '5', 'Stationary');

--CHUNK TWO
/*
Step 1: Build "customers table". This table stores
essential info for managing clients' transactions and 
interactions within the business.
*/

CREATE TABLE
	customers
		(customer_id SERIAL NOT NULL PRIMARY KEY,
		 name VARCHAR(25) NOT NULL,
		 email VARCHAR(25) UNIQUE NOT NULL,
		 phone_no VARCHAR(15),
		 address VARCHAR(55)
		);
		
--Populate Customers Table:
INSERT INTO 
	customers (name, email, phone_no, address)
		VALUES
			('Marie Kay', 'marykay@abc.com', '4411223344', '12 First Street'),
			('Jack Kurt', 'jackurt@cde.com', '1421314243', '13 Second Street'),
			('Jon Phil', 'jonphil@efg.net', '1403234893', '14 Third Street'),
			('Abram Zoe', 'abramz@ghi.com', '7323555660', '15 Fourth Street');


--CHUNK THREE
/* 
Step 1: Build "orders table". This table records 
customer orders, tracking ID,
customer ID order date and status 
(such as 'Pending', 'Completed', or 'Cancelled').
*/

CREATE type ords AS ENUM (
	'Pending',
	'Completed',
	'Cancelled'
	);

CREATE TABLE
	orders
		(order_id SERIAL NOT NULL PRIMARY KEY,
		 customer_id INT NOT NULL,
		 order_date DATE NOT NULL,
		 status ORDS,
		 FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
		 );

--Populate Orders Table:
INSERT INTO 
	orders (customer_id, order_date, status)
		VALUES
			('1', '2025-04-28', 'Completed'),
			('2', '2025-04-19', 'Pending'),
			('3', '2025-04-12', 'Completed'),
			('4', '2025-04-7', 'Cancelled');
INSERT INTO
	orders (customer_id, order_date, status)
		VALUES
			('1', '2025-04-29', 'Completed');

--CHUNK FOUR
/* 
Step 1: Build "payments table". This table stores 
payment records associated with customer orders.
*/

CREATE type stats AS ENUM (
	'Paid',
	'Overdue',
	'Refunded'
	);
CREATE TABLE 
	payments (
		payment_id SERIAL NOT NULL PRIMARY KEY,
		order_id INT,
		payment_date DATE,
		amount DECIMAL(10, 2),
		payment_status STATS,
		FOREIGN KEY (order_id) REFERENCES orders(order_id)
		);

--Populate Payments Table:

INSERT INTO
	payments (order_id, payment_date, amount, payment_status)
		VALUES
			('1', '2025-04-28', '1200', 'Paid'),
			('2', '2025-04-19', '250', 'Overdue'),
			('3', '2025-04-12', '500', 'Paid'),
			('4', '2025-04-07', '5', 'Refunded');

--CHUNK FIVE
/* 
Step 1: Build "inventory table". It tracks the stock levels of
of products in the system.
*/

CREATE TABLE
	inventory
		(inventory_id SERIAL NOT NULL PRIMARY KEY,
			product_id INT,
			stock_quantity INT DEFAULT 0,
			last_updated DATE DEFAULT (CURRENT_DATE),
			FOREIGN KEY (product_id) REFERENCES products(product_id)
				);

--Populate Inventory Table

INSERT INTO 
	inventory (product_id, stock_quantity, last_updated)
		VALUES 
			(1, 15, '2025-04-27'),
			(2, 20, '2025-04-18'),
			(3, 8, '2025-04-11'),
			(4, 10, '2025-04-06'),
			(5, 30, '2025-04-03');


--Basic Functionalities

--Q1: View all products

SELECT
	*
FROM
	products;

--Q2: Check product availability

SELECT 
	p.name,
	i.stock_quantity
FROM 
	products AS p
INNER JOIN
	inventory AS i
ON
	p.product_id=i.product_id;

--Q3: Obtain customer details
SELECT 
	*
FROM 
	customers
WHERE 
	customer_id = '4';

--Q4: Orders with Payment Status
SELECT 
	o.order_id,
	o.order_date,
	p.payment_status
FROM
	orders AS o
JOIN 
	payments AS p
ON o.order_id = p.order_id
WHERE 
	payment_status = 'Overdue';

--Q5: Total Sales per Product
SELECT 
	p.name,
	SUM(pay.amount) AS "Total Sales"
FROM 
	products AS p
JOIN
	orders AS o
ON 
	p.product_id = o.order_id
JOIN
	payments AS pay
ON
	o.order_id = pay.order_id
GROUP BY
	p.product_id;

SELECT * FROM products;

--Q6: Orders Completed within April

SELECT 
	* 
FROM
	orders
WHERE
	status = 'Completed'
AND
	order_date BETWEEN '2025-04-01' AND '2025-04-30';

--Q7: Inventory Re-Stocking

SELECT 
	p.name,
	i.stock_quantity
FROM
	products AS p
JOIN
	inventory AS i
ON
	p.product_id = i.product_id
WHERE
	stock_quantity < 10;

--Q8: Identify Customers with Multiple Orders

SELECT
	c.name,
	COUNT(o.order_id) AS "Order Count"
FROM
	customers AS c
JOIN
	orders AS o
ON
	c.customer_id = o.customer_id
GROUP BY
	c.customer_id
;

--Q9: Identify Highest Paying Customer

SELECT 
	c.name,
	p.amount
FROM 
	customers AS c
JOIN
	orders AS o
ON 
	c.customer_id = o.order_id
JOIN
	payments AS p
ON
	o.order_id = p.order_id
ORDER BY
	p.amount DESC
LIMIT 1;

