{#
    Some plants have inverters that register 3 phases of power, instead of a single active power.
    Test to check that these three-phase inverters receive all 3 signals on each ts. If all
    3 signals are not received, it is not possible to calculate the active power of the ts.
#}

{{ config(severity="warn") }}

with
    last_week as (
        select ts, plant_name, metric_name, device_uuid, signal_id, signal_code, signal_uuid
        from {{ ref("int_dset_responses__with_signal_metadata") }}
        where ts > now() - interval '1 day'
    ),

    three_phase as (
        select
            ts,
            plant_name,
            device_uuid,
            count(*) as phase_count,
            array_agg(signal_id) as signal_ids,
            array_agg(signal_code) as signal_codes,
            array_agg(signal_uuid) as signal_uuids
        from last_week
        where metric_name ilike 'potencia_activa_fase_%'
        group by ts, plant_name, device_uuid
        order by ts, plant_name, device_uuid
    ),

    missing_threephase_powers as (
      select *
      from three_phase
      where phase_count != 3
    )

select *
from missing_threephase_powers
