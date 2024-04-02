{{ config(materialized = 'table') }}

select date_hour at time zone 'Europe/Madrid' as start_hour
from {{ ref('spine_hours') }}
