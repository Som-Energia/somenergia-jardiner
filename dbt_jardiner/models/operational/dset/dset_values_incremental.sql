{{ config(materialized='incremental') }}

select * from {{ ref('dset_responses_with_signal_metadata') }}

{% if is_incremental() %}
  where ts >= coalesce((select max(ts) from {{ this }}), '1900-01-01')
{% endif %}

