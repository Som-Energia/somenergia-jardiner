{{ config(post_hook="grant select on {{ this }} to group energetica") }}

 SELECT reg."time",
    plant.id AS plant_id,
    plant.name AS plant_name,
    inverter.name AS inverter_name,
    string.name AS string_name,
    string.stringbox_name,
    reg.intensity_ma
   FROM {{ source('plantmonitordb', 'stringregistry') }} as reg
     LEFT JOIN {{ source('plantmonitordb', 'string') }} as string ON string.id = reg.string
     LEFT JOIN {{ source('plantmonitordb', 'inverter') }} as inverter ON inverter.id = string.inverter
     LEFT JOIN {{ source('plantmonitordb', 'plant') }} as plant ON plant.id = inverter.plant
  WHERE plant.id in (select id from {{ ref('plants_energetica') }})