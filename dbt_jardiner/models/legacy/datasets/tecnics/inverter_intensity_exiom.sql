{{ config(post_hook="grant select on {{ this }} to group exiom") }}

 SELECT reg."time",
    plant.id AS plant_id,
    plant.name AS plant_name,
    inverter.name AS inverter_name,
    string.name AS string_name,
    string.stringbox_name,
    reg.intensity_ma
   FROM {{ ref('stringregistry_multisource') }} as reg
     LEFT JOIN {{ source('plantmonitor_legacy', 'string') }} as string ON string.id = reg.string_id
     LEFT JOIN {{ source('plantmonitor_legacy', 'inverter') }} as inverter ON inverter.id = string.inverter
     LEFT JOIN {{ source('plantmonitor_legacy', 'plant') }} as plant ON plant.id = inverter.plant
  WHERE plant.id in (select id from {{ ref('plants_exiom') }})