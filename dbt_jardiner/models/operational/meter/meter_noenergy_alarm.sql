{{ config(materialized='table') }}

select * from {{source('plantmonitordb', 'alarm_status') }}
