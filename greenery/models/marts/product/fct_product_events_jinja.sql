{{
  config(
    materialized='table'
  )
}}

{%- set event_types =  get_event_types() -%}

select 
  a.session_id, 
  a.product_id,
  prods.product_name,
  {%- for event_type in event_types %}
  sum(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_flag
  {%- if not loop.last %},{% endif -%}
  {% endfor %}
 from {{ ref ('greenery', 'stg_events') }} a
 left join {{ ref ('greenery', 'dim_products') }} prods
  on a.product_id = prods.product_id
 group by a.session_id, a.product_id, prods.product_name

--{% set event_types =["add_to_cart", "checkout", "package_shipped"] %}