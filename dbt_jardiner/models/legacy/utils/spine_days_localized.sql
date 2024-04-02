{{ config(materialized = 'table') }}

select date_day at time zone 'Europe/Madrid' as day
from {{ ref('spine_days') }}
