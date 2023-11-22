{{ config(materialized="view") }}

with
    window_ as (
        select
            group_name,
            signal_uuid,
            ts,
            signal_frequency::interval as signal_frequency,
            lag(ts) over (partition by signal_uuid order by ts asc) as lag_
        from {{ ref("int_dset_responses__union_view_and_materialized") }}
    ),

    delta_ as (
        select *, ts - lag_ as delta
        from window_
        where ts - lag_ > signal_frequency and current_date - interval '1 day' < ts
    ),

    summarized as (
        select
            group_name,
            signal_uuid,
            delta,
            extract('year' from ts) as "year",
            extract('month' from ts) as "month",
            count(signal_uuid) as count_signal_uuid
        from delta_
        group by signal_uuid, delta, extract('year' from ts), extract('month' from ts), group_name
        order by group_name, extract('year' from ts) desc, extract('month' from ts) asc
    )

select *
from summarized
