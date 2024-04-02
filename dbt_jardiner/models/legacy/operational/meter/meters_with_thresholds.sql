{{ config(materialized='view') }}

select
  meter.*,
  coalesce(mth.num_hours_threshold, 1) as num_hours_threshold
from {{ ref('meters_raw') }} as meter
  left join
    {{ ref('som_plants_raw') }} as plant
    on meter.plant_id = plant.plant_id
  left join
    {{ ref('alarm_meter_no_energy_plant_thresholds') }} as mth
    on plant.plant_name = mth.plant_name
