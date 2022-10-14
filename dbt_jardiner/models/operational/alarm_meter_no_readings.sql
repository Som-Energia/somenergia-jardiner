{{ config(materialized='view') }}


select
    date_day,
    plant_id,
    plant_name,
    meter_name,
    meter_connection_protocol,
    meter_registry_hours_with_readings as meter_registry_hours_with_readings_to_destroy,
    COALESCE(meter_registry_hours_with_readings,0) as meter_registry_hours_with_readings
from {{ ref('spine_plant_meter_today')}}
left join {{ref('plant_production_daily')}} using(plant_id,plant_name,meter_name)
where COALESCE(meter_registry_hours_with_readings,0) < 12
order by date_day desc