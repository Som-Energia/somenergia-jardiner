{{ config(materialized='view') }}


SELECT
    *
FROM {{ref('inverterregistry_clean')}} as ir
where time between '2022-10-01 00:00' and '2022-10-02 00:00'
and inverter_id = 16
order by time desc