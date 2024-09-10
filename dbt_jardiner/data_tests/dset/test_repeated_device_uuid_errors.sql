{{ config(enabled=false) }}

-- tests pairs device_uuid, plant, device, device_type, device_parent as unique
with
unique_device_per_plant as (
  select distinct
    device_uuid,
    plant_uuid,
    plant_name,
    device_name,
    device_type,
    device_parent,
    device_parent_uuid
  from {{ ref("raw_gestio_actius__signal_denormalized") }}
  order by plant_name, device_name
),

duplicated_devices as (
  select
    udpp.device_uuid,
    count(*) as n_duplicates
  from unique_device_per_plant as udpp
  group by udpp.device_uuid
  having count(*) > 1
),

joined as (
  select
    expected.*,
    duplicated_devices.n_duplicates
  from {{ ref("raw_gestio_actius__signal_denormalized") }} as expected
    left join
      duplicated_devices
      on expected.device_uuid = duplicated_devices.device_uuid
),

filtered as (
  select *
  from joined
  where n_duplicates is not null
)

select * from filtered
