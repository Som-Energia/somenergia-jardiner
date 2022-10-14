{{ config(materialized='view') }}

with plant_production_daily as (
  select
  date_trunc('month', day) as month,
  sum(forecast_meter_difference_energy_wh) as forecast_meter_difference_energy_wh
  from {{ref('plant_production_daily')}}
  group by month
)
select * from plant_production_daily