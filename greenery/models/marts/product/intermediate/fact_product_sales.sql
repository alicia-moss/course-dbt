{{
  config(
    materialized='table'
  )
}}

with 
prods as(
    SELECT * FROM {{ ref ('greenery', 'stg_products') }}
)
--,
--ords as (
--    SELECT * FROM {{ ref ('greenery', 'stg_orders') }}
--)
,
ord_lines as (
    SELECT * FROM {{ ref ('greenery', 'stg_order_items') }}
)

select
  prods.product_id
, prods.name
, prods.price
, prods.inventory
, sum(ord_lines.quantity) tot_quantity_sold
from prods
inner join ord_lines on prods.product_id = ord_lines.product_id
GROUP BY
  prods.product_id
, prods.name
, prods.price
, prods.inventory


-- inner join ords on ord_lines.order_id = ords.order_id
--where ords.created_at >= current_date - 365
-- if we had more recent data, it would make sense to limit by date.
-- would also like to see: average price per product based on the line price (including promos, etc.)

