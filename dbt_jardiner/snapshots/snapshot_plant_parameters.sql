{% snapshot snapshot_plant_parameters %}

{{
    config(
      unique_key='plant_id',
      strategy='timestamp',
      updated_at='data_actualitzacio',
      target_schema='lake'
    )
}}

select * from {{ source('airbyte','gestio_actius_dades_fixes') }}

{% endsnapshot %}
