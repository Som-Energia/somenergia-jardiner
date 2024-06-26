{{ config(materialized='view') }}
-- Alcolea. Objectiu mensual d'energia produïda (independentment de l'any)
select energy_target.* from (
  values
  ('2020-01-01'::timestamptz, 221730),
  ('2020-02-01', 228929),
  ('2020-03-01', 320482),
  ('2020-04-01', 300308),
  ('2020-05-01', 342791),
  ('2020-06-01', 333266),
  ('2020-07-01', 361993),
  ('2020-08-01', 344381),
  ('2020-09-01', 318789),
  ('2020-10-01', 279877),
  ('2020-11-01', 200209),
  ('2020-12-01', 199275)
) as energy_target (month, energy)
