{{ config(materialized='view') }}


with meter_registry_hourly_raw as (
  select
    date_trunc('hour', mr.start_hour) AS start_hour,
    mr.meter_id,
    mr.meter_name,
    mr.plant_id,
    p.plant_uuid,
    p.plant_name,
    p.plant_codename,
    round(avg(export_energy_wh),2) as export_energy_wh,
    round(avg(import_energy_wh),2) as import_energy_wh
  from {{ ref('raw_meterregistry') }} as mr
  left join {{ ref("raw_plantmonitor_plants") }} p using(plant_id)
  group by date_trunc('hour', start_hour), plant_uuid, plant_id, plant_name, plant_codename, meter_id, meter_name
)

select
  *,
  CASE
    WHEN export_energy_wh > 0 THEN 1
    WHEN export_energy_wh = 0 THEN 0
    ELSE NULL
  END as has_energy
FROM meter_registry_hourly_raw