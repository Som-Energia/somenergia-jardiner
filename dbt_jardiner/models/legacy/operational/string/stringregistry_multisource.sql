{{ config(materialized='view') }}

with stringregistry as (

    SELECT
        time,
        string_id,
        intensity_ma
    FROM {{ ref('stringregistry_raw') }}

UNION ALL

    SELECT
        time,
        string_id,
        intensity_ma
    FROM {{ ref('lake_modbusreadings_stringboxes_standard') }}

)

select * from stringregistry
{% if target.name == 'pre' %}
where time >= current_date - interval '3 days'
{% endif %}
