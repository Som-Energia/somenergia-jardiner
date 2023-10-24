{{ config(materialized='view') }}

with spine as (
  select generate_series(current_date::timestamptz, current_date + interval '1 day - 1 hour', '1 hour') as start_hour
), today_hourly as (
    select
        hora_inici,
        tecnologia,
        sum(energia_instantania_inversor_kwh) as energia_instantania_inversor_kwh,
        sum(energia_exportada_instantania_comptador_kwh) as energia_exportada_instantania_comptador_kwh,
        max(preu_omie_eur_mwh) as preu_omie_eur_mwh
    from {{ ref("dm_plant_production_hourly") }}
    where current_date <= hora_inici and hora_inici < current_date + interval '1 day'
    group by hora_inici, tecnologia
)
select
    *
from spine
left join today_hourly
    on today_hourly.hora_inici = spine.start_hour
order by start_hour desc
