select
  yearly.plant_id,
  yearly.plant,
  yearly.time_year as "time",
  avg(yearly.export_energy_mwh) as historic_avg
from (
  select
    plant.id as plant_id,
    plant.name as plant,
    avg(meterregistry.export_energy_wh)
    / 1000000.0
    * 24::numeric
    * 365::numeric as export_energy_mwh,
    date_trunc('year'::text, meterregistry."time") as time_year,
    date_part('year'::text, meterregistry."time") as year
  from meterregistry
    left join meter on meterregistry.meter = meter.id
    left join plant on meter.plant = plant.id
  where
    meterregistry."time" is not null
    and date_part('year'::text, meterregistry."time")
    < date_part('year'::text, now())
  group by
    plant.id,
    plant.name,
    (date_trunc('year'::text, meterregistry."time")),
    (date_part('year'::text, meterregistry."time"))
) as yearly
group by yearly.plant_id, yearly.plant, yearly.time_year
