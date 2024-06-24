
-- This case study analyses the data from a restaurant business, Pizza Runner. The Restaurant
-- is adopting online ordering and uberizing its pizza business.
-- The business has collected data about its products, orders received, and the delivery runners.


-- Reference: https://8weeksqlchallenge.com/case-study-2/

-- 2.0 QUESTIONS ON PIZZA RUNNER
/* 2.1. Pizza Metrics

   -- How many pizzas were ordered?
   -- How many unique customer orders were made?
   -- How many successful orders were delivered by each runner?
   -- How many of each type of pizza was delivered?
   -- How many Vegetarian and Meatlovers were ordered by each customer?
   -- What was the maximum number of pizzas delivered in a single order?
   -- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
   -- How many pizzas were delivered that had both exclusions and extras?
   -- What was the total volume of pizzas ordered for each hour of the day?
   -- What was the volume of orders for each day of the week?
*/

-- 2.1.1 How many pizzas were ordered?
/*Select count (pizza_id)
From customer_orders;*/
         --Ans: 14 pizzas

-- 2.1.2 How many unique customer orders were made? 
/*Select DISTINCT (order_id)
From customer_orders; */
         --Ans: 10 orders

-- 2.1.3 How many successful orders were delivered by each runner?
/*
Select runner_id, COUNT(runner_id) as SuccessfulDelivery
From runner_orders
GROUP BY runner_id, cancellation
HAVING cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation'); */
         --Ans: ID1 = 2, ID2 = 3, 1D3 = 1

-- 2.1.4 How many of each type of pizza was delivered?
/*
Select pn.pizza_id , COUNT (pn.pizza_id) as pizzadeliverd
            FROM pizza_names as pn 
            JOIN customer_orders as co ON pn.pizza_id = co.pizza_id 
            JOIN runner_orders as ro ON co.order_id = ro.order_id
            GROUP BY pn.pizza_id, ro.cancellation            
            HAVING ro.cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation'); */
         --Ans: ID1 = 7, ID2 = 3

-- 2.1.5 How many Vegetarian and Meatlovers were ordered by each customer?
/* Select co.customer_id, pn.pizza_id, COUNT(pn.pizza_id) as Frequency
            FROM customer_orders as co
            JOIN pizza_names as pn ON co.pizza_id = pn.pizza_id
            GROUP BY co.customer_id, pn.pizza_id; */

-- 2.1.6 What was the maximum number of pizzas delivered in a single order?
/*Select TOP 1 ro.order_id, COUNT (co.pizza_id) as pizzadeliverd
            FROM runner_orders as ro 
            JOIN customer_orders as co ON ro.order_id = co.order_id
            GROUP BY ro.order_id, co.pizza_id, ro.cancellation          
            HAVING ro.cancellation IN ('', 'Null', 'null')
            ORDER BY pizzadeliverd DESC;


Select TOP 1 ro.order_id, COUNT (co.customer_id) as pizzadeliverd
            FROM runner_orders as ro 
            JOIN customer_orders as co ON ro.order_id = co.order_id
            GROUP BY ro.order_id, co.customer_id, ro.cancellation          
            HAVING ro.cancellation IN ('','Null', 'null')
            ORDER BY pizzadeliverd DESC;
*/
-- 2.1.7 For each customer, how many delivered pizzas had 
-- at least 1 change and how many had no changes?

SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras
      HAVING ro.cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation');


-- with at least 1 change
SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras
      HAVING (exclusions != '') AND (exclusions != 'null') OR
            (extras !='') AND (extras != 'null') AND
            (ro.cancellation !='Customer Cancellation') ;

-- with no change
SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras
      HAVING (exclusions = '') AND (exclusions = 'null') OR
            (extras ='') AND (extras = 'null') AND
            (ro.cancellation !='Customer Cancellation') ;
 

SELECT co.customer_id, COUNT (co.pizza_id) as Changedpizza
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.pizza_id, co.exclusions, co.extras
      HAVING ro.cancellation IN ('', 'Null', 'null') AND co.exclusions IN ('','null') AND co.extras IN ('','null');

SELECT co.customer_id, COUNT (co.pizza_id) as Changedpizza
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.pizza_id, co.exclusions, co.extras
      HAVING ro.cancellation IN ('', 'Null', 'null') AND co.exclusions >= 0 AND co.extras >= 0 ;

SELECT co.customer_id, COUNT (co.pizza_id) as Changedpizza
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.pizza_id, co.exclusions, co.extras
      HAVING ro.cancellation IN ('', 'Null', 'null') AND co.exclusions >= 0 OR co.extras >= 0 ;


SELECT *
FROM
(SELECT co.customer_id, ro.cancellation, co.pizza_id, co.exclusions, co.extras, COUNT (co.pizza_id) as Changedpizza
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.pizza_id, co.exclusions, co.extras
      HAVING ro.cancellation IN ('', 'Null', 'null')) as Ta;
      
-- 2.1.8 How many pizzas were delivered that had both exclusions and extras?
/*
SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras
      HAVING (exclusions != '') AND (exclusions != 'null') AND
            (extras !='') AND (extras != 'null') AND
            ro.cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation') ;

*/

-- 2.1.9 What was the total volume of pizzas ordered for each hour of the day?
/*SELECT FORMAT (order_time, 'yyyy-MM-dd HH:00:00') as hourOftheday,
             COUNT (pizza_id) as pizzaamount
      FROM customer_orders 
      GROUP BY FORMAT(order_time, 'yyyy-MM-dd HH:00:00'); */

/*    
SELECT CAST (order_time as date) as hr,
             COUNT (pizza_id) as pizzaamount
      FROM customer_orders 
      GROUP BY CAST (order_time as date);

SELECT CAST (order_time as time) as hr,
             COUNT (pizza_id) as pizzaamount
      FROM customer_orders 
      GROUP BY CAST (order_time as time);
*/

-- 2.2.0 What was the volume of orders for each day of the week?

/*SELECT ref.Orderday, SUM(ref.pizzaamount) as OrderVolume
FROM (SELECT DATENAME(WEEKDAY, "order_time") as Orderday,
      COUNT (pizza_id) as pizzaamount
FROM customer_orders
GROUP BY order_time, pizza_id) as ref
GROUP BY ref.Orderday, ref.pizzaamount;

SELECT DATENAME(WEEKDAY, "order_time") as Orderday,
      COUNT (pizza_id) as pizzaamount
FROM customer_orders
GROUP BY order_time, pizza_id;
*/




-- WASTE

Select co.pizza_id, COUNT (co.pizza_id) as pizzadeliverd
            FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
            GROUP BY co.pizza_id;          

      (Select *
       FROM runner_orders
       WHERE cancellation IN ('','NULL', 'null')) as ro ON 
       
       ro.cancellation ; 
pn.pizza_names, 

SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, ro.cancellation
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation
      HAVING ro.cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation');

SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, ro.cancellation
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation;



SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras;
      
SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras
      HAVING ro.cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation');


SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras
      HAVING ro.cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation') AND
            (exclusions != '') AND (exclusions != 'null') OR
            (extras !='') AND (extras != 'null');