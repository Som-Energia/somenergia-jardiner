{{ config(materialized='view') }}

select
    date_trunc('day', time_start_hour),
    plant,
    sum(global_horizontal_irradiation_wh_m2) as global_horizontal_irradiation_wh_m2,
    sum(global_tilted_irradiation_wh_m2) as global_tilted_irradiation_wh_m2,
    avg(module_temperature_dc) as module_temperature_dc_mean,
    sum(photovoltaic_energy_output_wh) as photovoltaic_energy_output_wh
FROM {{ref('satellite_readings_hourly')}} as srh
group by date_trunc('day', time_start_hour), plant

