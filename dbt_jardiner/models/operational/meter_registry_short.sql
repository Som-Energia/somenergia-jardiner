{{ config(materialized='view') }}


select *
from {{ref('meter_registry')}}
where plant_code = 'SomEnergia_Riudarenes_BR'
and time_start_hour > '2022-10-13 00:00:00+02' --select min(time) from meter_registry
and time_start_hour != '2022-10-13 06:00:00+02' --select max(time) from meter_registry
