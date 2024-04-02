{% snapshot snapshot_signal_denormalized %}

{{
    config(
      unique_key='signal_uuid',
      strategy='timestamp',
      updated_at='updated_at',
      target_schema='lake'
    )
}}

  select * from {{ source('airbyte','gestio_actius_signal_denormalized') }}

{% endsnapshot %}
