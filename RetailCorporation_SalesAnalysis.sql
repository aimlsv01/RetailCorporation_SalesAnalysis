-- Question 1: What is the date range between which orders were placed as per Dataset ?
SELECT
DATE(min(order_purchase_timestamp)) as FirstOrder_Date, 
DATE(max(order_purchase_timestamp)) as LastOrder_Date,
DATEDIFF(DATE(max(order_purchase_timestamp)),DATE(min(order_purchase_timestamp)))+1 as Total_NumofDays
FROM `retail corporation_sales`.orders;

-- Question 2 : What is the total number of distinct Cities and States from which Customers ordered during the given period?
SELECT
COUNT(DISTINCT customer_city) as NoofCities, 
COUNT(DISTINCT customer_state) as NoofStates
FROM `retail corporation_sales`.customers;

-- Question 3 : Is there a growing trend in the no. of orders placed over the past years?
SELECT
EXTRACT(YEAR FROM order_purchase_timestamp) as Order_Year,
EXTRACT(MONTH FROM order_purchase_timestamp) as Order_Month,
COUNT(Order_id) as NoofOrders
FROM `retail corporation_sales`.orders
GROUP BY Order_Year,Order_Month
ORDER BY Order_Year,Order_Month;

-- Question 4 :  Is there some kind of monthly seasonality in terms of the no. of orders being placed?
SELECT Month,order_count
FROM
(SELECT
DATE_FORMAT(order_purchase_timestamp, '%M') AS Month,
EXTRACT(MONTH from order_purchase_timestamp) as Month_num,
COUNT(order_id) as order_count
FROM `retail corporation_sales`.orders
GROUP BY Month,Month_num order by Month_num) as order_months;

-- Question 5: During what time of the day, do the Brazilian customers mostly place their orders? (Dawn, Morning, Afternoon or Night)
SELECT
CASE
WHEN EXTRACT(HOUR FROM order_purchase_timestamp) between 0 and 6 then "Dawn"
WHEN EXTRACT(HOUR FROM order_purchase_timestamp) between 7 and 12 then "Mornings"
WHEN EXTRACT(HOUR FROM order_purchase_timestamp) between 13 and 18 then "Afternoon"
WHEN EXTRACT(HOUR FROM order_purchase_timestamp) between 19 and 23 then "Night"
END as TimeoftheDay,
COUNT(order_id) as NoofOrders
FROM `retail corporation_sales`.orders
GROUP BY TimeoftheDay
ORDER BY
CASE TimeoftheDay
WHEN "Dawn" then 1
WHEN "Mornings" then 2
WHEN "Afternoon" then 3
WHEN "Night" then 4
END;

-- Question 6 : What is Yearwise,Monthly Sales for each Customer State
SELECT
EXTRACT(YEAR FROM order_purchase_timestamp) as Order_Year,
EXTRACT(MONTH FROM order_purchase_timestamp) as Order_Month,
customer_state, 
COUNT(Order_id) as NoofOrders
FROM `retail corporation_sales`.orders as ord JOIN `retail corporation_sales`.customers as cus
ON ord.customer_id=cus.customer_id
GROUP BY Order_Year,Order_Month,customer_state
ORDER BY Order_Year,Order_Month,customer_state;

 -- Question 7 : How are the customers distributed across all the states?
SELECT customer_state,
COUNT(distinct customer_id) as NumofCustomers
FROM `retail corporation_sales`.customers
GROUP BY customer_state
ORDER BY customer_state;

-- Question 8 : What are the top 10 and bottom 10 states based on num of customers ?
WITH Top10CustomerStates as (
     SELECT customer_state,
     COUNT(distinct customer_id) as NumofCustomers
     FROM `retail corporation_sales`.customers
     GROUP BY customer_state
     ORDER BY NumofCustomers DESC
     LIMIT 10
),
Bottom10CustomerStates as (
     SELECT customer_state,
     COUNT(distinct customer_id) as NumofCustomers
     FROM `retail corporation_sales`.customers
     GROUP BY customer_state
     ORDER BY NumofCustomers ASC
     LIMIT 10
)
SELECT * FROM Top10CustomerStates
UNION ALL
SELECT * FROM Bottom10CustomerStates;
	
-- Question 9 : What is % increase in the cost of orders from the year 2017 to 2018(include months between Jan to Aug only)?
SELECT *,
round(((costoforders_2018/costoforders_2017)-1)*100,2) as percent_increase FROM
(SELECT
round(sum(case when (EXTRACT(YEAR from order_purchase_timestamp)=2017 and EXTRACT(MONTH from
order_purchase_timestamp) between 1 and 8) then payment_value end),2) as costoforders_2017,
round(sum(case when (EXTRACT(YEAR from order_purchase_timestamp)=2018 and EXTRACT(MONTH from
order_purchase_timestamp) between 1 and 8) then payment_value end),2) as costoforders_2018
FROM `retail corporation_sales`.orders as o left join `retail corporation_sales`.payments p on o.order_id=p.order_id) as CostofOrders;

-- Question 10 : What are the Total values and Average values of order price for each state?
SELECT customer_state,round(sum(price),2) as Total_Price,round(avg(price),2) as Avg_Price
FROM  `retail corporation_sales`.customers as c join `retail corporation_sales`.orders as o
on c.customer_id = o.customer_id join `retail corporation_sales`.order_items as oi
on o.order_id=oi.order_id
GROUP BY customer_state
ORDER BY customer_state;

-- Question 11 : What are the Total values and Average values of order freight for each state?
SELECT customer_state,round(sum(freight_value),2) as TotalFreightValue,
round(avg(freight_value),2) as AvgFreightValue
FROM `retail corporation_sales`.customers as c join `retail corporation_sales`.orders  as o
on c.customer_id = o.customer_id join `retail corporation_sales`.order_items as oi
on o.order_id=oi.order_id
GROUP BY customer_state
ORDER BY customer_state

-- Question 12 : 






