{{ config(materialized='view') }}

with stringboxes as (
  select
    five_minute as time, --noqa: RF04
    string_id,
    intensity_ma
  from {{ ref('lake_modbusreadings_stringboxes') }}
)

select * from stringboxes
