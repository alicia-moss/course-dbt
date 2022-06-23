{{
  config(
    materialized='table'
  )
}}

with 
ords as (SELECT * FROM {{ ref('greenery', 'stg_orders') }})
,
user_carrier_prefs as (
select user_id, coalesce(shipping_service,'No preference') shipping_service, count(*) tot_ords
  from ords a
  group by user_id, shipping_service
  )
,
user_carrier_prefs_ranked AS (
  select user_id, shipping_service,
  row_number() over (partition by user_id order by tot_ords) rowNo
  from user_carrier_prefs b 
  where tot_ords = (select max(tot_ords) from user_carrier_prefs a where a.user_id = b.user_id )
  )

select user_id, shipping_service preferred_shipping_service 
from user_carrier_prefs_ranked 
where rowNo = 1