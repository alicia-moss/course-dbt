{{
  config(
    materialized='table'
  )
}}

select 
checkout_events.session_id,
checkout_events.order_id,
cart_events.product_id
from {{ ref('greenery', 'stg_orders') }} ords
inner join {{ ref('greenery', 'stg_events') }} checkout_events
on ords.order_id = checkout_events.order_id
and checkout_events.event_type = 'checkout'
inner join {{ ref('greenery', 'stg_events') }} cart_events
on checkout_events.session_id = cart_events.session_id
where cart_events.event_type = 'add_to_cart'
group by 
checkout_events.session_id,
checkout_events.order_id,
cart_events.product_id
