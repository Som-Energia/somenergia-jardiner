{{ config(materialized='view') }}

SELECT
    id as meter_id,
    plant as plant_id,
    name as meter_name,
    connection_protocol as meter_connection_protocol
FROM {{source('plantmonitordb','meter')}}
