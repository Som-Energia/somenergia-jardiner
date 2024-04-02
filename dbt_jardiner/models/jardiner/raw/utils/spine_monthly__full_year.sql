{{ config(materialized='incremental') }}

{%- set start_date = "'2015-01-01'" -%}

with spine as (
  select
    generate_series(
      {{ start_date }}::date,
      date_trunc('year', current_date, 'Europe/Madrid')
      + interval '1 year -1 day',
      '1 month'
    ) as month
)

select * from spine

{% if is_incremental() %}
  where
    coalesce((select max(month) from {{ this }}), {{ start_date }}) < month
{% endif %}

order by month desc
