{% macro concat_bytes(column_name) %}

{{column_name}}_highbyte*2^16 + {{column_name}}_lowbyte - 2^32*({{column_name}}_highbyte > 2^15) as {{column_name}}

{% endmacro %}