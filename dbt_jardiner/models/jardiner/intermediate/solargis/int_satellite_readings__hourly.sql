{{ config(
    materialized = 'view'
) }}

with satellite as (

  select
    *,
    row_number() over (
      partition by
        plant_id,
        start_hour
      order by
        request_time desc
    ) as ranking
  from
    {{ ref('int_satellite_readings__denormalized') }}
)

select *
from
  satellite
where
  ranking = 1
