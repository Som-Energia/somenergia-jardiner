{{ config(materialized='incremental') }}

{%- set start_date = "'2015-01-01 00:00+00'" -%}

with spine as (
  select
    generate_series(
      {{ start_date }}::timestamptz, now(), '1 hour'
    ) as start_hour
)

select * from spine

{%- if is_incremental() %}
  where
    coalesce((select max(start_hour) from {{ this }}), {{ start_date }}) < start_hour
{%- endif %}
