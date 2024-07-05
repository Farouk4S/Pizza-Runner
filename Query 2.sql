
-- This case study analyses the data from a restaurant business, Pizza Runner. The Restaurant
-- is adopting online ordering and uberizing its pizza business.
-- The business has collected data about its products, orders received, and the delivery runners.


-- Reference: https://8weeksqlchallenge.com/case-study-2/

-- 2.0 QUESTIONS ON PIZZA RUNNER
/* 2.2. Runner and Customer Experience

--    How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
--    What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
--    Is there any relationship between the number of pizzas and how long the order takes to prepare?
--    What was the average distance travelled for each customer?
--    What was the difference between the longest and shortest delivery times for all orders?
--    What was the average speed for each runner for each delivery and do you notice any trend for these values?
--    What is the successful delivery percentage for each runner?

*/
-- 2.2.1 How many runners signed up for each 1 week period? 
-- (i.e. week starts 2021-01-01)
/*
SELECT jw.JoinWeeK, COUNT(jw.JoinWeek) as SignUps
FROM
      (Select DATEPART (WEEK, registration_date) as JoinWeek, 
           runner_id
      From runners
      GROUP BY registration_date, runner_id) as jw
GROUP BY jw.JoinWeek
*/
-- 2.2.2 What was the average time in minutes it took for each runner 
-- to arrive at the Pizza Runner HQ to pickup the order?
/*
SELECT pt.runner_id, AVG (pt.Ptimeinminutes)
FROM 
      (Select runner_id, DATEPART(MINUTE, pickup_time) as Ptimeinminutes
      From runner_orders
      GROUP BY pickup_time, runner_id) as pt
GROUP BY pt.runner_id ;
*/
-- 2.2.3 Is there any relationship between the number of pizzas 
-- and how long the order takes to prepare?
/* Select prt.order_id, COUNT(prt.order_id) as PizzaAmount,
       AVG(prt.Preptime) as PizzaPreptime
From 
      (SELECT co.pizza_id, 
      co.order_id,
      co.customer_id,
      DATEDIFF(MINUTE, co.order_time, ro.pickup_time) as Preptime
      FROM customer_orders as co
      JOIN runner_orders as ro ON co.order_id = ro.order_id) as prt 
GROUP BY prt.order_id;   */

/*
Select prt.customer_id, COUNT(prt.customer_id), AVG(prt.Preptime)
From 
      (SELECT co.pizza_id, 
      co.order_id,
      co.customer_id,
      DATEDIFF(MINUTE, co.order_time, ro.pickup_time) as Preptime
      FROM customer_orders as co
      JOIN runner_orders as ro ON co.order_id = ro.order_id) as prt 
GROUP BY prt.customer_id;
*/

-- 2.1.4 What was the average distance travelled for each customer?
/*
Select dtr.customer_id, 
      COUNT(dtr.customer_id) as PizzaAmount, 
      AVG(dtr.distance) as AverageTravel
From 
      (SELECT customer_id,
      distance
      FROM customer_orders as co
      JOIN runner_orders as ro ON co.order_id = ro.order_id) as dtr
GROUP BY dtr.customer_id;
*/
GROUP BY registration_date;
Select *
From runner_orders;
Select *
From customer_orders;

-- 2.1.5 What was the difference between the 
-- longest and shortest delivery times for all orders?


Select dur.customer_id, 
      MAX(dur.duration), 
      MIN(dur.duration)
From 
      (SELECT customer_id,
      duration
      FROM customer_orders as co
      JOIN runner_orders as ro ON co.order_id = ro.order_id) as dur
GROUP BY dur.customer_id;


      SELECT customer_id,
      duration
      FROM customer_orders as co
      JOIN runner_orders as ro ON co.order_id = ro.order_id
 */

-- 2.1.6 What was the average speed for each runner for each delivery
-- and do you notice any trend for these values?

SELECT del.order_id, del.runner_id, ROUND(del.distance/del.duration*60, 2)
FROM
      (SELECT runner_id, order_id, distance, duration
      From runner_orders) as del
GROUP BY del.order_id, runner_id, del.distance, del.duration


-- 2.1.7 What is the successful delivery percentage for each runner?

SELECT runner_id, COUNT(runner_id) as Success, cancellation
INTO #Succ
From runner_orders
WHERE  cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id, cancellation

SELECT runner_id, COUNT(runner_id) as Failed, cancellation
INTO #FailedTab
From runner_orders
WHERE  cancellation IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id, cancellation

Select *
From #Succ as sc
JOIN #FailedTab as Ft ON sc.runner_id = Ft.runner_id 

Select sc.runner_id, sc.success/Ft.Failed
From #Succ as sc
JOIN #FailedTab as Ft ON sc.runner_id = Ft.runner_id 



order_id, distance, duration


Select *
From runner_orders;

-- with at least 1 change
SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      WHERE  ro.cancellation !='Customer Cancellation'
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras
      HAVING (exclusions != '') AND (exclusions != 'null') OR
            (extras !='') AND (extras != 'null');

SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza, 
            ro.cancellation, co.exclusions, co.extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      WHERE  ro.cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation')
      GROUP BY co.customer_id, ro.cancellation, co.exclusions, co.extras
      HAVING (exclusions != '') AND (exclusions != 'null') OR
            (extras !='') AND (extras != 'null');

-- with no change


SELECT co.customer_id, COUNT (co.customer_id) as Changedpizza,
 co.pizza_id, exclusions, extras
      FROM customer_orders as co
            JOIN runner_orders as ro ON co.order_id = ro.order_id
      WHERE  ro.cancellation NOT IN (
            '', 'Restaurant Cancellation', 'Customer Cancellation')
      GROUP BY co.customer_id, co.pizza_id, ro.cancellation, co.exclusions, co.extras
      HAVING exclusions IN ('null') AND
 