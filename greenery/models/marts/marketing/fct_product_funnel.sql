{{
  config(
    materialized='table'
  )
}}

-- well... this does not seem exactly right.
with product_event_totals as(
    select product_id, count(distinct session_id)::numeric tot_events 
    from {{ref('greenery','stg_events')}}
    group by product_id),

    product_event_views as
    (select product_id, count(distinct session_id)::numeric tot_views 
    from {{ref('greenery','fct_product_events')}}
    group by product_id),

    product_event_carts as 
    (select product_id, count(distinct session_id)::numeric tot_carts 
    from {{ref('greenery','fct_product_events')}}
    where cart_flag = 1
    group by product_id),

    product_event_checkouts as
    (select product_id, count(distinct session_id)::numeric tot_checkouts 
     from {{ref('greenery','fct_product_events')}}
     where purchased_flag = 1
     group by product_id)
 
 select 
  tots.product_id,
   sum(coalesce((tot_views+tot_carts+tot_checkouts),0)/ tot_events) funnel_level_3, 
   sum(coalesce((tot_carts+tot_checkouts),0/ tot_events)) funnel_level_2, 
   sum(coalesce((tot_checkouts),0/ tot_events)) funnel_level_1
 from 
 product_event_totals tots left join
 product_event_views views on tots.product_id = views.product_id left join
 product_event_carts carts on tots.product_id = carts.product_id left join
 product_event_checkouts checkouts on tots.product_id = checkouts.product_id
 group by tots.product_id