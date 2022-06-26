-- This is a test to see how the star utility works.
select
{{ dbt_utils.star(from=ref('stg_orders'), except=["promo_id"]) }},
promos.*
from {{ ref('stg_orders') }} ords
inner join 
{{ ref('stg_promos') }} promos
on ords.promo_id = promos.promo_id

