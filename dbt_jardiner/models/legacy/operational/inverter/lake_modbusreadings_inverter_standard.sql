{{ config(materialized='view') }}

{#

This code is for the registries 32bit metrics that are splitted into 2 modbus registries

Assumes signed registries. We've seen that only uptime is unsigned, meaning that in 68 years we will get a negative uptime.
#}

with inverter_modbus as (
  select
    five_minute as time, --noqa: RF04
    inverter_id,
    power_kw::numeric as power_kw,
    (energy_10kwh_daily * 10)::numeric as energy_kwh,
    null::numeric as intensity_cc_a,
    null::numeric as intensity_ca_a,
    null::numeric as voltage_cc_v,
    null::numeric as voltage_ca_v,
    (uptime_s / 3600.0)::numeric as uptime_h,
    (0.1 * temperature_dc)::numeric as temperature_c,
    1 as readings
  from {{ ref("lake_modbusreadings_inverter_concat") }}
)

select *
from inverter_modbus
