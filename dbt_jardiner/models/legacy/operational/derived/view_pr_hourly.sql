{{ config(materialized='view') }}

select
  meterregistry."time" as "time",
  plant.id as plant,
  meter.id as meter,
  meterregistry.export_energy_wh,
  irr.irradiation_wh_m2,
  (meterregistry.export_energy_wh / plantparameters.peak_power_w::float)
  / (nullif(irr.irradiation_wh_m2, 0.0) / 1000.0) as pr_hourly
from {{ source ('plantmonitor_legacy', 'meterregistry') }} as meterregistry
  inner join {{ source ('plantmonitor_legacy', 'meter') }} as meter
    on meterregistry.meter = meter.id
  inner join
    {{ source ('plantmonitor_legacy', 'view_satellite_irradiation') }} as irr
    on
      meter.plant = irr.plant
      and irr."time" + interval '1 hour' = meterregistry."time"
  inner join {{ source ('plantmonitor_legacy', 'plant') }} as plant
    on meter.plant = plant.id
  left join
    {{ source ('plantmonitor_legacy', 'plantparameters') }} as plantparameters
    on plant.id = plantparameters.plant
