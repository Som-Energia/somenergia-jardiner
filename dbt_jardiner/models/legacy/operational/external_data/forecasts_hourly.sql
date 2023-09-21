{{ config(
    materialized = 'view'
) }}

SELECT
    *,
    DATE_TRUNC(
        'hour',
        "time"
    ) AS time_start_hour
FROM
    (
        SELECT
            *,
            ROW_NUMBER() OVER (PARTITION BY plant_id, DATE_TRUNC('hour', "time")
        ORDER BY
            forecastdate DESC) AS ranking
        FROM
            {{ ref('raw_energy_forecasts__denormalized_from_plantmonitordb') }}
    ) forecast
WHERE
    ranking = 1
