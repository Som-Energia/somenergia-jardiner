{{ config(materialized="view") }}

with
recent as (

  select
    "date",
    create_time,
    price,
    row_number() over (partition by "date" order by create_time desc) as rc
  from {{ source("plantlake", "omie_historical_price_hour") }}
)

select
  "date" as start_hour,
  price
from recent
where rc = 1
