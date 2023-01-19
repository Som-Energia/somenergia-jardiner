{{ config(post_hook="grant select on {{ this }} to group energetica") }}

SELECT plant.id,
    plant.name,
    plant.codename,
    plant.municipality,
    plant.description
FROM plant
WHERE plant.name in ('Valteina')