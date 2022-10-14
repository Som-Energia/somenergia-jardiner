{{ config(materialized='view') }}

with plant_production_daily as (
  select
  *
  from {{ref('plant_production_daily')}}
)
select * from plant_production_daily