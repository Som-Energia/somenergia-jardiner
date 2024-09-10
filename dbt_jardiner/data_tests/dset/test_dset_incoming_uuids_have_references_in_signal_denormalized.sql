{{ config(severity="warn") }}

with
child as (
  select
    *,
    signal_uuid as signal_uuid_dset
  from {{ ref("int_dset_responses__materialized") }}
  where
    signal_uuid is not null
    {# limit test backcheck to speed up testing #}
    and queried_at > now() - interval '1 month'
),

parent as (
  select signal_uuid as signal_uuid_som
  from {{ ref("raw_gestio_actius__signal_denormalized") }}
),

joined as (
  select
    child.*,
    parent.*
  from child
    left join parent on child.signal_uuid_dset = parent.signal_uuid_som
),

unified as (
  select distinct on (signal_uuid_dset, signal_uuid_som)
    *,
    case
      when signal_uuid_som is null then 'missing_from_som'
      when signal_uuid_dset is null then 'extra_from_dset'
      else 'ok'
    end as status
  from joined
),

filtered as (
  select *
  from unified
  where status != 'ok'
)

select * from filtered
