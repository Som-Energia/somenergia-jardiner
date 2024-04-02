{{ config(materialized='view') }}

with alarm_zero_power as (
  select
    ir.plant_id,
    ir.plant_name,
    ir.inverter_id,
    ir.daylight_start,
    ir.daylight_end,
    date_trunc('day', ir.time) as day,
    count(*) as alarm_count
  from {{ ref('alarm_inverter_zero_power_at_daylight') }} as ir
  group by
    date_trunc('day', ir.time),
    ir.plant_id,
    ir.plant_name,
    ir.inverter_id,
    ir.daylight_start,
    ir.daylight_end
)

select *
from alarm_zero_power
order by day desc
