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
    now() - make_interval(hours=>meters.num_hours_threshold + 2) as from_time,
    meters.num_hours_threshold,
    meters.plant_id,
    meters.meter_id,
    meters.meter_name,
    mr.meter_id as mr_meter_id,
    meters.meter_connection_protocol,
    mr.export_energy_wh,
    mr.is_daylight
  from {{ ref('meters_with_thresholds') }} as meters
  left join lateral ( -- use left if you want meters without readings, inner otherwise
    select
      mr.time,
      mr.meter_id,
      mr.export_energy_wh,
      mr.is_daylight
    from meterregistry_daylight as mr
    where
        mr.meter_id = meters.meter_id
        and now() - make_interval(hours=>(meters.num_hours_threshold + 2)) < time
  ) as mr on true
),

meter_registry_group as (
  select
    max(time) as time,
    from_time,
    num_hours_threshold,
    plant_id,
    meter_id,
    meter_name,
    meter_connection_protocol,
    count(export_energy_wh) as reading_count,
    max(export_energy_wh) as export_energy_wh,
    max(export_energy_wh) = 0 as alarm_zero_energy
  from meter_registry_hourly_raw
  group by plant_id, meter_id, meter_name, meter_connection_protocol, from_time, num_hours_threshold
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
  CASE
    WHEN reading_count > 0 and export_energy_wh > 0 THEN 1
    WHEN reading_count > 0 and export_energy_wh = 0 THEN 0
    ELSE NULL
  END as has_energy,
  nr.newest_reading_time,
  mrg.from_time,
  mrg.num_hours_threshold,
  'meter' as device_type,
  mrg.meter_name as device_name,
  'alert_meter_zero_energy' as alarm_name,
  CASE
    WHEN reading_count > 0 and export_energy_wh > 0 THEN FALSE
    WHEN reading_count > 0 and export_energy_wh = 0 THEN TRUE
    ELSE NULL
  END as is_alarmed
FROM meter_registry_group as mrg
inner join {{ ref('som_plants') }} as plants using(plant_id)
left join {{ ref('alert_meter_newest_reading') }} as nr on nr.meter_id = mrg.meter_id
order by time desc