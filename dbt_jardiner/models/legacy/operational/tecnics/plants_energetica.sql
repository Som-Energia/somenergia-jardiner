{{ config(post_hook="grant select on {{ this }} to group energetica") }}

select
  plant.id,
  plant.name,
  plant.codename,
  plant.municipality,
  plant.description
from plant
where plant.name in ('Valteina')
