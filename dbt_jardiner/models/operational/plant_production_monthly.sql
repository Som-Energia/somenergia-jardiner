{{ config(materialized='view') }}

with plant_production_daily as (
  select
  date_trunc('month', day) as month,
  sum(energy_difference) as energy_difference
  from {{ref('plant_production_daily')}}
  group by month
)
select * from plant_production_daily