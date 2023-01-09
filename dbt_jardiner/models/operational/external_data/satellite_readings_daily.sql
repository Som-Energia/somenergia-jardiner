{{ config(materialized='view') }}

select
    date_trunc('day', time_start_hour) as day,
    plant_id,
    sum(horizontal_irradiation_wh_m2) as horizontal_irradiation_wh_m2,
    sum(tilted_irradiation_wh_m2) as tilted_irradiation_wh_m2,
    round(avg(module_temperature_dc),2) as module_temperature_dc_mean,
    sum(energy_output_kwh) as energy_output_kwh,
    count(*) as hours_with_reading
FROM {{ref('satellite_readings_hourly')}} as srh
group by date_trunc('day', time_start_hour), plant_id

