{{
  config(
    materialized='table'
  )
}}

with 
sales as(
    SELECT * FROM {{ ref ('greenery', 'fact_product_sales') }}
)

SELECT 
*
FROM
sales
order by tot_quantity_sold desc
limit 10