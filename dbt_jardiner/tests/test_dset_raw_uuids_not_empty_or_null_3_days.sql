{{ config(severity="warn", store_failures=true) }}

with
    dbt_subquery as (
        select *
        from {{ ref("raw_dset_responses__api_response") }}
        where current_date - interval '3 days' < queried_at
    ),

    all_values as (
      select *,
      trim(signal_uuid) = '' as signal_uuid_is_empty,
      signal_uuid is null as signal_uuid_is_null
      from dbt_subquery
    ),

    errors as (
      select *
      from all_values
      where signal_uuid_is_empty is true
         or signal_uuid_is_null is true
    )

select *
from errors
