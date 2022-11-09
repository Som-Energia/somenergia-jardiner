{{ config(materialized='view') }}

select plant_id, max(temp), min(temp)
from {{ref('alert_inverter_temperature')}} as alert_inverter_temperature
group by plant_id
