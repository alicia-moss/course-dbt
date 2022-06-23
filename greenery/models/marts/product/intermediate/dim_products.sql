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
--,
--ord_lines as (
--    SELECT * FROM 
--)

select
  prods.product_id
, prods.name product_name
, prods.price
, prods.inventory
, coalesce((select sum(ord_lines.quantity) from {{ ref ('greenery', 'stg_order_items') }} ord_lines where prods.product_id = ord_lines.product_id),0) tot_quantity_sold
from prods
GROUP BY
  prods.product_id
, prods.name
, prods.price
, prods.inventory

-- inner join ords on ord_lines.order_id = ords.order_id
--where ords.created_at >= current_date - 365
-- if we had more recent data, it would make sense to limit by date.
-- would also like to see: average price per product based on the line price (including promos, etc.)

