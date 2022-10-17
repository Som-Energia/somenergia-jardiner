{{ config(materialized='view') }}

select
  plant_id,
  plant_name,
  device_type,
  device_name,
  alarm_name,
  is_alarmed
from {{ref('alarm_everything_today')}}
except
select
  plant_id,
  plant_name,
  device_type,
  device_name,
  alarm_name,
  is_alarmed
from {{ref('alarm_everything_yesterday')}}
