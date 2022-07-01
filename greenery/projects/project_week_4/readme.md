**Part 1: Snapshots**
Created snapshot of orders source table.
~~~sql
SELECT * FROM snapshots.orders_snapshot
where order_id in ('914b8929-e04a-40f8-86ee-357f2be3a2a2','05202733-0e17-4726-97c2-0520c024ab85')
~~~

**Part 2: Modeling**
**Product Funnel Questions:**
* How are our users moving through the product funnel?
* Which steps in the funnel have largest drop off points?

see: fct_event_funnel model

**Exposure**
Use an exposure on your product analytics model to represent that this is being used in downstream BI tools. Please reference the course content if you have questions.

see: exposures.yml

**Part 3: Reflections**
3B (Production Run): 
DBT Cloud will likely be sufficient for our purposes. Several colleagues and myself did the dbt fundamentals class, so we have some familiarity with this tool already.
The deployment would run daily before working hours and would be dependent on source data getting refreshed prior to kicking off.
Steps in a scheduled dbt run:
* dbt source freshness (remaining steps will not be triggered if data does not pass freshness standards)
* load source metadata to S3 (sources.json)
* run models
* load run metadata into S3 (run_results.json)
* run tests
* load test metadata in to S3 (run_results.json)
* generate docs
* notify users/tech teams when complete, success or failure
* clone to stg, notify users/tech teams where complete, success or failure
