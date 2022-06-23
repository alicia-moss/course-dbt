**Part 1: Questions**
**What is our overall conversion rate?**

overall conversion rate: 	
0.84520123839009287926
or 
roughly 85%
~~~sql
with all_events as(
select 
 session_id, 
 case when exists
  (select 'x' from stg_events b where
   a.session_id = b.session_id and
   event_type = 'checkout') then 1 else 0 end has_purchase_event
 from stg_events a
),
session_summary as(
select 
sum(has_purchase_event)::numeric tot_purchase_sessions,
(count (*))::numeric tot_sessions
from all_events)

select (tot_purchase_sessions/tot_sessions) conversion_rate from session_summary
~~~

**What is our conversion rate by product?**

~~~sql
select 
product_id,
sum(purchased_flag)::numeric/count(distinct session_id)::numeric conversion_rate
from fct_product_events
group by product_id;
~~~

*NOTE: conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product*

**Why might certain products be converting at higher/lower rates than others?**
Factors that might contribute to this:
* Item is priced too high
* Item is out of stock/consistently low on stock
* Another similar item is part of a promo
* This particular plant needs special care/is difficult to grow
* Maybe plants that sell at higher rates are ones that grow well in the environments where most of our customers are.

**Part 2: Macros**
**Create a macro to simplify part of a model**
See model fct_product_events_jinja and macro get_event_types
This still is not exactly what I want, as my fct_product_events aggregates the data by session per page view event. I don't want the data by row. I want it by session and product. Still unclear how to do this using a macro, since the data I want is in different rows.

**Part 3: Hooks**
**Grant the role usage access on schema**
**Use grant macro example (change syntax to posgres)**

**Part 4: Packages**
**Install and use a package**

**Part 5: Display**
**Show (using dbt docs and the model DAGs) how you have simplified or improved a DAG using macros and/or dbt packages.**