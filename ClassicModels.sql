use classicmodels;

select * from customers;

select * from employees;

select * from offices;

select * from orderdetails;

select * from orders;

select * from payments;

select * from productlines;

select * from products;

-- Part 1: Basic Exploration

-- 1. List all customers from USA

SELECT 
    customerNumber, customerName, city, state, country
FROM
    customers
where country= 'USA';

 -- 2. Show all products where stock is less than 500 units

SELECT 
    productCode, productName, productLine, quantityInStock
FROM
    products
    
where quantityInStock < 500;

-- 3.Find employees working in the Paris office.

SELECT 
    e.employeeNumber,
    e.firstName,
    e.lastName,
    e.jobTitle,
    o.officeCode,
    o.city
FROM
    employees e
 join offices o on e.officeCode=o.officeCode
 where o.city='Paris';
 
 -- 4.Get orders with status = 'Cancelled'.
 
SELECT 
    orderNumber, orderDate, shippedDate, status, comments, customerNumber
FROM
    orders
where status='Cancelled';

 -- 5. List all customers whose credit limit > 100000
 
SELECT 
    customerNumber,
    customerName,
    country,
    salesRepEmployeeNumber,
    creditLimit
FROM
    customers
    
where creditLimit > 100000;

 -- 6.Find customers who have no assigned sales representative.
 
SELECT 
    customerNumber, customerName, country, creditLimit
FROM
    customers

where salesRepEmployeeNumber is null;

-- 7.Show all orders placed in 2004.

SELECT 
    orderNumber, orderDate, status, customerNumber
FROM
    orders
    
where year(orderDate)=2004;

-- Part 2: Joins Practice

-- 1.Show all orders along with the customer name

SELECT 
    o.orderNumber, o.orderDate, c.customerName
FROM
    orders o
join customers c on o.customerNumber=c.customerNumber;

-- 2.Show each customer with their sales representative’s name.

SELECT 
    c.customerName,
    CONCAT(e.firstName, '', e.lastName) AS SalesRep
FROM
    customers c
left join employees e on c.salesRepEmployeeNumber = e.employeeNumber;

-- 3.Find all employees and the office city they work in.

SELECT 
    e.employeeNumber, e.lastName, e.firstName, o.city
FROM
    employees e
join offices o on e.officeCode = o.officeCode;

--  4.Show each order with its ordered products and quantities

SELECT 
    o.orderNumber, p.productName, od.quantityOrdered
FROM
    orders o

join orderdetails od on o.orderNumber = od.orderNumber
join products p on od.productCode = p.productCode
order by o.orderNumber;

-- 5.List all payments with customer name and country.

SELECT 
     p.checkNumber, p.paymentDate, p.amount, c.customerName, c.country
FROM
    payments p

join customers c on  p.customerNumber = c.customerNumber;

-- Part 3: Aggregates & Grouping

-- 1.Count how many customers each country has

SELECT 
    country, COUNT(*) AS customer_count
FROM
    customers
    
group by country
order by customer_count desc;

-- 2.Find the total sales amount for each customer

SELECT 
    c.customerNumber,
    c.customerName,
    SUM(od.quantityOrdered * od.priceEach) AS Total_Sales
FROM
    customers c

join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by c.customerNumber, c.customerName
order by Total_Sales desc;

-- 3.Show the average credit limit per country

SELECT 
    country,
    AVG(creditLimit) AS avg_credit_limit,
    COUNT(*) AS customers_count
FROM
    customers
GROUP BY country
ORDER BY avg_credit_limit DESC;

-- 4.Find the maximum payment amount per customer.

SELECT 
    p.customerNumber,
    c.customerName,
    MAX(p.amount) AS max_payment
FROM
    payments p
JOIN customers c ON p.customerNumber = c.customerNumber
GROUP BY p.customerNumber, c.customerName
ORDER BY max_payment DESC;

-- 5. Count the number of products in each product line.

SELECT productLine,
       COUNT(*) AS product_count
FROM products
GROUP BY productLine
ORDER BY product_count DESC;

--  Part 4: Subqueries & Insights

-- 1.Find customers who made payments greater than the average payment

SELECT 
    p.customerNumber, p.checknumber, c.customerName, p.amount
FROM
    payments p
JOIN customers c ON p.customerNumber = c.customerNumber
WHERE p.amount > (SELECT AVG(amount) FROM payments);

-- 2. List products that have never been ordered.

SELECT 
    p.productCode, p.productName
FROM
    products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE od.productCode IS NULL;

-- 3. Find the employee with the highest number of direct reports




-- Part 5: Stored Procedures

-- 1. Create a procedure to get all orders by a given customer.

DELIMITER $$

DROP PROCEDURE IF EXISTS getOrdersByCustomer $$
CREATE PROCEDURE getOrdersByCustomer(IN in_customerNumber INT)
BEGIN
  SELECT 
    o.orderNumber,
    o.orderDate,
    o.status,
    od.productCode,
    od.quantityOrdered,
    od.priceEach,
    (od.quantityOrdered * od.priceEach) AS lineTotal
FROM
    orders o
  JOIN orderdetails od ON o.orderNumber = od.orderNumber
  WHERE o.customerNumber = in_customerNumber
  ORDER BY o.orderDate DESC, o.orderNumber;
END $$

DELIMITER ;

CALL getOrdersByCustomer(103);

-- 2.Create a procedure to find total sales between two dates

DELIMITER $$

DROP PROCEDURE IF EXISTS totalSalesBetweenDates $$
CREATE PROCEDURE totalSalesBetweenDates(
  IN in_startDate DATE,
  IN in_endDate DATE
)
BEGIN
 SELECT 
    in_startDate AS start_date,
    in_endDate AS end_date,
    COALESCE(SUM(od.quantityOrdered * od.priceEach),
            0) AS total_sales
FROM
    orders o
  JOIN orderdetails od ON o.orderNumber = od.orderNumber
  WHERE o.orderDate BETWEEN in_startDate AND in_endDate;
END $$

DELIMITER ;

CALL totalSalesBetweenDates('2003-01-01', '2003-12-31');

-- 3. Build a procedure that shows the best-selling product line

DELIMITER $$

DROP PROCEDURE IF EXISTS bestSellingProductLines $$
CREATE PROCEDURE bestSellingProductLines(IN in_topN INT)
BEGIN
  SELECT 
    p.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS revenue,
    SUM(od.quantityOrdered) AS units_sold
FROM
    products p
  JOIN orderdetails od ON p.productCode = od.productCode
  GROUP BY p.productLine
  ORDER BY revenue DESC
  LIMIT in_topN;
END $$

DELIMITER ;

CALL bestSellingProductLines(1);  -- top 1 product line
CALL bestSellingProductLines(3);  -- top 3

-- 4.Create a procedure to display all customers handled by an employee

DELIMITER $$

DROP PROCEDURE IF EXISTS customersHandledByEmployee $$
CREATE PROCEDURE customersHandledByEmployee(IN in_employeeNumber INT)
BEGIN
  SELECT 
    c.customerNumber,
    c.customerName,
    c.contactLastName,
    c.contactFirstName,
    c.phone,
    c.city,
    c.country
FROM
    customers c
  WHERE c.salesRepEmployeeNumber = in_employeeNumber
  ORDER BY c.customerName;
END $$

DELIMITER ;

CALL customersHandledByEmployee(1370); 

-- 5.Write a procedure to calculate yearly revenue given an input year.

DELIMITER $$

DROP PROCEDURE IF EXISTS yearlyRevenue $$
CREATE PROCEDURE yearlyRevenue(IN in_year INT)
BEGIN
 SELECT 
    in_year AS year,
    COALESCE(SUM(od.quantityOrdered * od.priceEach),
            0) AS total_revenue
FROM
    orders o
  JOIN orderdetails od ON o.orderNumber = od.orderNumber
  WHERE YEAR(o.orderDate) = in_year;
END $$

DELIMITER ;

CALL yearlyRevenue(2004);




-- Part 6: Advanced Clauses

-- 1.Find customers who placed more than 5 orders

SELECT 
    c.customerNumber,
    c.customerName,
    COUNT(o.orderNumber) AS Orders_Count
FROM
    customers c

join orders o on c.customerNumber = o.customerNumber
group by c.customerNumber, c.customerName
having count(o.orderNumber) > 5;

-- 2.Find the top 10 most ordered products.

SELECT 
    od.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS Total_qty
FROM
    orderdetails od
    
join products p on od.productCode = p.productCode
group by od.productCode, p.productName
order by Total_qty desc
limit 10;

-- 3. List product lines where the average MSRP > 100.

SELECT 
    p.productLine, AVG(p.MSRP) AS avg_msrp
FROM
    products p
    
group by p.productLine
having avg(p.MSRP) > 100;

-- 4.Show employees with more than 3 customers assigned

SELECT 
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS emp_name,
    COUNT(c.customerNumber) AS customers_count
FROM
    employees e
LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
HAVING COUNT(c.customerNumber) > 3;

-- 5. Display orders where the shippedDate is NULL.

SELECT 
    *
FROM
    orders
WHERE shippedDate IS NULL;

-- Part 7: Business Insights

-- 1.Which country generates the most revenue?

SELECT 
    c.country, SUM(p.amount) AS total_revenue
FROM
    customers c
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.country
ORDER BY total_revenue DESC
LIMIT 1;

-- 2. Who are the top 5 sales representatives by payments?

SELECT 
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS rep_name,
    SUM(p.amount) AS total_payments
FROM
    employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY e.employeeNumber
ORDER BY total_payments DESC
LIMIT 5;

-- 3.Which month has the highest number of orders?

SELECT DATE_FORMAT(orderDate, '%Y-%m') AS Year_Mon,
       COUNT(*) AS orders_count
FROM orders
GROUP BY Year_Mon
ORDER BY orders_count DESC
LIMIT 1;

-- 4.Find the trend of sales over years.

SELECT 
    YEAR(o.orderDate) AS sales_year,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM
    orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY sales_year
ORDER BY sales_year;

-- 5. Which product line has highest stock but lowest sales?

SELECT 
    p.productLine,
    SUM(p.quantityInStock) AS total_stock,
    COALESCE(SUM(od.quantityOrdered * od.priceEach),
            0) AS total_sales
FROM
    products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine
-- To find "highest stock but lowest sales", look for high stock AND low sales:
ORDER BY total_stock DESC, total_sales ASC
LIMIT 5;


