{{ config(materialized="view") }}

with
    current_data as (
        select
            plant_id::numeric,
            plant_uuid::uuid,
            case
                when planta = 'Vallehermoso' then 'Alcolea'
                when planta = 'Tahal' then 'Terborg'
                else planta
            end as plant_name,
            latitud::numeric as latitude,
            longitut::numeric as longitude,
            municipi as municipality,
            provincia as province,
            tecnologia as technology,
            subtecnologia as subtechnology,
            data_connexio::date as connection_date,
            potencia_nominal_kw::numeric as nominal_power_kw,
            potencia_pic_kw::numeric as peak_power_kw,
            spv as "owner",
            empresa_manteniment as maintenance_company,
            responsable_ga as manager,
            n_strings_plant::numeric,
            n_modules_total::numeric,
            n_inverters::numeric,
            esquema_unifilar,
            layout,
            data_actualitzacio::date as gestio_actius_updated_at,
            dbt_updated_at::date as dbt_updated_at,
            dbt_valid_from::date as dbt_valid_from,
            coalesce(dbt_valid_to::date, '2050-01-01'::date)::date as dbt_valid_to
        from {{ ref("snapshot_plant_parameters") }} as pl
    )
select *
from current_data
where dbt_valid_from::date <= current_date and current_date < dbt_valid_to::date
