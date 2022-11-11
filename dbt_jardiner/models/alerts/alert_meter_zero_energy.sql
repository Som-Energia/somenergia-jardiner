{{ config(materialized='view') }}

with meterregistry_last_readings as (
    select * from {{ ref('meter_registry_raw') }}
    where current_date < time
),

meterregistry_daylight as (
    select
        mr.*,
        mr.time between solar.sunrise_generous and solar.sunset_generous as is_daylight,
        solar.sunrise_generous as daylight_start,
        solar.sunset_generous as daylight_end
    from meterregistry_last_readings as mr
    left join {{ref('solar_events_generous')}} as solar on mr.time::date = solar.day and mr.plant_id = solar.plant_id
),

meters as (
    select
    *
    from {{ ref('meters_with_thresholds') }}
),

meter_registry_hourly_raw as (
  select
    meter_id,
    export_energy_wh
  from {{ ref('meters_raw') }} as meters
  left join lateral (
    select * from meterregistry_daylight as mr
    where
        mr.meter_id = meters.meter_id
        and timezone('utc', now()) - make_interval(hours=>meters.alarm_zero_energy_threshold) < time
  ) as mr on true
),

meter_registry_group as (
    select
    meter_id,
    count(export_energy_wh) as reading_count,
    max(export_energy_wh) as export_energy_wh,
    export_energy_wh = 0 as alarm_zero_energy
    from meter_registry_hourly_raw
    group by meter_id
)

select
  *,
  CASE
    WHEN reading_count > 0 and export_energy_wh > 0 THEN 1
    WHEN reading_count > 0 and export_energy_wh = 0 THEN 0
    ELSE NULL
  END as has_energy
FROM meter_registry_hourly_raw