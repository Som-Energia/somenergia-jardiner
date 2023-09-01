
{{ config(materialized = 'table') }}

select date_hour as start_hour
from {{ ref('spine_hours_localized')}}
where date_hour <= NOW()
