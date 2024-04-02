{{ config(materialized="view") }}

with inverter_power as (
  select
    plant_uuid,
    plant_name,
    ts,
    sum(signal_value) as inverter_power_kw,
    count(*) as num_inverters
  from {{ ref("int_dset_responses__values_incremental") }}
  where ts > now() - interval '7 days' and metric_name = 'potencia_activa'
  group by plant_uuid, plant_name, ts
),

instant_power_comparison as (
  select
    plant_uuid,
    instant_power.plant_name,
    ts,
    inverter_power.inverter_power_kw,
    instant_power.inferred_meter_power_kw,
    inverter_power.num_inverters,
    instant_power.meter_energy_kwh,
    instant_power.previous_energy,
    instant_power.delta_meter_energy_kwh,
    instant_power.previous_ts,
    instant_power.delta_ts,
    round(abs(inverter_power.inverter_power_kw - instant_power.inferred_meter_power_kw)::numeric, 2) as delta_power_instant_vs_inferred
  from {{ ref("int_dset__power_from_instant_energy") }} as instant_power
    left join inverter_power using (plant_uuid, ts)
)

select
  plant_uuid as uuid_planta,
  plant_name as nom_planta,
  ts,
  inverter_power_kw as potencia_inversor_kw,
  inferred_meter_power_kw as potencia_deduida_kw,
  delta_power_instant_vs_inferred as diff_deduida_vs_inversor,
  num_inverters as num_inversors,
  meter_energy_kwh as energia_comptador_kwh,
  previous_energy as energia_anterior,
  delta_meter_energy_kwh as delta_energia_comptador_kwh,
  previous_ts as ts_anterior,
  delta_ts as delta_ts
from instant_power_comparison
order by plant_uuid asc, ts desc
