{{ config(materialized='view') }}


with inverterregistry_sct as (
  select
    time,
    plant_id,
    plant_name,
    inverter_id,
    inverter_name,
    temperature_c as temp, --noqa: RF04
    min(temperature_c)
      over (
        partition by inverter_id
        order by time rows between 12 preceding and current row
      )
    as temperature_c_min
  from
    {{ ref('inverterregistry_clean') }}

)

select * from inverterregistry_sct
where 55 < temperature_c_min
