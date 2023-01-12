{% macro concat_bytes(column_name) %}

case
when {{column_name}}_highbyte > 2^15 then
    -1*({{column_name}}_highbyte*2^16 + {{column_name}}_lowbyte)
else
    {{column_name}}_highbyte*2^16 + {{column_name}}_lowbyte
end as {{column_name}}

{% endmacro %}