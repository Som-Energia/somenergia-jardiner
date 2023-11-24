{{ config(materialized="table") }}

select distinct plant_name, plant_uuid, device_name, device_uuid, device_type, device_parent
from {{ ref('raw_gestio_actius__signal_denormalized') }}
order by plant_name, device_name
