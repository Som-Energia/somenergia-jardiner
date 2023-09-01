
with tb as (
    select distinct device_uuid, plant, device, device_type, device_parent
    from {{ ref('signal_device_relation') }}
    order by plant, device)
select device_uuid, count(*) as repeted
from tb
group by device_uuid
having count(*)> 1
