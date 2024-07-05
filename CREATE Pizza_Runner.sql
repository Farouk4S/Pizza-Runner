-- This case study analyses the data from a restaurant business, Pizza Runner. The Restaurant
-- is adopting online ordering and uberizing its pizza business.
-- The business has collected data about its products, orders received, and the delivery runners.

-- Reference: https://8weeksqlchallenge.com/case-study-2/

-- 1.0 CREATE PIZZA RUNNER

/*CREATE database pizza_runner;*/

/*
DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
    "pizza_id"    INTEGER NOT NULL,
    "pizza_names" TEXT NOT NULL,
     PRIMARY KEY (pizza_id));
INSERT INTO pizza_names
(pizza_id, pizza_names)
VALUES
(1, 'Meatlovers'),
(2, 'Vegetarian'); */

/*
DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
    "pizza_id"  INTEGER NOT NULL,
    "toppings"  TEXT NOT NULL,
     FOREIGN KEY (pizza_id) REFERENCES pizza_names (pizza_id));
INSERT INTO pizza_recipes
( pizza_id, toppings )
VALUES
(1, '1, 2, 3, 4, 5, 6, 8, 10'),
(2, '4, 6, 7, 9, 11, 12'); 

 DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
    "topping_id" INTEGER NOT NULL, 
    "topping_name" TEXT NOT NULL,
    PRIMARY KEY (topping_id));

INSERT INTO pizza_toppings ("topping_id", "topping_name")
VALUES 
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce'); */




DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
    "order_id" INTEGER NOT NULL, 
    "customer_id" INTEGER NOT NULL,
    "pizza_id" INTEGER NOT NULL,
    "exclusions" VARCHAR (4) NOT NULL, 
    "extras" VARCHAR (4) NOT NULL, 
    "order_time" DATETIME NOT NULL,
    FOREIGN KEY (pizza_id) REFERENCES pizza_names(pizza_id)
      );
SET ansi_warnings OFF 
INSERT INTO customer_orders (
    "order_id", "customer_id", "pizza_id",
    "exclusions", "extras", "order_time")
VALUES 
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', 'null', '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49'); 

/* DROP TABLE IF EXISTS runners
CREATE TABLE runners (
    "runner_id" INTEGER NOT NULL, 
    "registration_date" DATE NOT NULL,
    PRIMARY KEY (runner_id));

INSERT INTO runners ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15'); */

DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER NOT NULL,
  "runner_id" INTEGER NOT NULL,
  "pickup_time" DATETIME NULL,
  "distance" DECIMAL (7,2),
  "duration" INTEGER NULL,
  "cancellation" VARCHAR(23),
  FOREIGN KEY (runner_id) REFERENCES runners(runner_id),
  );

INSERT INTO runner_orders (
  "order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20', '32', ''),
  ('2', '1', '2020-01-01 19:10:54', '20', '27', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4', '20', 'NULL'),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', 'NULL'),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', 'NULL'),
  ('6', '3', NULL, NULL, NULL, 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25', '25', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4', '15', 'null'),
  ('9', '2', NULL, NULL, NULL, 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10', '10', 'null');  

/* UPDATE runner_orders 
SET pickup_time = 'NULL'
WHERE order_id = 6 ; */