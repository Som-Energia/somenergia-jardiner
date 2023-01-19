{{ config(post_hook="grant select on {{ this }} to group energetica") }}

select * from {{ ref('inverterregistry_clean') }}
where plant_id in (select id from {{ ref('plants_energetica') }})