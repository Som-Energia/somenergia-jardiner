{{ config(materialized='view') }}

{# TODO what is this lonely select below and how did the CI/CD not catch it? #}

with last_registries as (
    select
        distinct on (signal_uuid)
        ts,
        plant_name as nom_planta,
        device_name as aparell,
        device_type as tipus_aparell,
        signal_name as senyal,
        signal_unit as unitat_senyal,
        signal_value as valor
    from {{ ref("int_dset_responses__values_incremental") }} as dset
    where device_type in ('inverter','sensor', 'string')
    order by signal_uuid, ts desc, plant_name
)
select

