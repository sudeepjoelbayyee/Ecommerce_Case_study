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

select ProductName, sum(Quantity) as total_quantity from orderdetails t1 join products t2 on t1.ProductID = t2.ProductID
group by t2.ProductID order by total_quantity desc limit 5;

-- 4) Identify the customers who have made the highest total purchase amount
select t1.CustomerID, concat_ws(' ',t1.FirstName,t1.LastName) as name,
(t4.Price*t3.Quantity) as TotalPurchase 
from customers t1 
join orders t2 on t1.CustomerID = t2.CustomerID
join orderdetails t3 on t2.OrderId = t3.OrderId
join products t4 on t3.ProductId = t4.ProductId
group by t1.CustomerID,t1.FirstName,t1.LastName 
order by TotalPurchase desc limit 1;

-- 5) List the products that have never been ordered
select * from products where ProductId not in (select distinct ProductId from orderdetails);

-- 6) Calculate the average quantity of products ordered by each customer
-- 7) Find the month with the highest total revenue.
-- 8) Determine the customer with the highest average order value.
-- 9) Identify the products with the highest and lowest prices.
-- 10) Calculate the percentage of orders that include more than one product.
-- 11) List the customers who have made purchases in consecutive months.
-- 12) Find the products with the highest and lowest sales growth (compare the total quantity sold in the last month with the previous month).
-- 13) Calculate the total revenue for each category of products (e.g., electronics, accessories).
-- 14) Identify any patterns or trends in customer purchasing behavior over time.
-- 15) Determine the average time between consecutive orders for each customer.
-- 16) Calculate the percentage of total revenue contributed by each product.
-- 17) Identify the products that have the highest average sales per month.
-- 18) Find the customers who have made the most consecutive orders.
-- 19) Calculate the average order value for each product category.
-- 20) Determine the customer who has ordered the widest variety of products.
