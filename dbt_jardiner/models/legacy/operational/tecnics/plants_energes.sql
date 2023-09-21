{{ config(post_hook="grant select on {{ this }} to group energes") }}

SELECT plant.id,
    plant.name,
    plant.codename,
    plant.municipality,
    plant.description
FROM plant
WHERE plant.name in ('Florida', 'Alcolea', 'Matallana')