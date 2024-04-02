{{ config(materialized='view') }}

with threshold_values as (
  select thv.* from (
    values
    ('Manlleu_Piscina', 4, 'hours'),
    ('Manlleu_Pavello', 4, 'hours'),
    ('Torrefarrera', 4, 'hours'),
    ('Lleida', 4, 'hours'),
    ('Picanya', 1, 'single_hour')
  ) as thv (plant_name, num_hours_threshold, threshold_type)
)

select * from threshold_values
