{{ config(materialized='view') }}

{# TODO airbyte is currently doing a full-refresh which drop-cascades,
we materialize this model to avoid checking if we can incremental-sync instead

but it would not happen if we DON'T normalize the data, which we don't actually need to do
https://discuss.airbyte.io/t/remove-related-views-in-full-refresh-overwrite-mode/747
#}

with recent as (
select date, create_time, price,
row_number() over (partition by date order by create_time desc) as rc
from {{source('plantlake','omie_historical_price_hour')}}
)
select date as start_hour, price
from recent
where rc = 1