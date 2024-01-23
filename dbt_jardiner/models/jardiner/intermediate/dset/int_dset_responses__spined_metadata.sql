{{ config(materialized='view') }}

with spina5m as (
      select generate_series('2023-12-01', now(), '5 minutes') as ts
),
spined_expected_signals as (
    select
        spina5m.ts,
        plants.nom_planta,
        plants.plant_uuid,
        metadata.device_uuid,
        metadata.device_name,
        metadata.device_type,
        metadata.signal_name,
        metadata.signal_uuid,
        metadata.metric_name,
        metadata.device_parent
    from spina5m
    {# dm_plants is the SSOT of the plants names #}
    left join {{ ref("dm_plants") }} as plants on true
    left join {{ ref("raw_gestio_actius__signal_denormalized") }} as metadata using (plant_uuid)
),
dset_from_december_2023 as(
    select * from {{ ref("int_dset_responses__materialized_one_hour_late") }} as dset
    where dset.ts > '2023-12-01'
    {# if we don't limit queried_at the planner shits the bed #}
    and queried_at > '2023-12-01'
),
spined_dset as (
    select
        ts,
        nom_planta as plant_name,
        plant_uuid,
        device_uuid,
        device_name,
        device_type,
        signal_uuid,
        signal_name,
        metric_name,
        device_parent,
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
        valors.ts is not null as from_dset,
        valors.materialized_at
    from spined_expected_signals
    left join dset_from_december_2023 as valors using(ts, signal_uuid)
    order by ts desc, nom_planta
)
select * from spined_dset