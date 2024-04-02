{{ config(materialized='view') }}

select
  plant_id,
  plant_name,
  device_type,
  device_name,
  alarm_name,
  is_alarmed
from {{ ref('alarm_historical_one_day_ago') }}
except
select
  plant_id,
  plant_name,
  device_type,
  device_name,
  alarm_name,
  is_alarmed
from {{ ref('alarm_historical_two_days_ago') }}
