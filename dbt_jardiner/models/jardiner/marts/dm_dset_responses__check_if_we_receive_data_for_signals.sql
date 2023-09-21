{{ config(
    materialized = 'view'
) }}

WITH valors AS (

    SELECT
        TRUE AS rebut_from_dset,
        signal_uuid
    FROM
        {{ ref('raw_dset_responses__api_response') }}
    WHERE
        ts = (
            SELECT
                MAX(ts)
            FROM
                {{ ref('raw_dset_responses__api_response') }}
        )
)
SELECT
    signals.plant,
    signals.signal,
    signals.signal_uuid,
    signals.device,
    signals.device_type,
    signals.device_uuid,
    COALESCE(
        rebut_from_dset,
        FALSE
    ) AS rebut_from_dset
FROM
    {{ ref('seed_signals__with_devices') }} AS signals
    LEFT JOIN valors
    ON signals.signal_uuid = valors.signal_uuid
ORDER BY
    plant,
    signal
