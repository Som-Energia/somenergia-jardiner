{{ config(materialized='view') }}

SELECT
    *
FROM {{ ref('lake_modbusreadings_raw')}}
where is_valid is not true
