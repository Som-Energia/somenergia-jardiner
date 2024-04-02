{{ config(materialized='view') }}

select * from {{ ref('stringregistry_denormalized') }}
where now() - interval '1 hour' < time
