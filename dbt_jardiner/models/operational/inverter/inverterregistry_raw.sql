{{ config(materialized='view') }}


SELECT
    ir.time,
    ir.inverter as inverter_id,
    round(ir.power_w/1000.0,2) as power_kw,
    round(ir.energy_wh/1000.0,2) as energy_kwh,
    round(ir.intensity_cc_ma/1000.0,2) as intensity_cc_a,
    round(ir.intensity_ca_ma/1000.0,2) as intensity_ca_a,
    round(ir.voltage_cc_mv/1000.0,2) as voltage_cc_v,
    round(ir.voltage_ca_mv/1000.0,2) as voltage_ca_v,
    ir.uptime_h,
    round(ir.temperature_dc/1000.0,2) as temperature_c, -- wrong unit dc is mc
    1 as readings
FROM {{source('plantmonitor','inverterregistry')}} as ir
where time > '2022-10-01'
order by time desc