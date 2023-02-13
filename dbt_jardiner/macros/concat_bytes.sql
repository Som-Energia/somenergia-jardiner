{% macro concat_bytes(column_name) %}

{{column_name}}_highbyte*2^16 + {{column_name}}_lowbyte - (2^32)::bigint*({{column_name}}_highbyte > 2^15)::int as {{column_name}}

{% endmacro %}