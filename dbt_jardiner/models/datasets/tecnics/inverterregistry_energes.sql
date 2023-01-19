{{ config(post_hook="grant select on {{ this }} to group energes") }}

select * from {{ ref('inverterregistry_clean') }}
where plant_id in (select id from {{ ref('plants_energes') }})