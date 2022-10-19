
{%- set start_date = '2020-01-01' -%}

SELECT
    time_bucket_gapfill('5 minutes', ir.time) as time,
    ir.inverter_id as inverter_id,
    avg(ir.power_kw) as power_kw,
    avg(ir.energy_kwh) as energy_kwh,
    avg(ir.intensity_cc_a) as intensity_cc_a,
    avg(ir.intensity_ca_a) as intensity_ca_a,
    avg(ir.voltage_cc_v) as voltage_cc_v,
    avg(ir.voltage_ca_v) as voltage_ca_v,
    avg(ir.uptime_h) as uptime_h,
    min(ir.temperature_c) as temperature_c
FROM {{ref('inverterregistry_raw')}} as ir
WHERE time >= '{{ start_date }}' and time < NOW() - interval '5 minutes'
GROUP by ir.inverter_id, time_bucket_gapfill('5 minutes', ir.time)
order by time desc