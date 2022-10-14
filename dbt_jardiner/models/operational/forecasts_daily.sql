{{ config(materialized='view') }}

select
    date_trunc('day', time_start_hour) as day,
    plant_id,
    sum(energy_kwh) as energy_kwh
FROM {{ref('forecasts_hourly')}} as srh
group by date_trunc('day', time_start_hour), plant_id
