{{ config(materialized='view') }}

select
  plant,
  date_trunc(
    'day', "time" at time zone 'Europe/Madrid'
  ) at time zone 'Europe/Madrid' as "time",
  count(*) as hd
from {{ ref('view_pr_hourly') }}
where pr_hourly > 0.70
group by date_trunc('day', "time" at time zone 'Europe/Madrid'), plant
