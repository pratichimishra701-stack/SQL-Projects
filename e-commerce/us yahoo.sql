use yahoo
select * from [dbo].[udemy_output_All_Finance__Accounting_p1_p626];

--DATA CLEANING
SELECT
SUM(CASE when avg_rating is null then 1 else 0 end) as avg_rating_missing,
SUM(CASE when avg_rating_recent is null then 1 else 0 end) as recent_avg_missing,
SUM(CASE when rating is null then 1 else 0 end) as rating_missing,
SUM(CASE when price_detail_amount is null then 1 else 0 end) as price_amount_missing,
SUM(CASE when price_detail_currency is null then 1 else 0 end) as price_currency_missing,
SUM(CASE when price_detail_price_string is null then 1 else 0 end) as price_amount_missing
FROM udemy_output_All_Finance__Accounting_p1_p626;

--CHECK STATEMENT
SELECT num_published_lectures,discount_price_amount,rating FROM udemy_output_All_Finance__Accounting_p1_p626
ORDER BY num_published_lectures desc;

--TRIM space
--LTRIM and RTRIM
SELECT TRIM(title) as clean_title,
TRIM(url) as clean_url FROM udemy_output_All_Finance__Accounting_p1_p626 ;

--UPDATE
-- if num_published_lectures >100 then 'True', if  discount_price_amount >500 then 'False' else 'Null'. (Use CASE)
UPDATE udemy_output_All_Finance__Accounting_p1_p626 set is_wishlisted =
CASE 
  WHEN num_published_lectures >100 THEN 'True'
  WHEN discount_price_amount >500 THEN 'False'
  ELSE 'null'
END;
select * from [dbo].[udemy_output_All_Finance__Accounting_p1_p626];

--CHECK STATEMENT
SELECT num_subscribers,num_reviews FROM udemy_output_All_Finance__Accounting_p1_p626 ORDER BY num_subscribers desc;

--AGGREGATE FUNCTION(SUM,AVG.MAX.MIN,COUNT)
select num_subscribers,
count(*) AS total_count,
SUM( num_subscribers) as total_num_subscribers,
AVG( num_subscribers) as avg_num_subscribers,
MAX( num_subscribers) as max_num_subscribers,
MIN( num_subscribers) as min_num_subscribers
FROM udemy_output_All_Finance__Accounting_p1_p626 
GROUP BY  num_subscribers;

--OPERATORS(- =, >, <, AND, OR, BETWEEN, IN, LIKE)
SELECT * FROM udemy_output_All_Finance__Accounting_p1_p626 where num_reviews >3000 AND is_wishlisted='True';
SELECT * FROM udemy_output_All_Finance__Accounting_p1_p626 where is_wishlisted ='null' AND price_detail_amount >300;
SELECT top 10 * FROm udemy_output_All_Finance__Accounting_p1_p626 where price_detail_currency ='INR' OR is_paid='False';
SELECT * FROM udemy_output_All_Finance__Accounting_p1_p626 where is_paid NOT LIKE '%True%';

--ORDER BY
--Show all transactions ordered by date newest first.
SELECT top 10 * FROM udemy_output_All_Finance__Accounting_p1_p626;

--GROUP BY + ORDER BY
SELECT SUM(discount_price_price_string) as discount_price_amount,
COUNT(*) AS total_transactions FROM udemy_output_All_Finance__Accounting_p1_p626
 GROUP BY discount_price_price_string
ORDER BY discount_price_amount;

--HAVING
--Find categories where num reviews > 6000.
SELECT num_published_lectures,
SUM(num_reviews) as total_num_reviews, 
COUNT(*) as total_count FROM udemy_output_All_Finance__Accounting_p1_p626  
GROUP BY num_published_lectures
HAVING sum(num_reviews) >6000
ORDER BY total_num_reviews desc;
select * from udemy_output_All_Finance__Accounting_p1_p626 ;

--Subquery with IN
-- Find all transactions of vendors who have at least one fraud case.
SELECT * FROM udemy_output_All_Finance__Accounting_p1_p626 
WHERE num_subscribers IN (SELECT DISTINCT num_subscribers FROM udemy_output_All_Finance__Accounting_p1_p626
WHERE num_published_practice_tests =2)
ORDER BY num_subscribers;

--DISTINCT (subquery)
SELECT DISTINCT num_subscribers FROM udemy_output_All_Finance__Accounting_p1_p626 where num_subscribers not IN (
SELECT DISTINCT num_subscribers FROM udemy_output_All_Finance__Accounting_p1_p626  WHERE num_reviews =1
);

-- WINDOW FUNCTION
--PARTITION BY
--SUM,AVG,COUNT,MAX,MIN
SELECT top 10 num_subscribers,num_reviews,
SUM(num_reviews) OVER(PARTITION BY num_subscribers ) as total_subscribers,
AVG(num_reviews) OVER(PARTITION BY num_subscribers) as avg_subscribers,
MAX(num_reviews) OVER(PARTITION BY num_subscribers) as max_subscribers,
MIN(num_reviews) OVER(PARTITION BY num_subscribers) as min_subscribers,
COUNT(*) OVER(PARTITION BY num_subscribers) as count_subscribers
FROM udemy_output_All_Finance__Accounting_p1_p626
ORDER BY num_reviews desc;
select* from udemy_output_All_Finance__Accounting_p1_p626

--ROW_NUMBER()
SELECT num_subscribers,num_reviews,ROW_NUMBER() OVER(ORDER BY num_subscribers desc) as row_num
FROM udemy_output_All_Finance__Accounting_p1_p626;

--RANK()
SELECT num_subscribers,num_reviews,Rank() OVER(ORDER BY num_subscribers desc) as rank_num
FROM udemy_output_All_Finance__Accounting_p1_p626;

--LAG()
-- Access of previous row 
SELECT discount_price_amount,price_detail_amount,
LAG(price_detail_amount) OVER(ORDER BY discount_price_amount) as previous_row_amount
FROM udemy_output_All_Finance__Accounting_p1_p626;

--LEAD()
--Access to the next row
SELECT discount_price_amount,price_detail_amount,
Lead (price_detail_amount) OVER(ORDER BY discount_price_amount) as next_row_amount
FROM udemy_output_All_Finance__Accounting_p1_p626;

--VIEW(to save the data)
CREATE VIEW high_rated_courses AS 
SELECT * 
FROM udemy_output_All_Finance__Accounting_p1_p626 
WHERE num_reviews > 2000;

SELECT * FROM high_rated_courses WHERE is_wishlisted='null';

--VIEW WITH Aggerage + GROUP BY + ORDER BY
create view price_summary as
SELECT discount_price_amount,
SUM(price_detail_amount) as total_amount,
AVG(price_detail_amount) as avg_amount,
MAX(price_detail_amount) as max_amount,
COUNT(*) as total_count
FROM udemy_output_All_Finance__Accounting_p1_p626 
GROUP BY discount_price_amount;

SELECT * FROM price_summary ORDER BY total_amount desc;

--INDEXING
CREATE INDEX idx_cat ON udemy_output_All_Finance__Accounting_p1_p626 (discount_price_currency);

SELECT top 10 * FROM udemy_output_All_Finance__Accounting_p1_p626  WHERE discount_price_currency = 'DOLLAR';

--CTE(comman table express)
--it is a temproary named table result that set  makes complicated query easy to read
WITH id_total as(
SELECT  top 3 id, SUM(num_reviews) as total_id FROM udemy_output_All_Finance__Accounting_p1_p626
WHERE num_published_practice_tests =1 
GROUP BY id)
SELECT id, total_id FROM id_total
ORDER BY total_id desc;

