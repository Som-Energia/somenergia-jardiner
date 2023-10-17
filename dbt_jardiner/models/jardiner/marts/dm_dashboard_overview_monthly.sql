{{ config(materialized='view') }}


with production_target as (
    select
        month,
        sum(energy_production_target_mwh) as total_energy_production_target_mwh
    from {{ ref("int_production_target__monthly") }}
    group by month
), production_target_w_cumsum as (
    select
        month,
        total_energy_production_target_mwh,
        sum(total_energy_production_target_mwh) over (order by month) as total_cumsum_energy_production_target_mwh
    from production_target
), production_monthly as (
    select
        month,
        sum(energia_instantania_inversor_kwh)/1000 as total_energia_instantania_inversores_mwh,
        sum(energia_exportada_instantania_comptador_kwh)/1000 as total_energia_exportada_instantania_comptadores_mwh,
        sum(energia_exportada_comptador_kwh)/1000 as total_energia_exportada_comptadores_mwh,
        sum(energia_esperada_solargis_kwh)/1000 as total_energia_esperada_solargis_mwh,
        sum(abs(energia_perduda_kwh))/1000 as total_energia_perduda_mwh,
        max(preu_omie_e_kwh) as preu_omie_e_kwh
    from {{ ref("dm_plant_production_monthly") }}
    group by month
)
select
    production_target_w_cumsum.month,
    production_monthly.total_energia_instantania_inversores_mwh,
    production_monthly.total_energia_exportada_instantania_comptadores_mwh,
    production_monthly.total_energia_exportada_comptadores_mwh,
    sum(production_monthly.total_energia_exportada_comptadores_mwh) over (partition by extract (year from production_monthly.month) order by production_monthly.month) as total_cumsum_energia_exportada_comptadores_mwh,
    production_monthly.total_energia_esperada_solargis_mwh,
    production_monthly.total_energia_perduda_mwh,
    production_monthly.preu_omie_e_kwh,
    production_target_w_cumsum.total_energy_production_target_mwh as total_energia_objetivo_mwh,
    sum(production_target_w_cumsum.total_energy_production_target_mwh) over (partition by extract (year from production_target_w_cumsum.month) order by production_target_w_cumsum.month) as total_cumsum_energy_production_target_mwh
from production_target_w_cumsum
left join production_monthly on production_target_w_cumsum.month = production_monthly.month
