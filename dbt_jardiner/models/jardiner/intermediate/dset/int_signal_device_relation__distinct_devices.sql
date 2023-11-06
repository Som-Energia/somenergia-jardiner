{{ config(materialized="table") }}

select distinct plant, device, device_uuid, device_type, device_parent
from {{ ref("seed_signals__with_devices") }}
order by plant, device
