{{ config(materialized='view') }}

select * from {{source('plantmonitordb', 'alarm_status') }}
