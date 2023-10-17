{{ config(materialized='view') }}


with last_registries as (
    select
        distinct on (signal_uuid)
        ts,
        plant as nom_planta,
        device as aparell,
        device_type as tipus_aparell,
        signal as senyal,
        signal_unit as unitat_senyal,
        signal_value as valor
    from {{ ref("int_dset_responses__with_signal_metadata") }} as dset
    where (device_type in ('inverter','sensor', 'string') or device_type is NULL)
    order by signal_uuid, ts desc, plant
)
select

