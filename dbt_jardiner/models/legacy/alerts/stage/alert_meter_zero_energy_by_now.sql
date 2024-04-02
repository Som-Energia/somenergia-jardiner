{{ config(materialized='view') }}

-- see below
-- use left join lateral if you want meters without readings within threshold range
-- (moxa usually has 12h delay which means we never have readings within range)
-- use **inner join lateral** if you only want meters with readings

-- tcp usually has a 2h delay. The ERP polls every 2h or so, and we sync every 20 minutes,
-- so we'll likely get at least 1h20 delay.

-- to mitigate this we add a baseline +2h to the thresholds

with meterregistry_last_readings as (
  select * from {{ ref('meter_registry_raw') }}
  where current_date < time
),

meterregistry_daylight as (
  select
    mr.*,
    solar.sunrise_generous as daylight_start,
    solar.sunset_generous as daylight_end,
    mr.time between solar.sunrise_generous and solar.sunset_generous as is_daylight
  from meterregistry_last_readings as mr
    left join
      {{ ref('meters_with_thresholds') }} as m
      on mr.meter_id = m.meter_id
    left join
      {{ ref('plantmonitordb_solarevent__generous') }} as solar
      on mr.time::date = solar.day and m.plant_id = solar.plant_id
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
    now()
    - make_interval(hours => meters.num_hours_threshold + 2) as from_time
  from {{ ref('meters_with_thresholds') }} as meters
    -- use left if you want meters without readings, inner otherwise
    left join lateral (
      select
        mr.time,
        mr.meter_id,
        mr.export_energy_wh,
        mr.is_daylight
      from meterregistry_daylight as mr
      where
        mr.meter_id = meters.meter_id
        and now() - make_interval(hours => (meters.num_hours_threshold + 2))
        < mr.time
    ) as mr on true
),

meter_registry_group as (
  select
    from_time,
    num_hours_threshold,
    plant_id,
    meter_id,
    meter_name,
    meter_connection_protocol,
    max(time) as time, --noqa: RF04
    count(export_energy_wh) as reading_count,
    max(export_energy_wh) as export_energy_wh,
    max(export_energy_wh) = 0 as alarm_zero_energy
  from meter_registry_hourly_raw
  group by
    plant_id,
    meter_id,
    meter_name,
    meter_connection_protocol,
    from_time,
    num_hours_threshold
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
  mrg.alarm_zero_energy,
  nr.newest_reading_time,
  mrg.from_time,
  mrg.num_hours_threshold,
  'meter' as device_type,
  mrg.meter_name as device_name,
  'alert_meter_zero_energy' as alarm_name,
  case
    when mrg.reading_count > 0 and mrg.export_energy_wh > 0 then 1
    when mrg.reading_count > 0 and mrg.export_energy_wh = 0 then 0
  end as has_energy,
  case
    when mrg.reading_count > 0 and mrg.export_energy_wh > 0 then false
    when mrg.reading_count > 0 and mrg.export_energy_wh = 0 then true
  end as is_alarmed
from meter_registry_group as mrg
  inner join {{ ref('som_plants') }} as plants on mrg.plant_id = plants.plant_id
  left join
    {{ ref('alert_meter_newest_reading') }} as nr
    on mrg.meter_id = nr.meter_id
