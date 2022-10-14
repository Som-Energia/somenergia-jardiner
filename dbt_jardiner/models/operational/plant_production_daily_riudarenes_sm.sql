{{ config(materialized='view') }}

select
*
from {{ ref('plant_production_daily')}}
where plant_name ilike 'Riudarenes_SM'
order by day desc