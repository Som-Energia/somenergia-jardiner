{{ config(materialized='view') }}

with stringregistry_last_readings as (
    select * from {{ ref('stringregistry_multisource') }}
    where timezone('utc', now()) - interval '1 hour' < time
)
select
    sr.time as time,
    inverter.plant_id,
    inverter.inverter_id,
    inverter.inverter_name,
    string.string_name,
    coalesce(string.stringbox_name, string.string_name) as stringdevice_name,
    sr.intensity_ma
FROM stringregistry_last_readings AS sr
LEFT JOIN {{ ref('strings_raw') }} as string on sr.string_id = string.string_id
LEFT JOIN {{ ref('inverters_raw') }} as inverter on inverter.inverter_id = string.inverter_id
