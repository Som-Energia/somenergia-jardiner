
{%- set start_date = '2020-01-01' -%}

select
  ir.inverter_id as inverter_id,
  time_bucket_gapfill('5 minutes', ir.time) as time, --noqa: RF04
  round(avg(ir.power_kw), 2) as power_kw,
  round(avg(ir.energy_kwh), 2) as energy_kwh,
  round(avg(ir.intensity_cc_a), 2) as intensity_cc_a,
  round(avg(ir.intensity_ca_a), 2) as intensity_ca_a,
  round(avg(ir.voltage_cc_v), 2) as voltage_cc_v,
  round(avg(ir.voltage_ca_v), 2) as voltage_ca_v,
  round(max(ir.uptime_h), 2) as uptime_h,
  round(min(ir.temperature_c), 2) as temperature_c,
  round(sum(readings), 2) as readings
from {{ ref('inverterregistry_multisource') }} as ir
where time >= '{{ start_date }}' and time < now() - interval '5 minutes'
group by ir.inverter_id, time_bucket_gapfill('5 minutes', ir.time)
