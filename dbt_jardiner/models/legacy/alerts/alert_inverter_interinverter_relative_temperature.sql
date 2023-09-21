{{ config(materialized='view') }}

with inverterregistry_sct as (
    select
        time,
        plant_id,
        plant_name,
        10 < ( max(temperature_c) - min(temperature_c) ) as is_alarmed
    from {{ref('alert_inverterregistry_clean_last_hour')}} as inverterregistry_sct
    group by time, plant_id, plant_name
)

select
    max(time) as time,
    plant_id,
    plant_name,
    'plant' as device_type,
    plant_name as device_name,
    'alert_inverter_interinverter_relative_temperature' as alarm_name,
    every(is_alarmed) as is_alarmed
from inverterregistry_sct
group by plant_id, plant_name
