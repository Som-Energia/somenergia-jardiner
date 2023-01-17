{{ config(post_hook="grant select on {{ this }} to group exiom") }}

select * from {{ ref('inverterregistry_clean') }}