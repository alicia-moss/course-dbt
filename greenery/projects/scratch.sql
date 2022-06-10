SELECT count(*) FROM stg_users;
-- 130 total users

select * from stg_orders;
--361

select extract(hour from created_at) distinct_hour, count(*)
from stg_orders
group by distinct_hour
order by distinct_hour;

select count(*)/24
from stg_orders;
-- 15 orders per hour on average

select (delivered_at - created_at) time_to_delivery, count(*) tot_deliveries from stg_orders
where delivered_at is not null
group by time_to_delivery;
-- from 1 to 7 days

--select a.order_tots
--FROM
--(
select user_id, 
case when count(*) = 1 then 'one order'
when count(*) = 2 then 'two orders'
when count(*) >= 3 then 'three or more orders' 
end order_tots
from stg_orders  
group by user_id;
--) a;
--group by a.order_tots;