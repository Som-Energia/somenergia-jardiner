{{ config(materialized="view") }}

with meter_readings_hourly as (
  select
    date_trunc('hour', ts) as start_hour,
    plant_uuid,
    plant_name,
    sum(meter_exported_energy) as meter_exported_energy,
    sum(meter_imported_energy) as meter_imported_energy,
    sum(meter_reactive_energy_q1) as meter_reactive_energy_q1,
    sum(meter_reactive_energy_q2) as meter_reactive_energy_q2,
    sum(meter_reactive_energy_q3) as meter_reactive_energy_q3,
    sum(meter_reactive_energy_q4) as meter_reactive_energy_q4,
    sum(meter_instant_exported_energy) as meter_instant_exported_energy
  from {{ ref("int_dset_meter__readings_wide") }}
  group by date_trunc('hour', ts), plant_uuid, plant_name
  order by date_trunc('hour', ts) desc
)
select * from meter_readings_hourly
