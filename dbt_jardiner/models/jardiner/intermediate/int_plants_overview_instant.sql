{{ config(materialized='view') }}

{# Assumim que una planta o bé té potencia_activa o bé té les tres fases potencia_activa_fase#}
with plant_power_sum as (
  select
    plant_uuid,
    min(ts) as instant_power_plant_kw_registered_at,
    max(ts) - min(ts) as diff_ts,
    round(sum(signal_value), 1) as instant_power_plant_kw
  from {{ ref('int_dset__last_registries') }}
  where
    ts at time zone 'Europe/Madrid' >= current_date
    and device_type = 'inverter'
    and metric_name ilike 'potencia_activa%'
  group by
    plant_uuid,
    device_type
),

instant_power_plant as (
  select *
  from plant_power_sum
  where diff_ts <= interval '15 min'
),

last_irradiancia as (
    {#
        Cada planta té un o diversos tipus de senyals d'irradancia. Així, per cada planta, triem una senyal
        d'irradancia. l'Order by permet fer una jerarquia quan a una planta hi ha més d'un tipus de irradància.
    #}
  select distinct
  on (plant_uuid, ts)
    plant_uuid,
    ts,
    signal_value
  from {{ ref("int_dset__last_registries") }}
  where
    metric_name = 'irradiancia'
    and ts at time zone 'Europe/Madrid' >= current_date
  order by
    plant_uuid,
    ts,
    case
      when signal_name = 'irradiancia'
        then 1
      when signal_name = 'irradiancia_sonda_bruta'
        then 2
      when signal_name = 'irradiancia_sonda_neta'
        then 3
      when signal_name = 'irradiancia_sonda'
        then 4
    end
),

last_instant_power as (
  select distinct on (plant_uuid)
    plant_uuid,
    ts,
    inferred_meter_power_kw
  from {{ ref("int_dset__power_from_instant_energy") }}
  order by plant_uuid asc, ts desc
),

plant_production_daily_previous_day as (
  select
    plant_uuid,
    nom_planta as plant_name,
    dia as "day",
    energia_exportada_comptador_kwh as meter_exported_energy_kwh,
    energia_esperada_solargis_kwh as solargis_meter_expected_energy_kwh
  from {{ ref('dm_plant_production_daily') }}
  where dia = current_date - interval '1 day'
)

select
  p.plant_uuid,
  p.plant_name,
  p.municipality,
  p.province,
  p.technology,
  p.peak_power_kw,
  p.nominal_power_kw,
  coalesce(i.instant_power_plant_kw_registered_at, ip.ts) as instant_power_plant_kw_registered_at,
  coalesce(i.instant_power_plant_kw, ip.inferred_meter_power_kw) as instant_power_plant_kw,
  ir.ts as irradiance_w_m2_last_registered_at,
  ir.signal_value as irradiance_w_m2,
  ppd.day,
  ppd.meter_exported_energy_kwh,
  ppd.solargis_meter_expected_energy_kwh,
  case
    when i.instant_power_plant_kw is not null then 'directa'
    else 'inferida'
  end as instant_power_source
from {{ ref('raw_gestio_actius_plant_parameters') }} as p
  left join instant_power_plant as i using (plant_uuid)
  left join plant_production_daily_previous_day as ppd using (plant_uuid)
  left join last_irradiancia as ir using (plant_uuid)
  left join last_instant_power as ip using (plant_uuid)
