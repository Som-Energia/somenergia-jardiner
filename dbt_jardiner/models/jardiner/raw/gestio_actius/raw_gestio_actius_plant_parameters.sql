{{ config(materialized='view') }}

with current_data as (
    SELECT
        plant_id::numeric,
        planta as planta,
        latitut::numeric as latitude,
        longitut::numeric as longitude,
        municipi as municipality,
        provincia as province,
        tecnologia as technology,
        data_connexio::date as connection_data,
        potencia_nominal_kw::numeric as nominal_power_kw,
        potencia_pic_kw::numeric,
        owner,
        n_strings_plant::numeric,
        n_modules_string::numeric,
        n_strings_inverter::numeric,
        is_tilted::boolean,
        data_actualitzacio::date as gestio_actius_updated_at,
        dbt_updated_at::date as dbt_updated_at,
        dbt_valid_from::date as dbt_valid_from,
        coalesce(dbt_valid_to::date, '2050-01-01'::date)::date as dbt_valid_to
    FROM {{ ref('snapshot_plant_parameters') }} as pl
)
select *
from current_data
where dbt_valid_from::date <= current_date and current_date < dbt_valid_to::date