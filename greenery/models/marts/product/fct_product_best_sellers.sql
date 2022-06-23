{{
  config(
    materialized='table'
  )
}}

--with 
--sales as(
--    SELECT * FROM {{ ref ('greenery', 'dim_products') }}
--)

SELECT 
*
FROM
{{ ref ('greenery', 'dim_products') }}
order by tot_quantity_sold desc
limit 10