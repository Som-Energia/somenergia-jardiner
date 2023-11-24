-- tests pairs device_uuid, plant, device, device_type, device_parent as unique
with
    tb as (
        select distinct device_uuid, plant_uuid, plant_name, device_name, device_type, device_parent
        from {{ ref("raw_gestio_actius__signal_denormalized") }}
        order by plant_name, device_name
    ),

tb2 as (
      select tb.device_uuid, count(*) as duplicates
      from tb
      group by tb.device_uuid
      having count(*) > 1
    )

select r.*, tb2.duplicates
from {{ ref("raw_gestio_actius__signal_denormalized") }} as r
left join tb2 on r.device_uuid = tb2.device_uuid
where tb2.duplicates is not null
