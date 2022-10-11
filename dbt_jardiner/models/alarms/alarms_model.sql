{{ config(materialized='view') }}

select * from {{source('plantmonitor', 'alarm_status') }}