{% snapshot snapshot_production_target %}

{{
    config(
      unique_key='planta',
      strategy='timestamp',
      updated_at='data_actualitzacio',
      target_schema='lake'
    )
}}

select * from {{ source('airbyte','gestio_actius_objectius_de_produccio') }}

{% endsnapshot %}
