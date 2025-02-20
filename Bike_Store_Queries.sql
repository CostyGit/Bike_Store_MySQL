/*In this project, we will explore the Bike Store Relational Database, which is available on Kaggle.*/

/*We will beging by taking a closer look at each table in the database*/

SELECT * FROM brands;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM staffs;
SELECT * FROM stocks;
SELECT * FROM stores;

/*We will start by identifying the store with the highest volume of orders.*/
SELECT 
s.store_name,
s.city as location,
s.state,
COUNT(o.store_id) as total_orders
FROM orders o
JOIN stores s ON o.store_id=s.store_id
GROUP BY o.store_id
ORDER BY total_orders DESC;

/*We will then check if the highest volume of orders corresponds to the highest revenue, taking into consideration any discounts.*/
SELECT
s.store_name,
s.city as location,
s.state,
SUM(oi.list_price) as total_revenue,
SUM(oi.discount) as total_discount,
SUM(oi.list_price - oi.discount) as net_revenue
FROM orders o
JOIN stores s ON o.store_id=s.store_id
JOIN order_items oi ON oi.order_id=o.order_id
GROUP BY o.store_id
ORDER BY net_revenue DESC;

/*We will then look at the top three most sold categories.*/
SELECT
COUNT(o.order_id) as total_orders,
c.category_name
FROM orders o
JOIN stores s ON o.store_id=s.store_id
JOIN order_items oi ON oi.order_id=o.order_id
JOIN products p ON p.product_id=oi.product_id
JOIN categories c ON c.category_id=p.category_id
GROUP BY c.category_name
ORDER BY total_orders DESC
LIMIT 3;

/*We are going to check if there are any repeating customers across all stores.*/
SELECT *
FROM (SELECT
customer_id,
COUNT(order_id) as total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC) b
WHERE total_orders > 1;

/*It seems like the total orders for repeat customers does not exceed three. We will now identify the customer who has spent the most.*/
SELECT
c.first_name,
c.last_name,
SUM(oi.list_price) as total_revenue,
SUM(oi.discount) as total_discount,
SUM(oi.list_price - oi.discount) as net_revenue
FROM orders o
JOIN stores s ON o.store_id=s.store_id
JOIN order_items oi ON oi.order_id=o.order_id
JOIN customers c ON c.customer_id=o.customer_id
GROUP BY c.customer_id
ORDER BY net_revenue DESC
LIMIT 1;