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
    round(abs(inverter_power.inverter_power_kw - instant_power.inferred_meter_power_kw)::numeric, 2) as delta_power_instant_vs_inferred,
    inverter_power.num_inverters,
    instant_power.meter_energy_kwh,
    instant_power.previous_energy,
    instant_power.delta_meter_energy_kwh,
    instant_power.previous_ts,
    instant_power.delta_ts
  from {{ ref("int_dset__power_from_instant_energy") }} as instant_power
    left join
      inverter_power
      using (plant_uuid, ts)
)
select *
from instant_power_comparison
order by plant_uuid asc, ts desc
