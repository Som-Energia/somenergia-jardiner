
{{ config(materialized = 'table') }}

select
*
from {{ ref('spine_plant_meter_daily')}} as spine
where day <= NOW()