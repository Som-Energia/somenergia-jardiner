select
  id as plantparameters_id,
  plant as plant_id,
  connection_date,
  n_strings_plant,
  n_strings_inverter,
  n_modules_string,
  month_theoric_pr_cpercent,
  year_theoric_pr_cpercent,
  peak_power_w / 1000 as peak_power_kw,
  nominal_power_w / 1000 as nominal_power_kw,
  inverter_loss_mpercent::float / 1000000.0 as inverter_loss_ratio,
  meter_loss_mpercent::float / 1000000.0 as meter_loss_ratio,
  target_monthly_energy_wh / 1000000 as target_monthly_energy_mwh,
  historic_monthly_energy_wh / 1000000 as historic_monthly_energy_mwh
from {{ source('plantmonitor_legacy', 'plantparameters') }}
