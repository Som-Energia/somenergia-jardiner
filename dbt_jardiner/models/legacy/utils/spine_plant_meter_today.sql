{{ config(materialized = 'table') }}

select *
from {{ ref('spine_plant_meter_daily') }}
where day <= now()
