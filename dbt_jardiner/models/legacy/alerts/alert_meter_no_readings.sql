{{ config(materialized='view') }}

select
  *,
  newest_reading_time as time,
  'meter' as device_type,
  mrg.meter_name as device_name,
  'alert_meter_no_readings' as alarm_name,
  alarm_no_reading as is_alarmed
FROM {{ ref('alert_meter_newest_reading') }} as mrg
order by newest_reading_time desc