{{ config(materialized='view') }}

select * from {{ source('plantmonitor_legacy', 'alarm_status') }}
