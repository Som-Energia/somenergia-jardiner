{{ config(materialized='view') }}

with plant_production_daily as (
  select
  *
  from {{ ref('plant_production_daily') }}
  left join {{ ref('alarm_meter_no_energy_plant_thresholds') }} using(plant_name)
)
select * from plant_production_daily
where unexpected_hours_without_energy >= num_hours_threshold