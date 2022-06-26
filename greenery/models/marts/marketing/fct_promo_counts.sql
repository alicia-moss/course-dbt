select
promo_id, discount, promo_status, 
(select count(*) 
 from {{ref('stg_orders')}} ords 
 where ords.promo_id = promos.promo_id
 ) order_count
from
{{ ref('stg_promos') }} promos


