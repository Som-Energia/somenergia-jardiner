{{ config(materialized='view') }}

with inverterregistry_sct as (
    select
        time,
        plant_id,
        plant_name,
        10 < ( max(temperature_c) - min(temperature_c) ) as alert_inverter_interinverter_relative_temperature
    from {{ref('alert_inverterregistry_clean_last_hour')}} as inverterregistry_sct
    group by time, plant_id, plant_name
)

select
    max(time) as time,
    plant_id,
    plant_name,
    every(alert_inverter_interinverter_relative_temperature) as alert_inverter_interinverter_relative_temperature
from inverterregistry_sct
group by plant_id, plant_name
