{{ config(materialized='view') }}

with alert_inverter_zero_power_at_daylight as (
  select
    plant_id,
    plant_name,
    device_type,
    device_name,
    alarm_name,
    is_alarmed,
    notification_time
  from {{ source('plantmonitordb', 'alert_inverter_zero_power_at_daylight_historic') }}
),
alarm_everything as (
  select * from alert_inverter_zero_power_at_daylight

)

select *
from alarm_everything
order by notification_time desc