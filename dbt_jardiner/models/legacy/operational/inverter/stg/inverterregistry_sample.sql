{{ config(materialized='view') }}


select *
from {{ ref('inverterregistry_clean') }}
where
  time between '2022-10-01 00:00' and '2022-10-02 00:00'
  and inverter_id = 16
