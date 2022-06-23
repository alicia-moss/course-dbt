-- This doesn't work and I don't know why.
{% macro get_product_name(column_name) %}

 {% set sql_qry %}
   select name
   from {{ ref ('greenery', 'stg_products') }}
   where product_id = {{ column_name }}
 {% endset %}
 --   'This is a name'
 result = {% do run_query(sql_qry) %}
 {{ return (result) }}

{% endmacro %}