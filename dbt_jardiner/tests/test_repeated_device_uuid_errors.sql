-- tests pairs device_uuid, plant, device, device_type, device_parent as unique
with tb as (
    select distinct device_uuid, plant, device, device_type, device_parent
    from {{ ref('raw_gestio_actius__signal_denormalized') }}
    order by plant, device),
tb2 as (
    select tb.device_uuid, count(*) as duplicates
    from tb
    group by device_uuid
    having count(*)> 1
    )
select r.*, duplicates
from {{ ref('raw_gestio_actius__signal_denormalized') }} r
left join tb2 on tb2.device_uuid = r.device_uuid
where duplicates is not null