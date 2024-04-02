{{ config(materialized='view') }}

with inverterregistry_last_readings as (
  select ir.* from {{ ref('inverterregistry_clean') }} as ir
  where now() - interval '1 hour' < ir.time
),

inverter_join as (
  select
    sub_sr.time as time, --noqa: RF04
    plant.plant_id,
    plant.plant_name as plant_name,
    sub_sr.inverter_id,
    sub_sr.inverter_name,
    sub_sr.string_name,
    sub_sr.stringdevice_name,
    sub_sr.intensity_ma,
    ir.power_kw,
    sub_sr.intensity_ma < 500 and ir.power_kw > 10 as is_low_intensity
  from {{ ref('stringregistry_latest_hour') }} as sub_sr
    left join
      inverterregistry_last_readings as ir
      on sub_sr.time = ir.time and sub_sr.inverter_id = ir.inverter_id
    left join
      {{ ref('som_plants_raw') }} as plant
      on sub_sr.plant_id = plant.plant_id
),

sr_grouped as (
  select
    plant_id,
    plant_name,
    inverter_id,
    inverter_name,
    string_name,
    stringdevice_name,
    max(time) as time, --noqa: RF04
    sum(intensity_ma) as intensity_ma,
    sum(power_kw) as power_kw,
    every(is_low_intensity) as low_intensity_alarm
  from inverter_join
  group by
    plant_id,
    plant_name,
    inverter_id,
    inverter_name,
    string_name,
    stringdevice_name
)

select *
from sr_grouped
