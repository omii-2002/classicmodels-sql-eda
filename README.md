# 📊 SQL EDA Project — Classic Models Database  
A complete **SQL Exploratory Data Analysis (EDA)** project using the ClassicModels database.  
This project uncovers customer behavior, order trends, product performance, payments analysis, and employee insights using powerful SQL techniques.

---

## 🎯 Project Objectives  
- Perform complete EDA using SQL  
- Analyze customers, orders, payments & products  
- Generate actionable business insights  
- Create advanced SQL stored procedures  
- Improve understanding of SQL joins, grouping & subqueries

---

## 📁 Dataset Overview  
The **ClassicModels** database includes the following tables:

- 🧑‍🤝‍🧑 **Customers**  
- 🧑‍💼 **Employees**  
- 🏢 **Offices**  
- 🛒 **Orders**  
- 📦 **OrderDetails**  
- 🛍️ **Products**  
- 💳 **Payments**  
- 🗂️ **ProductLines**

---

## 📌 Key SQL Concepts Used  
- 🔗 Complex Joins (INNER, LEFT, RIGHT)  
- 📊 Aggregations & GROUP BY  
- 🔍 Subqueries & Nested Queries  
- 🛠 Stored Procedures  
- 🪟 Window Functions  
- 🗓 Date Functions  
- 💡 Business Insights Queries  

---

## 📑 Project Presentation (PDF)  
📥 Download the complete PDF presentation here:  
👉 **[SQL EDA Project – Classic Models](SQL_EDA_Project_ClassicModels.pdf)**  

---

## 🔍 Highlight Queries & Insights  

### ✔️ **Top 5 Customers Based on Total Payments**

```sql
SELECT 
    customerNumber, 
    SUM(amount) AS total_payments
FROM payments
GROUP BY customerNumber
ORDER BY total_payments DESC
LIMIT 5;
