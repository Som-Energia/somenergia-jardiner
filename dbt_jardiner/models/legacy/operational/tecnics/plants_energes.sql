{{ config(post_hook="grant select on {{ this }} to group energes") }}

select
  plant.id,
  plant.name,
  plant.codename,
  plant.municipality,
  plant.description
from plant
where plant.name in ('Florida', 'Alcolea', 'Matallana')
