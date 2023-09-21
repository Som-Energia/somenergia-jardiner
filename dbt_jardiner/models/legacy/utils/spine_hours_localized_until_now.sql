
{{ config(materialized = 'table') }}

select *
from {{ ref('spine_hours_localized')}}
where start_hour <= NOW()
