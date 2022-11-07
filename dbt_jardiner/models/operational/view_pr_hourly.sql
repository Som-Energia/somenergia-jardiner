{{ config(materialized='view') }}

 SELECT
    meterregistry."time" AS "time",
    plant.id as plant,
    meter.id as meter,
    export_energy_wh,
    irr.irradiation_wh_m2,
    (export_energy_wh / plantparameters.peak_power_w::float) / (NULLIF(irr.irradiation_wh_m2, 0.0) / 1000.0) AS pr_hourly
 FROM {{source ('plantmonitordb', 'meterregistry')}} as meterregistry
 JOIN {{source ('plantmonitordb', 'meter')}} as meter
    ON meterregistry.meter = meter.id
 JOIN {{source ('plantmonitordb', 'view_satellite_irradiation')}} as irr
    ON meter.plant = irr.plant and irr."time" + interval '1 hour' = meterregistry."time"
 JOIN {{source ('plantmonitordb', 'plant')}} as plant
    ON meter.plant = plant.id
 LEFT JOIN {{source ('plantmonitordb', 'plantparameters')}} as plantparameters
    on plant.id = plantparameters.plant