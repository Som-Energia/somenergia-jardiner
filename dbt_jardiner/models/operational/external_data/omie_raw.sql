{{ config(materialized='view') }}

SELECT
    date as start_hour,
    price
FROM {{source('plantlake','omie_historical_price_hour')}}