--Total pizzas sold
SELECT SUM(quantity) AS pizzas_sold
FROM order_details;

-- number of orders per day
SELECT date, count(order_id) AS number_of_orders
FROM orders
GROUP BY date
ORDER BY date;

-- Peak hours
SELECT EXTRACT(hour FROM time) AS hours, count(order_id) AS number_of_orders
FROM orders
GROUP BY hours
order by number_of_orders DESC;

-- Average number of pizzas per order
SELECT AVG(number_of_pizzas) AS pizzas_per_order
FROM 
(
	SELECT order_id, SUM(quantity) AS number_of_pizzas
	FROM order_details
	GROUP BY order_id
) t ;

-- Best Sellers according to number of orders
SELECT pt.name, SUM(o.quantity) AS number_of_pizzas
FROM order_details o
JOIN pizzas p
ON o.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY number_of_pizzas DESC;

-- Most ordered size
SELECT p.size, SUM(o.quantity) AS size_number
FROM order_details o
JOIN pizzas p
ON o.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY size_number DESC;

-- Most profitable size
SELECT p.size, ROUND(SUM(o.quantity*p.price)) AS size_revenue
FROM order_details o
JOIN pizzas p
ON o.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY size_revenue DESC;

-- Total revenue 
SELECT ROUND(SUM(quantity*price)) AS total_revenue
FROM pizzas p
JOIN order_details o
ON o.pizza_id = p.pizza_id;

-- -- Best Sellers according to total revenue
SELECT pt.name, ROUND(SUM(quantity*price)) AS total_revenue
FROM pizza_types pt
JOIN pizzas p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details o
ON p.pizza_id = o.pizza_id
GROUP BY pt.name
ORDER BY total_revenue DESC;	

-- Most ordered category
SELECT p.category, SUM(o.quantity) AS num_of_orders
FROM pizza_types p
JOIN pizzas pi
ON p.pizza_type_id = pi.pizza_type_id
JOIN order_details o
ON pi.pizza_id = o.pizza_id
GROUP BY p.category
ORDER BY num_of_orders DESC;

-- Average order value 
SELECT SUM(quantity*price)/COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN pizzas p
ON od.pizza_id = p.pizza_id;

-- Most ingredients used in all the 32 pizza types
SELECT ingredients, COUNT(*) most_used
FROM 
(
	SELECT unnest(string_to_array(ingredients, ',')) AS ingredients
		FROM pizza_types
) t
GROUP BY ingredients
ORDER BY most_used DESC;

-- Average number of orders for each hour
SELECT hours, ROUND(AVG(number_of_orders)) avg_orders
FROM 
( SELECT date,EXTRACT(hour FROM time) AS hours, COUNT(order_id) AS number_of_orders
FROM orders
GROUP BY date,hours
order by number_of_orders DESC) t
GROUP BY hours
order by avg_orders DESC;