{{ config(materialized='view') }}

with plant_production_daily as (
  select prod.*, alarm.num_hours_threshold, alarm.threshold_type
  from {{ ref('plant_production_daily') }} as prod
    left join
      {{ ref('alarm_meter_no_energy_plant_thresholds') }} as alarm
      using (plant_name)
)

select
  *,
  2 as alarm_priority
from plant_production_daily
where unexpected_hours_without_energy >= num_hours_threshold
