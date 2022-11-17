{{ config(materialized='view') }}

with alarm_everything as (
  select * from {{ source('plantmonitordb', 'alert_inverter_zero_power_at_daylight_status') }}
  UNION
  select * from {{ source('plantmonitordb', 'alert_inverter_interinverter_relative_temperature_status') }}
  UNION
  select * from {{ source('plantmonitordb', 'alert_inverter_temperature_status') }}
  UNION
  select * from {{ source('plantmonitordb', 'alert_meter_no_readings_status') }}
  UNION
  select * from {{ source('plantmonitordb', 'alert_meter_zero_energy_status') }}
)

select *
from alarm_everything
order by time desc