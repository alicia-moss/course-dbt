{{
  config(
    materialized='table'
  )
}}

select 
  a.session_id, 
  a.product_id,
  prods.product_name,
  case when exists
    (select 'x' from {{ ref ('greenery', 'stg_events') }} b where
    a.session_id = b.session_id and
    a.product_id = b.product_id and
    b.event_type = 'add_to_cart') then 1 else 0 end cart_flag, 
  case when exists
    (select 'x' from  {{ ref ('greenery', 'stg_events') }} c where
    a.session_id = c.session_id and
    c.event_type = 'checkout') then 1 else 0 end purchased_flag,
  case when exists
    (select 'x' from  {{ ref ('greenery', 'stg_events') }} d where
    a.session_id = d.session_id and
    d.event_type = 'package_shipped') then 1 else 0 end shipped_flag,   
  (select min(event_id)  from {{ ref ('greenery', 'stg_events') }} e where
    a.session_id = e.session_id  and
    a.product_id = e.product_id
    and e.event_type = 'add_to_cart' ) cart_event_id,   
  (select event_id  from {{ ref ('greenery', 'stg_events') }} f where
    a.session_id = f.session_id  
    and f.event_type = 'checkout' ) checkout_event_id
 from {{ ref ('greenery', 'stg_events') }} a
 inner join {{ ref ('greenery', 'dim_products') }} prods
  on a.product_id = prods.product_id
 where 
  a.event_type = 'page_view' and
  a.product_id is not null
 group by a.session_id, a.product_id, prods.product_name
