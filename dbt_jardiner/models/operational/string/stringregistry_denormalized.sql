{{ config(materialized='view') }}

-- TODO warning this is latest readings denormalized.

select
    sr.time as time,
    inverter.plant_id,
    inverter.inverter_id,
    inverter.inverter_name,
    sr.string_id,
    string.string_name,
    coalesce(string.stringbox_name, string.string_name) as stringdevice_name,
    sr.intensity_ma
FROM {{ ref('stringregistry_multisource') }} AS sr
LEFT JOIN {{ ref('strings_raw') }} as string on sr.string_id = string.string_id
LEFT JOIN {{ ref('inverters_raw') }} as inverter on inverter.inverter_id = string.inverter_id
