{{ config(materialized='view') }}

select
  ir.time,
  plant.id as plant_id,
  plant.name as plant_name,
  plant.codename as plant_code,
  ir.inverter_id,
  inverter.name as inverter_name,
  inverter.brand as inverter_brand,
  inverter.model as inverter_model,
  ir.power_kw,
  ir.energy_kwh,
  ir.intensity_cc_a,
  ir.intensity_ca_a,
  ir.voltage_cc_v,
  ir.voltage_ca_v,
  ir.uptime_h,
  ir.temperature_c,
  ir.readings,
  round(inverter.nominal_power_w / 1000.0, 2) as inverter_nominal_power_kw
from {{ ref('inverterregistry_gapfilled') }} as ir
  left join
    {{ source('plantmonitor_legacy','inverter') }} as inverter
    on ir.inverter_id = inverter.id
  left join
    {{ source('plantmonitor_legacy','plant') }} as plant
    on inverter.plant = plant.id
