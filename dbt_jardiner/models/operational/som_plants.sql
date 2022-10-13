{{ config(materialized='view') }}

SELECT
    *
FROM {{source('plantmonitor','plant')}}
where description != 'SomRenovables'