{{ config(materialized='view') }}

with inverterregistry_last_results as (
    select *
    from {{ref('inverterregistry_clean')}} as ir
    where time between (NOW() - interval '1 hour') and NOW()
), inverterregistry_sct as (
    SELECT
        time,
        plant_id,
        plant_name,
        inverter_id,
        inverter_name,
        temperature_c as temp,
        min(temperature_c) OVER (PARTITION BY inverter_id ORDER By time ROWS BETWEEN 12 PRECEDING AND current row) AS temperature_c_min
    FROM
        inverterregistry_last_results

)

select *,  55 < temperature_c_min as alarm_inverter_temperature
from inverterregistry_sct
order by time desc
