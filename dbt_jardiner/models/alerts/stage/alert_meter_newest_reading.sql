{{ config(materialized='view') }}

with meterregistry_newest_readings as (
    select * from {{ ref('meter_registry_raw') }}
    where current_date - interval '90 day' < time
),

meter_registry_newest_reading as (
  select
    meters.*,
    mr.time as newest_reading_time
  from {{ ref('meters_with_thresholds') }} as meters
  inner join lateral (
    select
      mr.meter_id,
      time
    from meterregistry_newest_readings as mr
    where
        mr.meter_id = meters.meter_id
    order by time desc
    limit 1
  ) as mr on mr.meter_id = meters.meter_id
)

select
  *,
    case
    when mrg.meter_connection_protocol ilike 'moxa' then now() - newest_reading_time
    when mrg.meter_connection_protocol ilike 'ip' then now() - newest_reading_time
    else NULL
  end as time_from_last_reading,
  case
    when mrg.meter_connection_protocol ilike 'moxa' then now() - newest_reading_time > interval '30 hours' -- 24 hours + 6h margin
    when mrg.meter_connection_protocol ilike 'ip' then now() - newest_reading_time > interval '12 hours'
    else false
  end as alarm_no_reading
FROM meter_registry_newest_reading as mrg
inner join {{ ref('som_plants') }} as plants using(plant_id)
order by newest_reading_time desc