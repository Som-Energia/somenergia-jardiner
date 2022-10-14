{{ config(materialized='view') }}


select
    spine.day,
    plant_id,
    plant_name,
    meter_name,
    meter_connection_protocol,
    COALESCE(meter_registry_hours_with_readings,0) as meter_registry_hours_with_readings
from {{ ref('spine_plant_meter_today') }} as spine
left join {{ref('plant_production_daily') }} using(day, plant_id,plant_name,meter_name)
where COALESCE(meter_registry_hours_with_readings,0) < 12
order by day desc