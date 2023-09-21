
with tb as (
    select distinct device_uuid, plant, device, device_type, device_parent
    from {{ ref('seed_signals__with_devices') }}
    order by plant, device)
select device_uuid, count(*) as repeated_uuids
from tb
group by device_uuid
having count(*)> 1
