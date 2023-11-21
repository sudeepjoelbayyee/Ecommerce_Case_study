use ecommerce;

-- 1) Retrieve the total number of products in each price range (e.g., 0-50, 50-100, 100-200, 200+)
SELECT 
    CASE
        WHEN Price BETWEEN 0 AND 50 THEN '0-50'
        WHEN price BETWEEN 51 AND 100 THEN '50-100'
        WHEN price BETWEEN 101 AND 200 THEN '100-200'
        ELSE '50-100'
    END AS 'PriceRange',
    COUNT(*) AS num_of_products
FROM
    products
GROUP BY PriceRange
ORDER BY PriceRange;

-- 2) Calculate the average order value
SELECT 
    OrderID, ROUND(AVG(Price * Quantity), 2) AS avg_price
FROM
    orderdetails t1
        JOIN
    products t2 ON t1.ProductID = t2.ProductID
GROUP BY OrderID;

-- 3) Find the top-selling products based on the total quantity sold

SELECT 
    ProductName, SUM(Quantity) AS total_quantity
FROM
    orderdetails t1
        JOIN
    products t2 ON t1.ProductID = t2.ProductID
GROUP BY t2.ProductID
ORDER BY total_quantity DESC
LIMIT 5;

-- 4) Identify the customers who have made the highest total purchase amount
SELECT 
    t1.CustomerID,
    CONCAT_WS(' ', t1.FirstName, t1.LastName) AS name,
    (t4.Price * t3.Quantity) AS TotalPurchase
FROM
    customers t1
        JOIN
    orders t2 ON t1.CustomerID = t2.CustomerID
        JOIN
    orderdetails t3 ON t2.OrderId = t3.OrderId
        JOIN
    products t4 ON t3.ProductId = t4.ProductId
GROUP BY t1.CustomerID , t1.FirstName , t1.LastName
ORDER BY TotalPurchase DESC
LIMIT 1;

-- 5) List the products that have never been ordered
SELECT 
    *
FROM
    products
WHERE
    ProductId NOT IN (SELECT DISTINCT
            ProductId
        FROM
            orderdetails);

-- 6) Calculate the average quantity of products ordered by each customer
SELECT 
    t1.CustomerID,
    CONCAT_WS(' ', t1.FirstName, t1.LastName) AS name,
    (t3.Quantity) AS avg_quantity
FROM
    customers t1
        JOIN
    orders t2 ON t1.CustomerID = t2.CustomerID
        JOIN
    orderdetails t3 ON t2.OrderID = t3.OrderID
GROUP BY t1.CustomerID;

-- 7) Find the month with the highest total revenue.
SELECT 
    MONTHNAME(DATE(OrderDate)) AS month,
    SUM(Price * Quantity) AS total_revenue
FROM
    orders t1
        JOIN
    orderdetails t2 ON t1.OrderID = t2.OrderID
        JOIN
    products t3 ON t2.ProductID = t3.ProductID
GROUP BY MONTHNAME(DATE(OrderDate))
ORDER BY total_revenue DESC
LIMIT 1;

-- 8) Determine the customer with the highest average order value.
SELECT 
    t1.CustomerID,
    CONCAT_WS(' ', t1.FirstName, t1.LastName) AS name,
    ROUND(AVG(Price * Quantity)) AS avg_price
FROM
    customers t1
        JOIN
    orders t2 ON t1.CustomerID = t2.CustomerID
        JOIN
    orderdetails t3 ON t2.OrderID = t3.OrderID
        JOIN
    products t4 ON t3.ProductID = t4.ProductID
GROUP BY t1.CustomerID
ORDER BY avg_price DESC
LIMIT 1;

-- 9) Identify the products with the highest and lowest prices.
select * from products order by Price desc limit 1;
select * from products order by Price limit 1;

-- 10) Calculate the percentage of orders that include more than one product.
SELECT
    (COUNT(CASE WHEN num_products > 1 THEN 1 END) / COUNT(*)) * 100 AS Percentage
FROM ( SELECT 
    t1.OrderID, COUNT(ProductID) num_products
FROM
    orders t1
        JOIN
    orderdetails t2 ON t1.OrderID = t2.OrderID
GROUP BY t1.OrderID) as OrderProductCounts;

-- 11) List the customers who have made purchases in consecutive months.
SELECT 
    t1.CustomerID,
    CONCAT_WS(' ', t1.FirstName, t1.LastName) AS name,
    OrderDate
FROM
    customers t1
        JOIN
    orders t2 ON t1.CustomerID = t2.CustomerID
WHERE
    MONTH(OrderDate) % 2 != 0;

-- 12) Find the products with the highest and lowest sales growth (compare the total quantity sold in the last month with the previous month).
SELECT 
    t1.ProductId,
    ProductName,
    SUM(Quantity),
    SUM(Price * Quantity) AS total_sales
FROM
    products t1
        JOIN
    orderdetails t2 ON t1.ProductID = t2.ProductID
        JOIN
    orders t3 ON t2.OrderId = t3.OrderID
GROUP BY t1.ProductID
ORDER BY total_sales DESC;

-- 13) Identify the products that have the highest average sales per month.
SELECT 
    MONTHNAME(OrderDate) AS month_name,
    ProductName,
    SUM(Price * Quantity) / COUNT(*) AS avg_sales
FROM
    orders t1
        JOIN
    orderdetails t2 ON t1.OrderID = t2.OrderID
        JOIN
    products t3 ON t2.ProductID = t3.ProductID
GROUP BY MONTHNAME(OrderDate)
ORDER BY MONTH(OrderDate) , avg_sales DESC;

-- 14) Calculate the average order value for each product category.
SELECT 
    ProductName, ROUND(AVG(Price * Quantity)) AS avg_orders
FROM
    products t1
        JOIN
    orderdetails t2 ON t1.ProductID = t2.ProductID
GROUP BY t1.ProductID
ORDER BY avg_orders DESC;

-- 15) Determine the customer who has ordered the widest variety of products.
SELECT 
    t1.CustomerID,
    CONCAT_WS(' ', t1.FirstName, t1.LastName) AS name,
    COUNT(DISTINCT t4.ProductID) AS distinct_count
FROM
    customers t1
        JOIN
    orders t2 ON t1.CustomerID = t2.CustomerID
        JOIN
    orderdetails t3 ON t2.OrderID = t3.OrderID
        JOIN
    products t4 ON t3.ProductID = t4.ProductID
GROUP BY t1.CustomerID
ORDER BY distinct_count DESC
LIMIT 1;
