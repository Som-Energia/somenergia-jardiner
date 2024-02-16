{{ config(materialized='view') }}

select
  planta as plant_name,
  enero::numeric as january,
  febrero::numeric as february,
  marzo::numeric as march,
  abril::numeric as april,
  mayo::numeric as may,
  junio::numeric as june,
  julio::numeric as july,
  agosto::numeric as august,
  septiembre::numeric as september,
  octubre::numeric as october,
  noviembre::numeric as november,
  diciembre::numeric as december,
  data_actualitzacio::date as gestio_actius_updated_at,
  dbt_updated_at::date as dbt_updated_at,
  dbt_valid_from::date as dbt_valid_from,
  coalesce(dbt_valid_to::date, '2050-01-01'::date)::date as dbt_valid_to
from {{ ref('snapshot_production_target') }}
