{{
  config(
    materialized='table'
  )
}}

with addrs as(
SELECT
*
FROM  {{ ref('greenery', 'stg_addresses') }})

select 
address_id, 
(address || ', '  || state || ', ' || zipcode || ', ' || country) full_address
from
addrs

