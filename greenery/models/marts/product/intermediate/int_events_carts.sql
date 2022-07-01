{{
  config(
    materialized='table'
  )
}}

select page_events.* 

from {{ ref('greenery','stg_events') }} page_events
where event_type = 'add_to_cart'