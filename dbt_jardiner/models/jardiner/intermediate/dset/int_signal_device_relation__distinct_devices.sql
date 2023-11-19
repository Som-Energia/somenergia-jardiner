{{ config(materialized="table") }}

select distinct plant, plant_uuid, device, device_uuid, device_type, device_parent
from {{ ref('raw_gestio_actius__signal_denormalized') }}
order by plant, device
