Select *
From [dbo].[df_orders]
--find top 10 highest reveue generating products 
Select top 10 df_orders.product_id,sum(df_orders.quantity)
From [dbo].[df_orders]
group by df_orders.product_id
order by sum(df_orders.quantity) Desc
--find top 5 highest selling products in each region
select *
from (
	Select df_orders.region,
		df_orders.product_id,
		sum(df_orders.quantity) as 'sell',
		ROW_NUMBER() over(partition by df_orders.region order by sum(df_orders.quantity) desc) as 'dem'
	From [dbo].[df_orders]
	group by df_orders.region,df_orders.product_id ) A
where dem<=5

--for each category which month had highest sales
select *
from (
	select MONTH(order_date) as 'Month',
		category,
		sum(sale_price) as 'total sale',
		row_number() over(partition by MONTH(order_date) order by sum(sale_price) DESC ) as 'dem'
	from [dbo].[df_orders]
	group by MONTH(order_date),category ) A
where dem=1
--which sub category had highest growth by profit in 2023 compare to 2022
select top 1 * 
from (
	Select sub_category,
		sum( case when year(order_date)=2022 then sale_price else 0 end) as 'Nam 2022',
		sum( case when year(order_date)=2023 then sale_price else 0 end) as 'Nam 2023'
	From [dbo].[df_orders]
	Group by sub_category ) A
order by [Nam 2023]-[Nam 2022] desc

CREATE VIEW view_orders as
select *
from [dbo].[df_orders]