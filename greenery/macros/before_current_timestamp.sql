{% test before_current_timestamp(model, column_name) %}


   select *
   from {{ model }}
   where {{ column_name }} > current_timestamp


{% endtest %}