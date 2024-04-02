{{ config(materialized='view') }}

with stringregistry as (

  select
    time,
    string_id,
    intensity_ma
  from {{ ref('stringregistry_raw') }}

  union all

  select
    time,
    string_id,
    intensity_ma
  from {{ ref('lake_modbusreadings_stringboxes_standard') }}

)

select * from stringregistry
{% if target.name == 'pre' %}
where time >= current_date - interval '3 days'
{% endif %}
