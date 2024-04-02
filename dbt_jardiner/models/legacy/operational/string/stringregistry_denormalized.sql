{{ config(materialized='view') }}

-- TODO warning this is latest readings denormalized.

select
  sr.time as time, -- noqa: RF04
  inverter.plant_id,
  inverter.inverter_id,
  inverter.inverter_name,
  sr.string_id,
  string.string_name,
  sr.intensity_ma,
  coalesce(string.stringbox_name, string.string_name) as stringdevice_name
from {{ ref('stringregistry_multisource') }} as sr
  left join {{ ref('strings_raw') }} as string on sr.string_id = string.string_id
  left join
    {{ ref('inverters_raw') }} as inverter
    on string.inverter_id = inverter.inverter_id
