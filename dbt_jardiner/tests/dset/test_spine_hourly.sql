{{ config(enabled=false) }}

{# TODO to be checked its correct! #}

with dst_change as (
    select * from {{ ref('spine_hourly') }}
    where
        start_hour between '2022-03-27 01:00+02'::timestamptz and '2022-03-27 03:00+02'::timestamptz
        or start_hour between '2022-10-30 01:00+02'::timestamptz and '2022-10-30 03:00+02'::timestamptz
),

dst_count_summer as (
    select
        'summer' as dst,
        count(*) as num_hours
    from dst_change
    where
        start_hour between '2022-03-27 01:00+02'::timestamptz and '2022-03-27 03:00+02'::timestamptz
),

dst_count_winter as (
    select
        'winter' as dst,
        count(*) as num_hours
    from dst_change
    where
        start_hour between '2022-10-30 01:00+02'::timestamptz and '2022-10-30 03:00+02'::timestamptz
)

select * from dst_count_summer
where num_hours != 4
union
select * from dst_count_winter
where num_hours != 2
