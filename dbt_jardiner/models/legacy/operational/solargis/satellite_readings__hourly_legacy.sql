{{ config(
    materialized = 'view'
) }}

WITH satellite AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY plant_id,
            start_hour
            ORDER BY
                request_time DESC
        ) AS ranking
    FROM
        {{ ref('satellite_readings__denormalized_legacy') }}
)

SELECT
    *
FROM
    satellite
WHERE
    ranking = 1
