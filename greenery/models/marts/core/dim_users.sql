{{
  config(
    materialized='table'
  )
}}

with 
ords as (SELECT * FROM {{ ref('greenery', 'stg_orders') }})
,
usrs as (SELECT * FROM {{ ref('greenery', 'stg_users') }})
,
addrs as (SELECT * FROM {{ ref('greenery', 'int_addresses') }})
, 
prefs as (SELECT * FROM {{ ref('greenery', 'int_preferred_carriers') }})

select 
  usrs.user_id customer_id
, usrs.first_name || ' ' || last_name customer_name
, usrs.email customer_email_address  
, usrs.phone_number customer_phone_number
, addrs.full_address
, prefs.preferred_shipping_service
from ords
inner join usrs 
  on ords.user_id = usrs.user_id
inner join addrs 
  on usrs.address_id = addrs.address_id
inner join prefs
  on usrs.user_id = prefs.user_id
group by usrs.user_id
, usrs.first_name
, usrs.last_name
, usrs.email
, usrs.phone_number
, addrs.full_address
, prefs.preferred_shipping_service