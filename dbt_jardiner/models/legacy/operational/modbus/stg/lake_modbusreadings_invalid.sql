{{ config(materialized='view') }}

select *
from {{ ref('lake_modbusreadings_raw') }}
where is_valid is not true
