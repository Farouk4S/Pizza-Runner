
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

-- 2.1.5 What was the difference between the 
-- longest and shortest delivery times for all orders?
/*
SELECT 
MAX(duration) - MIN(duration)
FROM customer_orders as co
JOIN runner_orders as ro ON co.order_id = ro.order_id;
 */

-- 2.1.6 What was the average speed for each runner for each delivery
-- and do you notice any trend for these values?
/*
SELECT  order_id, runner_id, ROUND((distance/duration)*60, 2) as Speed
From runner_orders
GROUP BY order_id, runner_id, distance, duration;


SELECT del.order_id, del.runner_id, ROUND(del.distance/del.duration*60, 2)
FROM
      (SELECT runner_id, order_id, distance, duration
      From runner_orders) as del
GROUP BY del.order_id, runner_id, del.distance, del.duration;

*/

-- 2.1.7 What is the successful delivery percentage for each runner?
/*
SELECT sc.runner_id, sc.Success, al.Total,  
      CAST (sc.Success as Float)/al.Total * 100 as Percentage
FROM #Succ as sc
JOIN  #All as al ON al.runner_id = sc.runner_id
GROUP BY sc.runner_id, sc.Success, al.Total ;


DROP TABLE IF EXISTS  #Succ
SELECT ad.runner_id, ad.cancellation, Success
INTO #Succ
FROM
            (SELECT runner_id, cancellation, COUNT(cancellation) as Success
            FROM runner_orders

            GROUP BY runner_id, cancellation) as ad
WHERE ad.cancellation NOT IN (
                  '', 'Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id, cancellation, Success;

DROP TABLE IF EXISTS  #All
SELECT runner_id, COUNT(runner_id) as Total
INTO #All
From runner_orders
GROUP BY runner_id;

SELECT *
FROM #All;
SELECT *
FROM #Succ;
*/