{{ config(materialized='view') }}


with inverterregistry_sct as (
    SELECT
        time,
        plant_id,
        plant_name,
        inverter_id,
        inverter_name,
        temperature_c as temp,
        min(temperature_c) OVER (PARTITION BY inverter_id ORDER By time ROWS BETWEEN 12 PRECEDING AND current row) AS temperature_c_min
    FROM
        {{ref('inverterregistry_clean')}}

)

select * from inverterregistry_sct
where 55 < temperature_c_min
order by time desc
