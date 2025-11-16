# 📊 SQL EDA Project — Classic Models Database  
Comprehensive SQL Exploratory Data Analysis performed on the **ClassicModels** dataset.  
This project explores customer behavior, orders, payments, products, and employee insights using SQL Joins, Aggregations, Subqueries, Views, and Stored Procedures.

---

## 🎯 Project Objectives  
- Perform complete EDA using SQL  
- Analyse customers, orders, products, payments  
- Extract business insights  
- Create advanced SQL procedures  
- Generate actionable findings

---

## 📁 Dataset  
ClassicModels database contains:  
- Customers  
- Employees  
- Offices  
- Orders  
- OrderDetails  
- Products  
- Payments  
- ProductLines  

---

## 📌 Key SQL Concepts Used  
- Joins (INNER, LEFT, RIGHT)  
- GROUP BY & Aggregates  
- Subqueries  
- Stored Procedures  
- Window Functions  
- Date Functions  
- Business Insights Queries

---

## 📑 Project Presentation (PDF)  
You can download the full project presentation here:  

👉 **[Download SQL EDA Project PDF](SQL_EDA_Project_ClassicModels.pdf)**  

*(PDF file is already uploaded in this repository.)*

---

## 🔍 Highlight Queries & Insights  

### ✔️ Top 5 Customers Based on Payments
```sql
SELECT customerNumber, SUM(amount) AS total_payments
FROM payments
GROUP BY customerNumber
ORDER BY total_payments DESC
LIMIT 5;

