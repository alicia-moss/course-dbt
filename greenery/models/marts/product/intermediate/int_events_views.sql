{{
  config(
    materialized='table'
  )
}}

select * from {{ ref('greenery','stg_events') }} page_events
where event_type = 'page_view'