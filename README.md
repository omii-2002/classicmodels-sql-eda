# 📊 SQL EDA Project — Classic Models Database  

This project is an end-to-end **SQL Exploratory Data Analysis (EDA)** on the **ClassicModels** relational database.  
I analysed customer behaviour, orders, payments, products, and sales performance using **pure SQL** – no external BI tool – to simulate a real-world reporting/analytics scenario.

---

## 🎯 Project Objectives  

- Explore the ClassicModels schema and understand business entities  
- Perform EDA using SQL only (no Excel / Python)  
- Analyse **customers, orders, products, payments, employees, and offices**  
- Derive **business insights** that a sales/management team can use  
- Practise advanced SQL: joins, subqueries, stored procedures, date logic, etc.

---

## 📁 Dataset Overview  

The ClassicModels database includes the following core tables:

- `customers` – customer details, country, credit limit  
- `employees` – sales reps, managers, reporting structure  
- `offices` – office locations and regions  
- `orders` – order header information (status, dates)  
- `orderdetails` – line-level order items and quantities  
- `products` – product catalogue, pricing & stock  
- `payments` – customer payments and dates  
- `productlines` – product categories  

---

## 🧠 Key SQL Topics Practised  

- Different types of **joins**: `INNER`, `LEFT`, `RIGHT`  
- **Aggregation & grouping**: `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`  
- **Subqueries** (inline, correlated)  
- **Stored procedures** for re-usable analysis  
- **Window functions** for rankings and trends  
- **Date functions** for monthly / yearly performance  
- Business-level insight queries (top customers, revenue by country, etc.)

---

## 📑 Project Presentation  

🔗 **Full project write-up (PDF):**  
[SQL EDA Project – ClassicModels (PDF)](SQL_EDA_Project_ClassicModels.pdf)  

The PDF includes:
- Problem statement  
- Approach & methodology  
- Important SQL queries  
- Result snapshots  
- Final business insights & recommendations  

---

## 🔍 Sample Highlight Queries & Insights  

Below are a few example queries from the project.  
(These are simplified versions – the full set is available in the PDF.)

---

### ✅ Top 5 Customers by Total Payments  

Goal: Identify the most valuable customers based on total payment amount.

```sql
SELECT 
    c.customerNumber,
    c.customerName,
    SUM(p.amount) AS total_payments
FROM customers AS c
JOIN payments  AS p
    ON c.customerNumber = p.customerNumber
GROUP BY 
    c.customerNumber,
    c.customerName
ORDER BY 
    total_payments DESC
LIMIT 5;
