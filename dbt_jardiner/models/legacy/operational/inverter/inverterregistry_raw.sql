{{ config(materialized='view') }}

{# wrong unit temperature_dc is temperature_mc #}

select
  ir.time,
  ir.inverter as inverter_id,
  ir.uptime_h,
  1 as readings,
  round(ir.power_w / 1000.0, 2) as power_kw,
  round(ir.energy_wh / 1000.0, 2) as energy_kwh,
  round(ir.intensity_cc_ma / 1000.0, 2) as intensity_cc_a,
  round(ir.intensity_ca_ma / 1000.0, 2) as intensity_ca_a,
  round(ir.voltage_cc_mv / 1000.0, 2) as voltage_cc_v,
  round(ir.voltage_ca_mv / 1000.0, 2) as voltage_ca_v,
  round(ir.temperature_dc / 10.0, 2) as temperature_c
from {{ source('plantmonitor_legacy','inverterregistry') }} as ir

{% if target.name == 'pre' -%}
where ir.time >= current_date - interval '3 days'
{%- endif %}
