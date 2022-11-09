{{ config(materialized='view') }}

with inverterregistry_sct as (
    SELECT
        time,
        plant_id,
        plant_name,
        inverter_id,
        inverter_name,
        temperature_c as temperature_c,
        50 < temperature_c  as alarm_inverter_temperature
    FROM
        {{ref('alert_inverterregistry_clean_last_hour')}}
)

select
    max(time) as time,
    plant_id,
    plant_name,
    inverter_id,
    inverter_name,
    min(temperature_c) as min_temperature_c,
    max(temperature_c) as max_temperature_c,
    every(alarm_inverter_temperature) as alarm_inverter_temperature
from inverterregistry_sct
group by plant_id, plant_name, inverter_id, inverter_name
order by time desc
