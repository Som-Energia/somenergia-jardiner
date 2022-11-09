{{ config(materialized='view') }}

{# wrong unit temperature_dc is temperature_mc #}

SELECT
    sr.time,
    sr.string as string_id
    sr.inverter as inverter_id,
    sr.intensity_ma
FROM {{ source('plantmonitordb','stringregistry') }} as sr

{% if target.name == 'pre' %}
where sr.time >= current_date - interval '3 days'
{% endif %}
order by time desc