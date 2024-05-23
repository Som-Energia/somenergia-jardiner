-- to test to check if solargis is sending temperature all the solar hours in a day
-- Each result is a day with < 50% of not null records

{{ config(severity='warn', warn_if = '>2') }}

with validation as (
  select
    production.nom_planta,
    date_trunc('day', production.hora_inici, 'Europe/Madrid') as day_inici,
    sum((production.temperatura_modul_avg_c is null)::integer)
    / count(*)::numeric as not_null_proportion
  from {{ ref('dm_plant_production_hourly') }} as production
  where
    date_trunc('day', production.hora_inici, 'Europe/Madrid')
    > (now() at time zone 'Europe/Madrid')::date - interval '5 days'
    and production.te_plantmonitor
  group by
    production.nom_planta,
    date_trunc('day', production.hora_inici, 'Europe/Madrid')
),

validation_errors as (
  select
    nom_planta,
    day_inici,
    not_null_proportion
  from validation
  where not_null_proportion < 0.4 or not_null_proportion > 1
)

select *
from validation_errors
