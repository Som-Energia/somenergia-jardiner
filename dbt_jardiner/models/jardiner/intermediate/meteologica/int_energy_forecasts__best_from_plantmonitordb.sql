{{ config(
    materialized = 'view',
) }}

{# TODO check that this selects the previous day or the same day forecast #}

WITH forecasts_denormalized AS (
    SELECT
        *
    FROM
        {{ ref('raw_energy_forecasts__denormalized_from_plantmonitordb') }}
)
SELECT
    DISTINCT
    ON(
        plant_id,
        "time"
    ) forecastdate,
    "time" - INTERVAL '1 hour' AS start_hour,
    plant_id,
    energy_kwh
FROM
    forecasts_denormalized fd
ORDER BY
    plant_id,
    "time" DESC,
    forecastdate DESC
