{{ config(
    materialized = 'view'
) }}

WITH forecast_denormalized AS (

    SELECT
        forecast.time AS "time",
        forecastmetadata.plant AS plant_id,
        forecastmetadata.forecastdate AS forecastdate,
        ROUND(
            forecast.percentil50 / 1000.0,
            2
        ) AS energy_kwh
    FROM
        {{ source(
            'meteologica',
            'forecast'
        ) }}
        LEFT JOIN {{ source(
            'meteologica',
            'forecastmetadata'
        ) }}
        ON forecastmetadata.id = forecast.forecastmetadata
)
SELECT
    *
FROM
    forecast_denormalized
