{{ config(post_hook="grant select on {{ this }} to group ercam") }}

SELECT reg."time",
    plant.id AS plant_id,
    plant.name AS plant_name,
    reg.sensor AS sensor_id,
    sensor.name AS sensor_name,
    reg.irradiation_w_m2,
    reg.temperature_dc
FROM {{source('plantmonitor_legacy','sensorirradiationregistry')}} reg
    LEFT JOIN {{source('plantmonitor_legacy','sensor')}} as sensor ON (sensor.id = reg.sensor)
    LEFT JOIN {{source('plantmonitor_legacy','plant')}} as plant ON (plant.id = sensor.plant)
where plant.id in (select id from {{ ref('plants_ercam') }})