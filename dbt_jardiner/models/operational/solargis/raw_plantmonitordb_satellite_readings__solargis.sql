{{ config(materialized='view') }}

with source as (
      select * from {{ source('plantmonitordb', 'satellite_readings') }}
),
renamed as (
    select
        {{ adapter.quote("time") }},
        {{ adapter.quote("plant") }},
        {{ adapter.quote("global_horizontal_irradiation_wh_m2") }},
        {{ adapter.quote("global_tilted_irradiation_wh_m2") }},
        {{ adapter.quote("module_temperature_dc") }},
        {{ adapter.quote("photovoltaic_energy_output_wh") }},
        {{ adapter.quote("source") }},
        {{ adapter.quote("request_time") }}

    from source
)

select * from renamed
