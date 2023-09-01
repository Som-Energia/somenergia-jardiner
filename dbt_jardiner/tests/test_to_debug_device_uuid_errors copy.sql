
with tb as (
    select distinct device_uuid, plant, device, device_type, device_parent
    from {{ ref('signal_device_relation') }}
    order by plant, device),
tb2 as (
    select tb.device_uuid, count(*) as duplicates
    from tb
    group by device_uuid
    having count(*)> 1
    )
select r.*, duplicates
from {{ ref('signal_device_relation') }} r
left join tb2 on tb2.device_uuid = r.device_uuid
where duplicates is not null