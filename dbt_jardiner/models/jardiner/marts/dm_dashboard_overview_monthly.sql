{{ config(materialized='view') }}


with production_monthly_w_target as (
  select
    production_target.month as mes,
    plant_catalog.plant_name as nom_planta,
    plant_catalog.plant_uuid as plant_uuid,
    plant_catalog.technology as tecnologia,
    production_monthly.energia_instantania_inversor_mwh,
    production_monthly.energia_exportada_instantania_comptador_mwh,
    production_monthly.energia_exportada_comptador_mwh,
    production_monthly.energia_esperada_solargis_mwh,
    production_monthly.energia_perduda_mwh,
    production_monthly.preu_omie_eur_mwh,
    (
      sum(production_monthly.preu_omie_eur_mwh)
        over plant_year_window
    ) / extract(month from production_target.month)
    as moving_avg_preu_omie_eur_mwh,
    production_target.energy_production_target_mwh as energia_objectiu_mwh,
    sum(production_monthly.energia_exportada_comptador_mwh)
      over plant_year_window
    as cumsum_energia_exportada_comptador_mwh,
    sum(production_target.energy_production_target_mwh)
      over plant_year_window
    as cumsum_energia_objectiu_mwh
  from {{ ref("int_gda_plants__plants_catalog") }} as plant_catalog
    left join {{ ref("int_production_target__monthly") }} as production_target using (plant_uuid)
    left join {{ ref("dm_plant_production_monthly") }} as production_monthly using (plant_uuid, month)
  window plant_year_window as (partition by plant_uuid, extract(year from production_monthly.month) order by production_monthly.month)
  order by production_target.month desc, plant_catalog.plant_name desc
)
select * from production_monthly_w_target
