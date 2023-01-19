
{{ config(materialized = 'table') }}

select
*
from {{ ref('spine_plant_meter_hourly')}} as spine
where start_hour <= NOW() - INTERVAL '1 hour'