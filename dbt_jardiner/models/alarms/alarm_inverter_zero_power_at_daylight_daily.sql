{{ config(materialized='view') }}

with alarm_zero_power as (
    SELECT
        date_trunc('day', ir.time) as day,
        ir.plant_id,
        ir.plant_name,
        ir.inverter_id,
        ir.sunrise_generous,
        ir.sunset_generous,
        count(*) as alarm_count
    FROM {{ref('alarm_inverter_zero_power_at_daylight')}} as ir
    group by date_trunc('day', ir.time), plant_id, plant_name, inverter_id, sunset_generous, sunrise_generous
)

select
    *
from alarm_zero_power
order by day desc
