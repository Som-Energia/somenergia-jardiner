{{ config(materialized='view') }}


with instant_energy as (
  select
    ts,
    plant_name,
    plant_uuid,
    signal_value as meter_energy_kwh
  from {{ ref('int_dset_responses__values_incremental') }}
  where
    ts > now() - interval '3 hours'
    {#- filter out old readings before massaging #}
    and metric_name = 'energia_activa_exportada_instantania'
    and signal_value is not null
),
instant_energy_delta as (
  select
    ts,
    plant_name,
    plant_uuid,
    meter_energy_kwh,
    lead(ts) over plant_window as previous_ts,
    lead(meter_energy_kwh) over plant_window as previous_energy,
    ts - lead(ts) over plant_window as delta_ts,
    meter_energy_kwh - lead(meter_energy_kwh) over plant_window as delta_meter_energy_kwh
  from instant_energy
  window plant_window as (partition by plant_uuid order by ts desc)
  order by ts desc
),
inferred_meter_power as (
  select
    ts,
    plant_name,
    plant_uuid,
    meter_energy_kwh,
    60 / extract(minute from delta_ts) * delta_meter_energy_kwh as inferred_meter_power_kw,
    previous_energy,
    delta_meter_energy_kwh,
    previous_ts,
    delta_ts,
    60 / extract(minute from delta_ts) as dt_hour_normalized
  from instant_energy_delta
  order by ts desc
)
select
  plant_uuid,
  ts,
  plant_name,
  meter_energy_kwh,
  inferred_meter_power_kw,
  previous_energy,
  delta_meter_energy_kwh,
  previous_ts,
  delta_ts,
  dt_hour_normalized
from inferred_meter_power
order by plant_uuid asc, ts desc
