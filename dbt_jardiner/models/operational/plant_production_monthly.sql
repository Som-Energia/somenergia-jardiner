{{ config(materialized='view') }}

with combined_meter_satellite as (
  select
  date_trunc('month', day) as month
  sum(energy_difference) as energy_difference,
  from {{ref('plant_production_daily')}} as mr
  group by month
)
