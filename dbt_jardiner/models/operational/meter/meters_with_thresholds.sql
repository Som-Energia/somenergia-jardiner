{{ config(materialized='view') }}

select
    meter.*,
    coalesce(mth.num_hours_threshold, 1) as num_hours_threshold
from {{ ref('meters_raw') }} as meter
left join {{ ref('som_plants_raw') }} as plant using(plant_id)
left join {{ ref('alarm_meter_no_energy_plant_thresholds')}} as mth on mth.plant_name = plant.plant_name
