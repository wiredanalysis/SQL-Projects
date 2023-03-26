--Analyze the data
--How many unique customers are there?
SELECT COUNT(DISTINCT CustomerID) FROM dbo.ecomdata;

--What is the total revenue?
SELECT SUM(Quantity * UnitPrice) AS revenue FROM dbo.ecomdata;

--Which country has the most orders?
SELECT TOP 1 Country, COUNT(DISTINCT InvoiceNo) AS num_orders
FROM dbo.ecomdata
GROUP BY Country
ORDER BY num_orders DESC;

--What is the average order value?
SELECT AVG(Quantity * UnitPrice) AS avg_order_value FROM dbo.ecomdata;

--What is the most popular product?
SELECT TOP 1 Description, SUM(Quantity) AS total_quantity
FROM dbo.ecomdata
GROUP BY Description
ORDER BY total_quantity DESC;



--Find the total number of unique products sold and the total number of unique customers who made purchases.
SELECT COUNT(DISTINCT StockCode) AS num_products, COUNT(DISTINCT CustomerID) AS num_customers
FROM dbo.ecomdata;

--Determine the top 5 most popular products (by total quantity sold) and the number of units sold for each.
SELECT TOP 5 StockCode, Description, SUM(Quantity) AS total_quantity
FROM dbo.ecomdata
GROUP BY StockCode, Description
ORDER BY total_quantity DESC;

--Calculate the total revenue, average order value, and total number of orders per country.
SELECT Country, COUNT(DISTINCT InvoiceNo) AS num_orders, SUM(Quantity * UnitPrice) AS total_revenue, AVG(Quantity * UnitPrice) AS avg_order_value
FROM dbo.ecomdata
GROUP BY Country;

--Identify the top 5 customers (by total spend) and the number of orders and total amount spent for each.
SELECT TOP 5 CustomerID, COUNT(DISTINCT InvoiceNo) AS num_orders, SUM(Quantity * UnitPrice) AS total_spent
FROM dbo.ecomdata
GROUP BY CustomerID
ORDER BY total_spent DESC;

-- Get the number of orders by day of week
SELECT DATENAME(dw, InvoiceDate) AS DayOfWeek, COUNT(DISTINCT InvoiceNo) AS NumOrders
FROM dbo.ecomdata
GROUP BY DATENAME(dw, InvoiceDate), InvoiceDate
ORDER BY MIN(InvoiceDate);

-- Get the number of orders by month
SELECT DATENAME(mm, InvoiceDate) AS Month, COUNT(DISTINCT InvoiceNo) AS NumOrders
FROM dbo.ecomdata
GROUP BY DATENAME(mm, InvoiceDate), InvoiceDate
ORDER BY Month(InvoiceDate);


-- show the top 5 customers by total spend.
SELECT TOP 5 CONCAT(CustomerID, ' - ', Description) AS customer, SUM(Quantity * UnitPrice) AS total_spent
FROM dbo.ecomdata
GROUP BY CustomerID, Description
ORDER BY total_spent DESC
;

--show the relationship between the total revenue and the average order value for each country.
SELECT Country, AVG(Quantity * UnitPrice) AS avg_order_value, SUM(Quantity * UnitPrice) AS total_revenue
FROM dbo.ecomdata
GROUP BY Country;

--Calculate the total revenue for each customer
SELECT CustomerID, SUM(Quantity*UnitPrice) AS TotalRevenue
FROM dbo.ecomdata
GROUP BY CustomerID
ORDER BY TotalRevenue DESC;

--Find the top 10 most sold products
SELECT TOP 10 Description, SUM(Quantity) AS TotalQuantitySold
FROM dbo.ecomdata
GROUP BY Description
ORDER BY TotalQuantitySold DESC

--Average revenue per order
SELECT TOP 100 InvoiceNo, SUM(Quantity*UnitPrice) AS TotalRevenue
FROM dbo.ecomdata
GROUP BY InvoiceNo
ORDER BY TotalRevenue DESC;

SELECT AVG(TotalRevenue) AS AvgRevenuePerOrder
FROM (
    SELECT InvoiceNo, SUM(Quantity*UnitPrice) AS TotalRevenue
    FROM dbo.ecomdata
    GROUP BY InvoiceNo
) subquery;

--Monthly revenue trend
SELECT YEAR(InvoiceDate) AS Year, MONTH(InvoiceDate) AS Month, SUM(Quantity*UnitPrice) AS TotalRevenue
FROM dbo.ecomdata
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY YEAR(InvoiceDate) DESC, MONTH(InvoiceDate) DESC;

--Top 10 highest spending customers
SELECT TOP 10 CustomerID, SUM(Quantity*UnitPrice) AS TotalSpending
FROM dbo.ecomdata
GROUP BY CustomerID
ORDER BY TotalSpending DESC

--Monthly revenue trend by country
SELECT 
    Country,
    YEAR(InvoiceDate) AS Year, 
    MONTH(InvoiceDate) AS Month, 
    SUM(Quantity*UnitPrice) AS TotalRevenue
FROM dbo.ecomdata
GROUP BY Country, YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Country, YEAR(InvoiceDate) DESC, MONTH(InvoiceDate) DESC;

--Top 10 most popular products by country
SELECT TOP 10
    Country,
    Description, 
    SUM(Quantity) AS TotalQuantity
FROM dbo.ecomdata
GROUP BY Country, Description
ORDER BY Country, TotalQuantity DESC;

--Monthly customer acquisition trend
SELECT 
    YEAR(InvoiceDate) AS Year, 
    MONTH(InvoiceDate) AS Month, 
    COUNT(DISTINCT CustomerID) AS NumNewCustomers
FROM dbo.ecomdata
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY YEAR(InvoiceDate) DESC, MONTH(InvoiceDate) DESC;


--Customer retention rate
SELECT 
    YearMonth,
    SUM(CASE WHEN RepeatOrders > 0 THEN 1 ELSE 0 END) AS NumRepeatCustomers,
    COUNT(DISTINCT CustomerID) AS NumCustomers,
    SUM(CASE WHEN RepeatOrders > 0 THEN 1 ELSE 0 END) / CAST(COUNT(DISTINCT CustomerID) AS FLOAT) AS RetentionRate
FROM (
    SELECT 
        CustomerID, 
        YEAR(InvoiceDate)*100 + MONTH(InvoiceDate) AS YearMonth,
        COUNT(DISTINCT InvoiceNo) AS RepeatOrders
    FROM dbo.ecomdata
    GROUP BY CustomerID, YEAR(InvoiceDate), MONTH(InvoiceDate)
) subquery
GROUP BY YearMonth
ORDER BY YearMonth;


















