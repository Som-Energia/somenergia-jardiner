{{ config(materialized='table') }}

{# TODO we have to limit per connection_day per plant to avoid having NULL readings before plant existed#}


with alarm_meter_no_readings as (
  select
    day,
    plant_id,
    plant_name,
    'plant' as device_type,
    plant_name as device_name,
    'alarm_meter_no_readings' as alarm_name,
    TRUE as is_alarmed
  from {{ ref('alarm_meter_no_readings') }}
),
alarm_meter_no_energy as (
  select
    day,
    plant_id,
    plant_name,
    'meter' as device_type,
    plant_name as device_name,
    'alarm_meter_no_energy' as alarm_name,
    TRUE as is_alarmed
  from {{ ref('alarm_meter_no_energy') }}
),
alarm_inverter_temperature as (
  select distinct
    date_trunc('day', time) as day,
    plant_id,
    plant_name,
    'inverter' as device_type,
    inverter_id::text as device_name,
    'alarm_inverter_temperature' as alarm_name,
    TRUE as is_alarmed
  from {{ ref('alarm_inverter_temperature') }}
),
alarm_inverter_zero_power_at_daylight_daily as (
    select
    day,
    plant_id,
    plant_name,
    'inverter' as device_type,
    inverter_id::text as device_name,
    'alarm_inverter_zero_power_at_daylight' as alarm_name,
    TRUE as is_alarmed
  from {{ ref('alarm_inverter_zero_power_at_daylight_daily') }}
),
alarm_everything as (
  select * from alarm_meter_no_readings
  UNION
  select * from alarm_meter_no_energy
  UNION
  select * from alarm_inverter_temperature
  UNION
  select * from alarm_inverter_zero_power_at_daylight_daily
)

select *
from alarm_everything
order by day desc