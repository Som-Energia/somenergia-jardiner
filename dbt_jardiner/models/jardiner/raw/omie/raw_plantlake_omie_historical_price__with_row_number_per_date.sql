{{ config(
    materialized = 'view'
) }}
{#
todo airbyte IS currently doing A full - refresh which DROP - cascades,
we materialize this model TO avoid checking if we can incremental - sync instead but it would NOT happen if we don 'T normalize the data, which we don' t actually need TO DO https:// discuss.airbyte.io / t / remove - related - VIEWS - IN - full - refresh - overwrite - MODE / 747 #}
WITH recent AS (

    SELECT
        "date",
        create_time,
        price,
        ROW_NUMBER() OVER (
            PARTITION BY "date"
            ORDER BY
                create_time DESC
        ) AS rc
    FROM
        {{ source(
            'plantlake',
            'omie_historical_price_hour'
        ) }}
)

SELECT
    "date" AS start_hour,
    price
FROM
    recent
WHERE
    rc = 1
