{{ config(materialized='view') }}

select
    *,
    date_trunc('hour', time) as time_start_hour
from (
    select
    *,
    row_number() over (partition by plant_id, date_trunc('hour', time) order by forecastdate desc) as row_number
    from {{ ref('forecasts_denormalized') }}
) forecast
where row_number=1