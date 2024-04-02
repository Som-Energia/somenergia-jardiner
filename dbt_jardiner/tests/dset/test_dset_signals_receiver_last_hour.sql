{{ config(error_if=">500") }}
{# error limit is set on half the number of signal uuids available #}

with
uuids_received_recently as (
  select
    signal_uuid,
    true as is_received_recently,
    max(ts) as last_received_ts
  from {{ ref("int_dset_responses__materialized") }}
  where ts >= (now() - interval '2 hours')
  group by signal_uuid
  {# interval used of two hours is depending on the natural delay of dset data + materialization cycle -#}



),

uuids_expected as (
  select
    s.plant_uuid,
    s.plant_name,
    s.signal_name,
    s.signal_uuid,
    s.device_name,
    s.device_type,
    s.device_uuid,
    coalesce(r.is_received_recently, false) as received_from_dset
  from {{ ref("raw_gestio_actius__signal_denormalized") }} as s
    left join uuids_received_recently as r
      on s.signal_uuid = r.signal_uuid
  order by s.plant_name
),

uuids_not_received as (
  select *
  from uuids_expected
  where received_from_dset is false
)

select * from uuids_not_received
