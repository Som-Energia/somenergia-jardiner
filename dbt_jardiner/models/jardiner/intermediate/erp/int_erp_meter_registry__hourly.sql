{{ config(materialized='view') }}


with meter_registry_hourly_raw as (
  select
    mr.meter_id,
    mr.meter_name,
    mr.plant_id,
    p.plant_uuid,
    p.plant_name,
    p.plant_codename,
    date_trunc('hour', mr.start_hour) as start_hour,
    round(avg(mr.export_energy_wh), 2) as export_energy_wh,
    round(avg(mr.import_energy_wh), 2) as import_energy_wh
  from {{ ref('raw_meterregistry') }} as mr
    left join
      {{ ref("raw_plantmonitor_plants") }} as p
      on mr.plant_id = p.plant_id
  group by
    date_trunc('hour', mr.start_hour),
    p.plant_uuid,
    mr.plant_id,
    p.plant_name,
    p.plant_codename,
    mr.meter_id,
    mr.meter_name
)

select
  *,
  case
    when export_energy_wh > 0 then 1
    when export_energy_wh = 0 then 0
  end as has_energy
from meter_registry_hourly_raw
