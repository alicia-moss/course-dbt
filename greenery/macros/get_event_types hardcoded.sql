{% macro get_event_types_hc() %}
{{ return(["add_to_cart", "checkout", "package_shipped"]) }}
{% endmacro %}