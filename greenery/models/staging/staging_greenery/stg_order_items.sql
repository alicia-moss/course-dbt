{{
  config(
    materialized='view'
  )
}}

SELECT
order_id, 
product_id, 
order_id || product_id AS surrogate_key,
quantity
FROM  {{ source('greenery', 'order_items') }}