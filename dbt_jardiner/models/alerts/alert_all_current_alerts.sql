{{ config(materialized='view') }}

with alert_inverter_interinverter_relative_temperature as (
  select
    time as time,
    plant_id,
    plant_name,
    'plant' as device_type,
    plant_name as device_name,
    'alert_inverter_interinverter_relative_temperature' as alarm_name,
    is_alarmed
  from {{ ref('alert_inverter_interinverter_relative_temperature') }}
),
alert_inverter_temperature as (
  select
    time as time,
    plant_id,
    plant_name,
    'inverter' as device_type,
    inverter_name as device_name,
    'alert_inverter_temperature' as alarm_name,
    is_alarmed
  from {{ ref('alert_inverter_temperature') }}
),
alert_inverter_zero_power_at_daylight as (
  select
    time as time,
    plant_id,
    plant_name,
    'inverter' as device_type,
    inverter_name as device_name,
    'alert_inverter_zero_power_at_daylight' as alarm_name,
    is_alarmed
  from {{ ref('alert_inverter_zero_power_at_daylight') }}
),
alert_everything as (
  select time,plant_id,plant_name,device_type,device_name,alarm_name,is_alarmed::text from alert_inverter_interinverter_relative_temperature
  UNION
  select time,plant_id,plant_name,device_type,device_name,alarm_name,is_alarmed::text from alert_inverter_temperature
  UNION
  select time,plant_id,plant_name,device_type,device_name,alarm_name,is_alarmed::text from alert_inverter_zero_power_at_daylight
)

select *
from alert_everything
order by time desc