{{ config(materialized='view') }}

{#
Explanation of this query

meterregistry_last_readings selects the last 30 days to speedup

meterregistry_daylight joins with the sunrise and sunset for each reading

meter_registry_hourly_raw selects _only_ the last `num_hours_threshold` readings
for each meter (which is typically 1 for big plants and 4 for small plants)

meter_registry_group groups each group of readings by meter to find out
if all readings were at 0 which will then trigger the alarm

NULL values are not possible unless we have no readings at all in the last 30 days,
otherwise it will always select the last N readings in daylight
regardless of which day they come from. It will even combine different days.

The merging script which notifies and feeds alert_X_historic alert_X_status
sets to false alarms with NULL

#}


with meterregistry_last_readings as (
    select * from {{ ref('meter_registry_raw') }}
    where current_date - interval '30 days' < time
),

meterregistry_daylight as (
    select
        mr.*,
        mr.time between solar.sunrise_generous and solar.sunset_generous as is_daylight,
        solar.sunrise_generous as daylight_start,
        solar.sunset_generous as daylight_end
    from meterregistry_last_readings as mr
    left join {{ ref('meters_with_thresholds') }} as m on m.meter_id = mr.meter_id
    left join {{ ref('solar_events_generous') }} as solar on mr.time::date = solar.day and m.plant_id = solar.plant_id
),

meter_registry_hourly_raw as (
  select
    mr.time,
    meters.num_hours_threshold,
    meters.plant_id,
    meters.meter_id,
    meters.meter_name,
    mr.meter_id as mr_meter_id,
    meters.meter_connection_protocol,
    mr.export_energy_wh,
    mr.is_daylight,
    mr.daylight_start,
    mr.daylight_end
  from {{ ref('meters_with_thresholds') }} as meters
  left join lateral ( -- use left if you want meters without readings, inner otherwise
    select
      mr.time,
      mr.meter_id,
      mr.export_energy_wh,
      mr.is_daylight,
      mr.daylight_start,
      mr.daylight_end
    from meterregistry_daylight as mr
    where
        mr.meter_id = meters.meter_id
        and mr.time between mr.daylight_start and mr.daylight_end
    order by time desc
    limit meters.num_hours_threshold
  ) as mr on true
),

meter_registry_group as (
  select
    max(time) as time,
    min(time) as from_time,
    num_hours_threshold,
    every(is_daylight) as is_daylight,
    min(daylight_start) as daylight_start,
    min(daylight_end) as daylight_end,
    plant_id,
    meter_id,
    meter_name,
    meter_connection_protocol,
    count(export_energy_wh) as reading_count,
    max(export_energy_wh) as export_energy_wh,
    max(export_energy_wh) = 0 as alarm_zero_energy
  from meter_registry_hourly_raw
  group by plant_id, meter_id, meter_name, meter_connection_protocol, num_hours_threshold
)

select
  plants.plant_id,
  plants.plant_name,
  mrg.meter_id,
  mrg.meter_name,
  mrg.time,
  mrg.meter_connection_protocol,
  mrg.reading_count,
  mrg.export_energy_wh,
  mrg.is_daylight,
  mrg.daylight_start,
  mrg.daylight_end,
  mrg.alarm_zero_energy,
  CASE
    WHEN reading_count > 0 and export_energy_wh > 0 THEN 1
    WHEN reading_count > 0 and export_energy_wh = 0 THEN 0
    ELSE NULL
  END as has_energy,
  mrg.from_time,
  mrg.time as to_time,
  nr.newest_reading_time,
  mrg.num_hours_threshold,
  'meter' as device_type,
  mrg.meter_name as device_name,
  'alert_meter_zero_energy' as alarm_name,
  alarm_zero_energy as is_alarmed
FROM meter_registry_group as mrg
inner join {{ ref('som_plants') }} as plants using(plant_id)
left join {{ ref('alert_meter_newest_reading') }} as nr on nr.meter_id = mrg.meter_id
order by time desc