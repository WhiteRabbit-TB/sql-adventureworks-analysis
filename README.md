# SQL Data Analysis — AdventureWorks2019
### Final Assessment | Data Analysis Course | 6 Business Questions

---

## Overview

This is my final SQL assessment completed as part of a formal 
data analysis course at an accredited institution in Lithuania.

The database used is **AdventureWorks2019** — Microsoft's standard 
sample business database containing sales, production, purchasing, 
and human resources data across multiple related tables.

All 6 tasks were written independently as exam conditions.

---

## SQL Concepts Used

| Concept | Where Used |
|--------|-----------|
| CTEs (Common Table Expressions) | Tasks 1, 3 |
| Window Functions | Tasks 1, 3 |
| DENSE_RANK() | Task 1 |
| AVG() OVER PARTITION BY | Task 3 |
| CASE statements | Tasks 1, 3 |
| LEFT JOIN | Task 1 |
| Multi-table JOINs (4-5 tables) | Tasks 2, 3, 4, 5 |
| Aggregations (SUM, COUNT, AVG) | All tasks |
| Date functions (YEAR, MONTH, DATEDIFF) | Tasks 1, 2, 4, 5, 6 |
| ROUND | All tasks |

---

## Tasks Breakdown

---

### Task 1 — Customer Order Analysis (2013 first-time buyers)

**Business question:**
Find all customers whose first ever order was in 2013.
For each of them show their 2013 average order value,
and all their individual 2014 orders ranked chronologically.

**Approach:**
Built 3 CTEs:
- `PirmiUzsakymai` — finds the date of each customer's very first order
- `Uzsakymai2014` — calculates total spending per customer in 2014
- `average2013` — calculates each customer's average order value in 2013

Then joined all three together with customer and person tables.
Used `LEFT JOIN` on 2014 orders because not all 2013 customers
placed orders in 2014 — a regular JOIN would have lost those customers.
Used `DENSE_RANK()` window function to number each customer's
2014 orders chronologically.

**Concepts:** CTEs, window functions, DENSE_RANK, LEFT JOIN,
conditional aggregation with CASE, multi-table joins

---

### Task 2 — Sales by Product Category and Region (2013)

**Business question:**
Show total sales broken down by product category and 
sales territory for the year 2013.

**Approach:**
Joined 5 tables to connect order line items all the way up
through product subcategory → category, and order header
through to sales territory. Grouped by category and region.

**Concepts:** Multi-table joins, GROUP BY, aggregation, date filtering

---

### Task 3 — Employee Sales Performance vs Department Average

**Business question:**
For each salesperson show their total sales, their department
average, their performance as a percentage of that average,
and a label — above average, at average, or below average.

**Approach:**
Used a CTE to first calculate each employee's total sales
alongside their department. Then in the main query used
`AVG() OVER PARTITION BY departmentid` to calculate the
department average as a window function — this allows
comparing each employee to their department average
without a self join. Used CASE to assign performance labels.
Calculated relative performance as a percentage.

**Concepts:** CTE, window functions, AVG OVER PARTITION BY,
CASE statement, percentage calculation, HR and sales table joins

---

### Task 4 — Product Subcategory Revenue Analysis (2013)

**Business question:**
For each product subcategory in 2013 show total quantity sold,
total revenue, and average selling price per unit.

**Approach:**
Joined order details to products to subcategories.
Calculated average price as total revenue divided by
total quantity — not a simple AVG of unit prices, which
would be less accurate as it ignores quantity weighting.

**Concepts:** Multi-table joins, aggregation, calculated fields,
ORDER BY on derived column

---

### Task 5 — Supplier Delivery Time Analysis

**Business question:**
For each vendor and product combination calculate the
average number of days between order date and ship date.

**Approach:**
Joined purchase orders to products and vendors.
Used DATEDIFF to calculate delivery time per order,
then averaged across all orders for each vendor-product pair.
Filtered out records where ShipDate is null to avoid
incorrect calculations.

**Concepts:** DATEDIFF, multi-table joins, GROUP BY,
NULL filtering, aggregation

---

### Task 6 — Monthly Sales Summary (2013)

**Business question:**
Show month by month sales count and total revenue for 2013.

**Approach:**
Simple aggregation grouped by month number and month name
to ensure correct ordering and readable output.

**Concepts:** MONTH(), MONTHNAME(), GROUP BY, COUNT, SUM

---

## Database

**AdventureWorks2019** — Microsoft's sample OLTP database
simulating a fictional manufacturing company (Adventure Works Cycles).
Contains 70+ tables across Sales, Production, Purchasing,
HumanResources and Person schemas.

---

## Tech

- MySQL
- AdventureWorks2019 database

---

*Completed as a graded final assessment for a data analysis 
course at an accredited institution in Lithuania, 2025.*

**GitHub:** [github.com/WhiteRabbit-TB](https://github.com/WhiteRabbit-TB)
