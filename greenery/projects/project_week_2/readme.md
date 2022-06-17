**What is our repeat rate?**
Repeat rate: 0.7984 or about 80%

~~~sql
with order_number_summary as (
select 
  (sum(case when user_order_count >=2 then 1 else 0 end))::numeric total_customers_two_or_more_orders
, (count(distinct customer_id))::numeric total_customers
from
fact_user_orders)

select
  (total_customers_two_or_more_orders/total_customers)::numeric(10,4) repeat_rate
from order_number_summary
~~~

**What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?**

**Likely to purchase again:**
* customers who make purchases regularly (let's say every month)
* customers with several shipping addresses (maybe these are drop-ships or stores)
* customers who have been with us for a while and who keep making purchases (let's say they've been a customer for 5 or more years and they make at least 4 purchases a year)

**Not likely to purchase again:**
* customers who have only had one order or customers who have only had one order and used a promo
* customers who have not placed an order in a while (let's say 1 year)
* customers who made a complaint or cancelled and order and have not placed any orders since
* customers who only buy one product or certain products, and these are products we no longer sell
* customers who bought items that we've had complaints on from other customers

**Additional features to look into:**
* inventory history (product id, dates stocked, date of last PO, active/inactive indicator, velocity, etc.)
* customer complaints (date of complaint, type, resolution, credit amount, order number,  product id, etc.)
* aggregate of customer sales, possibly with a tier system (customer, tier number, total gross sales, total years, average orders per year)
- aggregate of shipping information per customer (preferred carrier, preferred service, ship to address ids)

**Marts**
- *core/intermediate/dim_addresses.sql* - Added for easy look up of customer addresses formatted nicely.
- *core/intermediate/dim_preferred_carriers.sql* - listing of each customer's preferred carrier. Would be good to have for diving into delivery times/troubleshooting issues with carriers, or maybe offering customer promotions based on carrier.
- *core/dim_users.sql* - aggregate customer information based on what are likely to be the commonly-used fields. Incorporates various intermediate models.
- *marketing/fact_user_orders.sql* - fact model showing summarized customer order information.
- *product/intermediate/fact_product_best_sellers.sql* - a listing of the top 10 best selling items based on sales. I could imagine this being used for offering promotions, driving purchase orders, anticipating customer needs, etc.
- *product/intermediate/fact_product_sales.sql* - historical sales per product. if we had more data, it would make sense to filter by time frame, say, the last year. if we had price per line item, we could find out the average price we are charging for each product, including promos.

**Testing**

**Description of tests**
* Testing all primary keys for uniqueness and not null.
* Added surrogate key for stg_order_items, so that the composite key (order_id plus product_id) for this table can be tested 
* Added test that created_at is before the current timestamp for the following tables: stg_events, stg_orders
* Added referential integrity check on stg_users.address_id to make sure the value exists in stg_addresses.address_id
* Added referential integrity check on stg_orders.address_id, stg_orders.user_id, stg_orders.promo_id to ensure these are valid values
* Added referential integrity check on stg_orders_items.order_id
* Added referential integrity check on stg_events.order_id
* Tested valid values for stg_promos.status

* All tests passed

* To ensure tests are passing, we could schedule dbt build to run daily and set up alerts into a Slack channel to notify us of any failures.