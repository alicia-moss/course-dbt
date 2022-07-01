{{
  config(
    materialized='table'
  )
}}

with event_totals as (
select
    (select count(distinct session_id) from {{ref('greenery','stg_events')}})::numeric tot_events,
    (select count(distinct session_id) from {{ref('greenery','int_events_views')}})::numeric tot_views,
    (select count(distinct session_id) from {{ref('greenery','int_events_carts')}})::numeric tot_carts,
    (select count(distinct session_id) from {{ref('greenery','int_events_checkouts')}})::numeric tot_checkouts
)
 
 select 
   ((tot_views+tot_carts+tot_checkouts)/ tot_events) funnel_level_3, 
   ((tot_carts+tot_checkouts)/ tot_events) funnel_level_2, 
   ((tot_checkouts)/ tot_events) funnel_level_1
 from event_totals