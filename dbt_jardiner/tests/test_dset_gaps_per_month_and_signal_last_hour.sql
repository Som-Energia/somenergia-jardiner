{{ config(severity="warn") }}

with
    window_observed as (
        select
            group_name,
            signal_code,
            signal_id,
            signal_device_type,
            signal_uuid,
            queried_at,
            ts as current_ts,
            signal_frequency::interval as signal_frequency,
            lag(ts) over (partition by signal_uuid order by ts asc) as previous_ts
        from {{ ref("int_dset_responses__view_current_hour") }}
    ),

    gaps as (
        select
          *,
          current_ts - previous_ts as gap,
          extract('year' from current_ts) as "year",
          extract('month' from current_ts) as "month"
        from window_observed
        where current_ts - previous_ts > signal_frequency
          and current_date - interval '1 day' < current_ts
    ),

    summarized as (
        select
            group_name,
            signal_code,
            signal_id,
            signal_device_type,
            signal_uuid,
            gap,
            signal_frequency,
            "year",
            "month",
            max(queried_at) as last_queried_at,
            max(current_ts) as last_current_ts,
            max(queried_at - current_ts) as max_waiting_time,
            min(queried_at - current_ts) as min_waiting_time,
            count(signal_uuid) as n_gaps
        from gaps
        group by
            group_name,
            signal_uuid,
            signal_code,
            signal_id,
            signal_device_type,
            gap,
            signal_frequency,
            "year",
            "month"
        order by
            count(signal_uuid) desc,
            gap desc,
            group_name asc,
            signal_code asc,
            signal_id asc,
            signal_device_type asc,
            "year" desc,
            "month" asc
    ),

    gap_converted as (
      select
        *,
        {#- n_gaps * ceiling(gap/frequency - 1) as n_missing_samples.
        The -1 is because the starting point in the gap can't be counted as missing #}
        n_gaps * ceil(extract(epoch from gap) / extract(epoch from signal_frequency) - 1) as n_missing_samples
        from summarized
    )

select *
from gap_converted
