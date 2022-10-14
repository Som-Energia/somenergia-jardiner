
{{ config(materialized = 'table') }}

select date_day at time zone 'Europe/Madrid' as date_day
from {{ ref('spine_days')}}