use ecommercecustomers
select * from customers
select * from order_items
select * from orders
select * from products 
select * from sales_cleaned

--DATA CLEANING 
select sum(CASE when country is null then 1 else 0 end) as country_missing,
sum(CASE when signup_date is null then 1 else 0 end) as signupdate_missing 
from customers;

select sum(CASE when order_id is null then 1 else 0 end) as order_id_missing,
sum(CASE when product_id is null then 1 else 0 end) as  product_id_missing,
sum(CASE when quantity is null then 1 else 0 end) as quantity_missing,
sum(CASE when price is null then 1 else 0 end) as  price_missing
from order_items;

select sum(CASE when order_id is null then 1 else 0 end) as order_id_missing,
sum(CASE when customer_id is null then 1 else 0 end) as  customer_id_missing,
sum(CASE when order_date is null then 1 else 0 end) as order_date_missing,
sum(CASE when status is null then 1 else 0 end) as  status_missing
from orders;

select sum(CASE when product_name is null then 1 else 0 end) as product_name_missing,
sum(CASE when category is null then 1 else 0 end) as  category_missing
from products;

select sum(CASE when order_id is null then 1 else 0 end) as order_id_missing,
sum(CASE when product_id is null then 1 else 0 end) as product_id_missing,
sum(CASE when quantity is null then 1 else 0 end) as quantity_missing,
sum(CASE when price is null then 1 else 0 end) as price_missing,
sum(CASE when Revenue is null then 1 else 0 end) as revenue_missing,
sum(CASE when customer_id is null then 1 else 0 end) as customer_id_missing,
sum(CASE when order_date is null then 1 else 0 end) as order_date_missing,
sum(CASE when status is null then 1 else 0 end) as status_missing,
sum(CASE when year is null then 1 else 0 end) as year_missing,
sum(CASE when month is null then 1 else 0 end) as month_missing
from sales_cleaned;

--CHECK STATEMENT
SELECT quantity,price FROM sales_cleaned ORDER BY price desc;

--AGGREGATE FUNCTION(SUM,AVG.MAX.MIN,COUNT)
SELECT customer_id,
COUNT(*) AS total_count,
SUM(customer_id) AS total_amount,
AVG(customer_id) AS avg_amount,
MAX(customer_id) AS max_amount,
MIN(customer_id) AS min_amount
FROM orders
GROUP BY customer_id;

--OPERATORS(- =, >, <, AND, OR, BETWEEN, IN, LIKE)
SELECT * FROM order_items where price>300 AND quantity<=5;
SELECT * FROM sales_cleaned where price<300 AND status='Completed';
SELECT * FROM sales_cleaned where price<300 or status='Not Completed';
SELECT * FROM sales_cleaned where price between 100 and 200;
SELECT * FROM products where category NOT LIKE '%Body%';

--CLAUSE(WHERE,ORDER BY ,GROUP BY,HAVING,DISTINCT)
--ORDER BY
SELECT top 10 * FROM sales_cleaned ORDER BY price desc;
SELECT DISTINCT price FROM order_items;
--GROUP BY + ORDER BY
SELECT SUM(Revenue) as total_revenue,
COUNT(*) AS total FROM sales_cleaned
GROUP BY Revenue
ORDER BY total;
--HAVING
SELECT quantity,
SUM(Revenue) as total_revenue, 
COUNT(*) as total_count FROM sales_cleaned 
GROUP BY quantity
HAVING sum(Revenue) >100
ORDER BY total_revenue desc;

-- WINDOW FUNCTION
--PARTITION BY
--SUM,AVG,COUNT,MAX,MIN
select SUM(price) OVER(PARTITION BY price) as total_price,
AVG(price) OVER(PARTITION BY price) as avg_price,
MAX(price) OVER(PARTITION BY price) as max_price,
MIN(price) OVER(PARTITION BY price) as min_price,
COUNT(*) OVER(PARTITION BY price) as count_price
FROM order_items
ORDER BY price desc;

-- roll back 
begin transaction; 
delete from products where category='Hair';
select * from products;
rollback;

-- commit 
begin transaction;
update order_items set product_id=14 where price=108;
select * from order_items
commit;

--LAG()
-- Access of previous row 
SELECT price,Revenue,
LAG(Revenue) OVER(ORDER BY price) as previous_row_price
FROM sales_cleaned;

--LEAD()
--Access to the next row
SELECT price,Revenue,
Lead(Revenue) OVER(ORDER BY price) as next_row_price
FROM sales_cleaned;

--JOINS
--inner join
select c.customer_id,
o.quantity,o.order_id from customers c 
inner join order_items o
on c.customer_id=o.order_id;

-- left join
select c.customer_id ,
o.quantity,o.order_id from customers c 
left join order_items o
on c.customer_id=o.order_id;

--right join
select c.customer_id ,
o.quantity,o.order_id from customers c 
right join order_items o
on c.customer_id=o.order_id;

--full outerjoin 
select c.customer_id ,
o.quantity,o.order_id from customers c 
full outer join order_items o
on c.customer_id=o.order_id;

