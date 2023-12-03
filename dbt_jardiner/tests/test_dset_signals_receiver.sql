{{ config(error_if=">1000") }}

with
    valors as (
        select true as rebut_from_dset, signal_uuid
        from {{ ref("int_dset_responses__union_view_and_materialized") }}
        where ts = (select max(ts) from {{ ref("int_dset_responses__union_view_and_materialized") }})
    ),

    final as (
        select
            signals.plant_uuid,
            signals.plant_name,
            signals.signal_name,
            signals.signal_uuid,
            signals.device_name,
            signals.device_type,
            signals.device_uuid,
            coalesce(rebut_from_dset, false) as rebut_from_dset
        from {{ ref("raw_gestio_actius__signal_denormalized") }} as signals
        left join valors on signals.signal_uuid = valors.signal_uuid
        order by plant_name
    )

select *
from final
where rebut_from_dset is false
