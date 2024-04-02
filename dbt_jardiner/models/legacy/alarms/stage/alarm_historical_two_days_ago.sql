{{ config(materialized='view') }}

select
  day,
  plant_id,
  plant_name,
  device_type,
  device_name,
  alarm_name,
  is_alarmed
from {{ ref('alarm_historical') }}
where (current_date - 2) = day
