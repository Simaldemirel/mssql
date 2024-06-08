 

-- --CREATE TABLE FLO (
--	master_id							VARCHAR(50),
--	order_channel						VARCHAR(50),
--	last_order_channel					VARCHAR(50),
--	first_order_date					DATE,
--	last_order_date						DATE,
--	last_order_date_online				DATE,
--	last_order_date_offline				DATE,
--	order_num_total_ever_online			INT,
--	order_num_total_ever_offline		INT,
--	customer_value_total_ever_offline	FLOAT,
--	customer_value_total_ever_online	FLOAT,
--	interested_in_categories_12			VARCHAR(50),
--	store_type							VARCHAR(10)
--);
 
 
 -- 1-) Write the query that shows how many different customers made purchases.

	SELECT COUNT(DISTINCT(master_id)) dýstýnct_customer
	from FLO

	-- 2-) Write the query that will return the total number of purchases and turnover.

SELECT 
	SUM(order_num_total_ever_offline + order_num_total_ever_online) AS PURCHASE,
	ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online), 2) AS TURNOVER
from FLO

-- 3-) Write the query that will return the average turnover per purchase.

SELECT  
SUM(order_num_total_ever_online+order_num_total_ever_offline) PURCHASE,
	ROUND((SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / 
	SUM(order_num_total_ever_online+order_num_total_ever_offline) 
	), 2) AS AVG_TURNOVER
 FROM FLO

 
 --4-) Total turnover and the number of purchases made through the last shopping channel (last_order_channel)
--Write the query that will return it.

 SELECT  last_order_channel ,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) TOTALTURNOVER,
SUM(order_num_total_ever_online+order_num_total_ever_offline) TOTALPURCHASE
FROM FLO
GROUP BY  last_order_channel



-- 5-) Write the query that returns the total turnover obtained in the Store type breakdown.

SELECT store_type , 
       ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online), 2) TOTALTURNOVER
FROM FLO 
GROUP BY store_type;

-- 6-) Write the query that will return the number of purchases in the year breakdown (Base the year on the customer's first purchase date (first_order_date).
 
SELECT 
YEAR(first_order_date) YEAR,  SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALPURCHASE
FROM  FLO
GROUP BY YEAR(first_order_date)


-- 7-) Write the query that will calculate the average turnover per purchase in the last shopping channel breakdown.

SELECT last_order_channel, 
       ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online),2) TOTALTURNOVER,
	   SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALPURCHASE,
       ROUND(SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / SUM(order_num_total_ever_offline + order_num_total_ever_online),2) AS AVERAGE 
FROM FLO
GROUP BY last_order_channel;

-- 8-) Write the query that returns the most popular category in the last 12 months.


SELECT TOP 1 interested_in_categories_12, COUNT(*) interest_count
FROM FLO
GROUP BY interested_in_categories_12
ORDER BY 2 DESC;

-- 9-) Write the query that returns the most preferred store_type information.

SELECT TOP 1 store_type, COUNT(*) store_type_count
FROM FLO
GROUP BY store_type


-- 10-) Based on the last shopping channel (last_order_channel), write a query that returns the most popular category and how much shopping was done from this category.

SELECT DISTINCT last_order_channel,
(
	SELECT top 1 interested_in_categories_12
	FROM FLO  WHERE last_order_channel=f.last_order_channel
	group by interested_in_categories_12
	order by 
	SUM(order_num_total_ever_online+order_num_total_ever_offline) desc 
),
(
	SELECT top 1 SUM(order_num_total_ever_online+order_num_total_ever_offline)
	FROM FLO  WHERE last_order_channel=f.last_order_channel
	group by interested_in_categories_12
	order by 
	SUM(order_num_total_ever_online+order_num_total_ever_offline) desc 
)
FROM FLO F

-- 11-) Write the query that returns the ID of the person who makes the most purchases.

 SELECT TOP 1 master_id   		    
	FROM FLO 
	GROUP BY master_id 
ORDER BY  SUM(customer_value_total_ever_offline + customer_value_total_ever_online)    DESC 

--12-) Write the query that returns the average turnover per purchase of the person who shops the most and the average shopping day (shopping frequency).

SELECT D.master_id,ROUND((D.TOTALTURNOVER / D.TOTALORDER),2) AVG_PER_ORDER,
ROUND((DATEDIFF(DAY, first_order_date, last_order_date)/D.TOTALORDER ),1) SHOPPING_DAY_AVG
FROM
(
SELECT TOP 1 master_id, first_order_date, last_order_date,
		   SUM(customer_value_total_ever_offline + customer_value_total_ever_online) TOTALTURNOVER,
		   SUM(order_num_total_ever_offline + order_num_total_ever_online) TOTALORDER
	FROM FLO 
	GROUP BY master_id,first_order_date, last_order_date
ORDER BY TOTALTURNOVER DESC
) D

-- 13-) Query that returns the average shopping day (shopping frequency) of the top 100 people who shop the most (on a turnover basis)
--write.

SELECT  
D.master_id,
       D.TOPLAM_CIRO,
	   D.TOPLAM_SIPARIS_SAYISI,
       ROUND((D.TOPLAM_CIRO / D.TOPLAM_SIPARIS_SAYISI),2) SIPARIS_BASINA_ORTALAMA,
	   DATEDIFF(DAY, first_order_date, last_order_date) ILK_SN_ALVRS_GUN_FRK,
	  ROUND((DATEDIFF(DAY, first_order_date, last_order_date)/D.TOPLAM_SIPARIS_SAYISI ),1) ALISVERIS_GUN_ORT	 
  FROM
(
SELECT TOP 100 master_id, first_order_date, last_order_date,
		   SUM(customer_value_total_ever_offline + customer_value_total_ever_online) TOPLAM_CIRO,
		   SUM(order_num_total_ever_offline + order_num_total_ever_online) TOPLAM_SIPARIS_SAYISI
	FROM FLO 
	GROUP BY master_id,first_order_date, last_order_date
ORDER BY TOPLAM_CIRO DESC
) D


--14-) Write the query that returns the customer who made the most purchases in the last order channel breakdown.

SELECT  
D.master_id,
       D.TOPLAM_CIRO,
	   D.TOPLAM_SIPARIS_SAYISI,
       ROUND((D.TOPLAM_CIRO / D.TOPLAM_SIPARIS_SAYISI),2) SIPARIS_BASINA_ORTALAMA,
	   DATEDIFF(DAY, first_order_date, last_order_date) ILK_SN_ALVRS_GUN_FRK,
	  ROUND((DATEDIFF(DAY, first_order_date, last_order_date)/D.TOPLAM_SIPARIS_SAYISI ),1) ALISVERIS_GUN_ORT	 
  FROM
(
SELECT TOP 100 master_id, first_order_date, last_order_date,
		   SUM(customer_value_total_ever_offline + customer_value_total_ever_online) TOPLAM_CIRO,
		   SUM(order_num_total_ever_offline + order_num_total_ever_online) TOPLAM_SIPARIS_SAYISI
	FROM FLO 
	GROUP BY master_id,first_order_date, last_order_date
ORDER BY TOPLAM_CIRO DESC
) D

--15-) Write the query that returns the ID of the last person who shopped. (There is more than one shopper ID on the max deadline.
--Bring these too.)

SELECT DISTINCT last_order_channel,
(
	SELECT top 1 master_id
	FROM FLO  WHERE last_order_channel=f.last_order_channel
	group by master_id
	order by 
	SUM(customer_value_total_ever_offline+customer_value_total_ever_online) desc 
) EN_COK_ALISVERIS_YAPAN_MUSTERI,
(
	SELECT top 1 SUM(customer_value_total_ever_offline+customer_value_total_ever_online)
	FROM FLO  WHERE last_order_channel=f.last_order_channel
	group by master_id
	order by 
	SUM(customer_value_total_ever_offline+customer_value_total_ever_online) desc 
) CIRO
FROM FLO F

































































	





























