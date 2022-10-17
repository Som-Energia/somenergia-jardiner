{{ config(materialized='view') }}

select
    day,
    plant_id,
    plant_name,
    device_type,
    device_name,
    alarm_name,
    is_alarmed
from {{ref('alarm_everything')}}
where (CURRENT_DATE - 1) = day