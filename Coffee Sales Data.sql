use coffee_sales;

select * from coffee_data;
describe coffee_data;

update coffee_data set transaction_date = str_to_date(transaction_date,'%d-%m-%Y');
alter table coffee_data modify column transaction_date date;

update coffee_data set transaction_time = str_to_date(transaction_time,'%H:%i:%s');
alter table coffee_data modify column transaction_time time;

select concat(round(sum(unit_price*transaction_qty)/1000,1),'K') as Total_Sales
from coffee_data
where month(transaction_date)=5;

select month(transaction_date) as month,
	   round(sum(unit_price*transaction_qty)) as Total_Sales,
       (sum(unit_price*transaction_qty)-lag(sum(unit_price*transaction_qty),1)
       over(order by month(transaction_date)))/lag(sum(unit_price*transaction_qty),1)
       over(order by month(transaction_date))*100 as mom_percantage
from coffee_data
where month(transaction_date) in (4,5)
group by month(transaction_date)
order by month(transaction_date);

select count(transaction_id) as Total_Orders
from coffee_data
where month(transaction_date)=5;

select month(transaction_date) as month,
	   count(transaction_id) as Total_Orders,
       (count(transaction_id)-lag(count(transaction_id),1)
       over(order by month(transaction_date)))/lag(count(transaction_id),1)
       over(order by month(transaction_date))*100 as mom_order_percantage
from coffee_data
where month(transaction_date) in (4,5)
group by month(transaction_date)
order by month(transaction_date);

select sum(transaction_qty) as Total_qty
from coffee_data
where month(transaction_date)=5;

select month(transaction_date) as month,
	   sum(transaction_qty) as Total_qty,
       (sum(transaction_qty)-lag(sum(transaction_qty),1)
       over(order by month(transaction_date)))/lag(sum(transaction_qty),1)
       over(order by month(transaction_date))*100 as mom_qty_percantage
from coffee_data
where month(transaction_date) in (4,5)
group by month(transaction_date)
order by month(transaction_date);

/*Calender*/

select concat(round(sum(unit_price*transaction_qty)/1000,1),'K') as Total_Sales,
	   sum(transaction_qty) as Total_Qty,
       count(transaction_id) as Total_Orders
from coffee_data
where transaction_date='2023-05-18';


select
case when dayofweek(transaction_date) in(1,7) then 'Weekends'
else 'Weekdays'
end as day_type,
round(sum(unit_price*transaction_qty),1) as Total_Sales
from coffee_data
where month(transaction_date)=5
group by day_type;

select store_location,
	   round(sum(unit_price*transaction_qty),1) as Total_Sales
from coffee_data
where month(transaction_date)=5
group by store_location
order by Total_Sales desc;

select concat(round(avg(Total_Sales)/1000,1),'K') as Average_Sales
from ( select round(sum(unit_price*transaction_qty),1) as Total_Sales
	   from coffee_data
	   where month(transaction_date)=5
       group by transaction_date
	  ) as internal_query;
      
select day(transaction_date) as 'Day',
	   round(sum(unit_price*transaction_qty),1)
from coffee_data
where month(transaction_date)=5
group by day(transaction_date)
order by day(transaction_date);

SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_data
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

select product_category,
	   round(sum(unit_price*transaction_qty),1) as Total_Sales
from coffee_data
where month(transaction_date)=5
group by product_category
order by Total_Sales;

select product_type,
	   round(sum(unit_price*transaction_qty),1) as Total_Sales
from coffee_data
where month(transaction_date)=5 and product_category='Coffee'
group by product_type
order by Total_Sales desc
limit 10;

SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_data
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5)

SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_data
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_data
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;