{{ config(materialized='view') }}

select
  mrg.*,
  mrg.newest_reading_time as time, --noqa: RF04
  'meter' as device_type,
  mrg.meter_name as device_name,
  'alert_meter_no_readings' as alarm_name,
  mrg.alarm_no_reading as is_alarmed
from {{ ref('alert_meter_newest_reading') }} as mrg
order by mrg.newest_reading_time desc
