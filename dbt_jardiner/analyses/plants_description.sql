-- to generate the seed for plants_descriptions.csv
select
  p.id as plant_id,
  p.name as plant_name,
  p2.latitude as latitude,
  p2.longitude as longitude,
  p3.connection_date as connection_date,
  false as is_tilted,
  p3.peak_power_w / 1000 as peak_power_kw,
  p3.nominal_power_w / 1000 as nominal_power_kw,
  case
    when p.name = 'Torregrossa' then 'GAS'
    when p.name = 'Valteina' then 'HIDRO'
    else 'FV'
  end as technology,
  p3.target_monthly_energy_wh / 100 as target_monthly_energy_gwh,
  case
    when
      p.name in ('Florida', 'Alcolea', 'Matallana') then 'energes'
    when
      p.name in ('Valteina') then 'energetica'
    when
      p.name in ('Fontivsolar') then 'ercam'
    when
      p.name in ('Llanillos', 'Asomada') then 'exiom'
  end as propietari
from
  public.plant as p
  left join
    public.plantparameters as p3
    on
      p.id = p3.plant
  left join
    public.plantlocation as p2
    on
      p.id = p2.plant
where
  plant.description != 'SomRenovables'
order by
  p.id
;
