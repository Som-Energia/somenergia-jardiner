{{ config(materialized="view") }}

with
valors as (
  select
    true as rebut_from_dset,
    signal_uuid,
    ts,
    queried_at
  from {{ ref("int_dset_responses__materialized") }}
  where
    ts = (select max(ts) from {{ ref("int_dset_responses__materialized") }})
),

metadata as (
  select
    valors.ts,
    valors.queried_at,
    signals.plant_name,
    signals.signal_name,
    signals.signal_uuid,
    signals.device_name,
    signals.device_type,
    signals.device_uuid,
    coalesce(valors.rebut_from_dset, false) as rebut_from_dset
  from {{ ref('raw_gestio_actius__signal_denormalized') }} as signals
    left join valors on signals.signal_uuid = valors.signal_uuid
  order by signals.plant_name, signals.signal_name
)

select * from metadata
