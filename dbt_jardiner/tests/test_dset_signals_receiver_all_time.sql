{{ config(error_if=">1000") }}

with
    valors as (
        select
          signal_uuid,
          true as received_from_dset_pre
        from {{ ref("int_dset_responses__materialized") }}
        where ts = (select max(ts) from {{ ref("int_dset_responses__materialized") }})
    ),

    joined as (
        select
            signals.plant_uuid,
            signals.plant_name,
            signals.signal_name,
            signals.signal_uuid,
            signals.device_name,
            signals.device_type,
            signals.device_uuid,
            coalesce(valors.received_from_dset_pre, false) as received_from_dset
        from {{ ref("raw_gestio_actius__signal_denormalized") }} as signals
        left join valors on signals.signal_uuid = valors.signal_uuid
        order by signals.plant_name
    ),

    filtered as (
      select *
      from joined
      where received_from_dset is false
    )

select * from filtered
