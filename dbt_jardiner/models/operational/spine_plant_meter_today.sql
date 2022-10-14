
{{ config(materialized = 'table') }}

select
*
from {{ ref('spine_plant_meter')}} as spine
where date_day <= NOW()