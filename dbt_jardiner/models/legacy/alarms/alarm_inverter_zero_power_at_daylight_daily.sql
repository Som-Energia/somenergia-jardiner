{{ config(materialized='view') }}

with alarm_zero_power as (
    SELECT
        date_trunc('day', ir.time) as day,
        ir.plant_id,
        ir.plant_name,
        ir.inverter_id,
        ir.daylight_start,
        ir.daylight_end,
        count(*) as alarm_count
    FROM {{ref('alarm_inverter_zero_power_at_daylight')}} as ir
    group by date_trunc('day', ir.time), plant_id, plant_name, inverter_id, daylight_start, daylight_end
)

select
    *
from alarm_zero_power
order by day desc
