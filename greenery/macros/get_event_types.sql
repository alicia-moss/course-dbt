{% macro get_event_types() %}

   {% set event_type_query %}
      select distinct
      event_type
      from {{ ref('greenery','stg_events') }}
      order by 1
   {% endset %}

   {% set results = run_query(event_type_query) %}

   {% if execute %}
   {# Return the first column #}
   {% set results_list = results.columns[0].values() %}
   {% else %}
   {% set results_list = [] %}
   {% endif %}

   {{ log(results_list, info=True) }}

   {{ return(results_list) }}

{% endmacro %}