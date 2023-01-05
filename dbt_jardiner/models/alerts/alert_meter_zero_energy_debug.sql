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
)

select * from meter_registry_hourly_raw