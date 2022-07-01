{{
  config(
    materialized='table'
  )
}}

-- i'm aware there is a more elegant way to do this using case statements. 
-- choosing this option because i think it's valuable to have the different types of events
-- divided up into different intermediate models.
with event_totals as (
select
    (select count(distinct session_id) from {{ref('greenery','stg_events')}})::numeric tot_events,
    (select count(distinct session_id) from {{ref('greenery','int_events_views')}})::numeric tot_views,
    (select count(distinct session_id) from {{ref('greenery','int_events_carts')}})::numeric tot_carts,
    (select count(distinct session_id) from {{ref('greenery','int_events_checkouts')}})::numeric tot_checkouts
)
 
 select 
  tot_events,
   round((tot_views/ tot_events)*100,2) funnel_level_view, 
   round((tot_carts/ tot_events)*100,2) funnel_level_cart, 
   round((tot_checkouts/ tot_events)*100,2) funnel_level_checkout
 from event_totals