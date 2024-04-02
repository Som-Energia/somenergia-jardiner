{{ config(post_hook="grant select on {{ this }} to group ercam") }}

select
  reg."time",
  plant.id as plant_id,
  plant.name as plant_name,
  reg.sensor as sensor_id,
  sensor.name as sensor_name,
  reg.irradiation_w_m2,
  reg.temperature_dc
from {{ source('plantmonitor_legacy','sensorirradiationregistry') }} as reg
  left join
    {{ source('plantmonitor_legacy','sensor') }} as sensor
    on (reg.sensor = sensor.id)
  left join
    {{ source('plantmonitor_legacy','plant') }} as plant
    on (sensor.plant = plant.id)
where plant.id in (select id from {{ ref('plants_ercam') }})
