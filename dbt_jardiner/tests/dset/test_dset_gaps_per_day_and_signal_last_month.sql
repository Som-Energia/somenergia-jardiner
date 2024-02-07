{{ config(severity="warn") }}

with
    window_observed as (
        select
            signal_value,
            group_name,
            signal_code,
            signal_id,
            signal_device_type,
            signal_uuid,
            queried_at,
            ts as current_ts,
            signal_frequency::interval as signal_frequency
        from {{ ref("int_dset_responses__materialized") }}
        where current_date - interval '1 month' < ts
          and signal_value is not null
    ),

    window_lagged as (
        select
            *,
            lag(current_ts) over (
              partition by signal_uuid
              order by current_ts asc) as previous_ts
        from window_observed
    ),

    gaps_observed as (
        select
          *,
          current_ts::date as "date",
          current_ts - previous_ts as gap
        from window_lagged
        where current_ts - previous_ts > signal_frequency
    ),

    gaps_summarized as (
        select
            "date",
            group_name,
            signal_code,
            signal_id,
            signal_device_type,
            signal_uuid,
            gap,
            signal_frequency,
            count(signal_uuid) as n_gaps
        from gaps_observed
        group by
            "date",
            group_name,
            signal_uuid,
            signal_code,
            signal_id,
            signal_device_type,
            gap,
            signal_frequency
        order by
            "date" desc,
            count(signal_uuid) desc,
            gap desc,
            group_name asc,
            signal_code asc,
            signal_id asc,
            signal_device_type asc
    ),

    gaps_converted_to_n_missing_samples as (
      select
        *,
        -- n_gaps * ceiling(gap/frequency - 1) as n_missing_samples.
        -- The -1 is because the starting point in the gap can't be counted as missing
        n_gaps * ceil(extract(epoch from gap) / extract(epoch from signal_frequency) - 1) as n_missing_samples,
        -- 24*60 are the minutes in a day
        (24 * 60) / (extract(epoch from signal_frequency) / 60) as n_samples_per_day
        from gaps_summarized
    ),

    gaps_ratio as (
      select
        *,
        n_missing_samples / n_samples_per_day as ratio_missing_samples
        from gaps_converted_to_n_missing_samples
    )

select *
from gaps_ratio
