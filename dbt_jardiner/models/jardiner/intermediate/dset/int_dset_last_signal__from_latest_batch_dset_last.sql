{{ config(materialized="view") }}

with last_dset_batch as (
    select
        case
            when signal_uuid ~ e'^[[:xdigit:]]{8}-([[:xdigit:]]{4}-){3}[[:xdigit:]]{12}$' then signal_uuid::uuid
        end as signal_uuid,
        signal_uuid as signal_uuid_raw,
        {{ dbt_utils.star(from=ref("raw_dset_responses__last_signal_reading"), except=['signal_uuid']) }}
    from {{ ref("raw_dset_responses__last_signal_reading") }} as dset
)
select
    dset.signal_last_ts,
    dset.signal_last_value,
    dset.group_name as dset_plant_name,
    plants.plant_name,
    dset.queried_at,
    metadata.signal_name,
    metadata.metric_name,
    metadata.device_name,
    metadata.device_type,
    metadata.plant_uuid,
    metadata.device_uuid,
    metadata.device_parent,
    metadata.signal_uuid,
    dset.signal_id,
    dset.signal_tz,
    dset.signal_code,
    dset.signal_type,
    dset.signal_unit
from last_dset_batch as dset
full outer join
  {{ ref("raw_gestio_actius__signal_denormalized") }} as metadata
  using (signal_uuid)
left join {{ ref("int_gda_plants__plants_catalog") }} as plants
  using (plant_uuid)
