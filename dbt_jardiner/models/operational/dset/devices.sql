{{ config(materialized='table') }}

select distinct plant, device, device_uuid, device_type, device_parent
from {{ ref('signal_device_relation_raw') }}
order by plant, device