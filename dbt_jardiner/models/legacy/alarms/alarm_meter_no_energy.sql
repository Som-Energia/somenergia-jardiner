{{ config(materialized='view') }}

with plant_production_daily as (
  select
  *
  from {{ ref('plant_production_daily') }} as ppd
  left join {{ ref('alarm_meter_no_energy_plant_thresholds') }} as amnept USING (plant_name)
)
select
*,
2 as alarm_priority
from plant_production_daily
where unexpected_hours_without_energy >= num_hours_threshold