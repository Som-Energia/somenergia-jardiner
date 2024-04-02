{{ config(materialized='view') }}

with inverterregistry_clean_nrows as (

  select
    *,
    1 as nrows
  from {{ ref('inverterregistry_clean') }}

)


select
  irc.plant_id,
  irc.plant_name,
  irc.plant_code,
  irc.inverter_id,
  irc.inverter_name,
  irc.inverter_brand,
  irc.inverter_model,
  irc.inverter_nominal_power_kw,
  date_trunc('day', irc.time) as time, --noqa: RF04
  round(sum(irc.power_kw), 2) as power_kw,
  round(sum(irc.energy_kwh), 2) as energy_kwh,
  round(avg(irc.intensity_cc_a), 2) as intensity_cc_a_day_avg,
  round(avg(irc.intensity_ca_a), 2) as intensity_ca_a_day_avg,
  round(avg(irc.voltage_cc_v), 2) as voltage_cc_v_day_avg,
  round(avg(irc.voltage_ca_v), 2) as voltage_ca_v_day_avg,
  round(max(irc.uptime_h), 2) as uptime_h,
  round(avg(irc.temperature_c), 2) as temperature_cd_day_avg,
  round(min(irc.temperature_c), 2) as temperature_c_day_min,
  round(max(irc.temperature_c), 2) as temperature_c_day_max,
  round(sum(irc.readings) / sum(irc.nrows), 2) as confidence_index
from inverterregistry_clean_nrows as irc
group by
  date_trunc('day', irc.time),
  irc.plant_id,
  irc.plant_name,
  irc.plant_code,
  irc.inverter_id,
  irc.inverter_name,
  irc.inverter_brand,
  irc.inverter_model,
  irc.inverter_nominal_power_kw
