{{ config(materialized='view') }}

with spina5m as (
  select generate_series('2023-12-01', now(), '5 minutes') as ts
),

spined_expected_signals as (
  select
    spina5m.ts,
    plants.plant_name,
    plants.plant_uuid,
    metadata.device_uuid,
    metadata.device_name,
    metadata.device_type,
    metadata.signal_name,
    metadata.signal_uuid,
    metadata.metric_name,
    metadata.device_parent,
    metadata.device_parent_uuid
  from
    spina5m
    {# dm_plants is the SSOT of the plants names #}
    left join {{ ref("int_gda_plants__plants_catalog") }} as plants on true
    left join {{ ref("raw_gestio_actius__signal_denormalized") }} as metadata using (plant_uuid)
),
dset_from_december_2023 as (
  select * from {{ ref("int_dset_responses__materialized") }}
  where
    ts > '2023-12-01'
    {# if we don't limit queried_at the planner shits the bed #}
    and queried_at > '2023-12-01'
),

spined_dset as (
  select
    spined.ts,
    spined.plant_name,
    spined.plant_uuid,
    spined.device_uuid,
    spined.device_name,
    spined.device_type,
    spined.signal_uuid,
    spined.signal_name,
    spined.metric_name,
    spined.device_parent,
    spined.device_parent_uuid,
    valors.signal_value,
    valors.group_name,
    valors.signal_id,
    valors.signal_tz,
    valors.signal_code,
    valors.signal_type,
    valors.signal_unit,
    valors.signal_frequency,
    valors.signal_is_virtual,
    valors.signal_last_ts,
    valors.signal_last_value,
    valors.queried_at,
    valors.materialized_at,
    valors.ts is not null as from_dset
  from spined_expected_signals as spined
    left join dset_from_december_2023 as valors
      using (ts, signal_uuid)
  order by spined.ts desc, spined.plant_name asc
)

select * from spined_dset
