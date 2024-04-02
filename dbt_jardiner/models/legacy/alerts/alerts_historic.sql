{{ config(materialized='view') }}

with alarm_everything as (
  select *
  from
    {{ source('plantmonitor_legacy', 'alert_inverter_zero_power_at_daylight_historic') }}
  union
  select *
  from
    {{ source('plantmonitor_legacy', 'alert_inverter_interinverter_relative_temperature_historic') }}
  union
  select *
  from
    {{ source('plantmonitor_legacy', 'alert_inverter_temperature_historic') }}
  union
  select *
  from {{ source('plantmonitor_legacy', 'alert_meter_no_readings_historic') }}
  union
  select *
  from {{ source('plantmonitor_legacy', 'alert_meter_zero_energy_historic') }}
)

select *
from alarm_everything
order by notification_time desc
