# Views de plantmonitor a migrar a dbt

~ marca les que segurament no cal fer, al gust

```
view_availability.sql
~view_q_hourly_debug.sql~
view_q_monthly.sql
~view_cos_phi_hourly_debug.sql~
view_cos_phi_monthly.sql
view_expected_power.sql
view_hd_daily.sql
view_ht_daily.sql
view_ht_monthly.sql
view_pr_hourly.sql
view_target_energy.sql
```

# Agregacions

No cal fer-les perquè son agraupacions que segurament farem servir mètriques de dbt tipus:

```
view_inverter_energy_daily.sql
view_inverter_energy_monthly.sql
view_meter_export_energy_daily.sql
view_meter_export_energy_monthly.sql
view_average_yearly_production_plant.sql
view_satellite_irradiation.sql
```

A més a més les mètriques de dbt resolen el problema següent:

sum(a/x) -- horaria

sum(a/x) + sum(b/y) ... mensual wrong

sum((a+b+c)/(x+y+z)) -- mensual correct


# views per limitar l'accés a la info dels tècnics

No cal fer-ho, limitarem l'accés a la wide table o farem servir els permisos del superset o ja veurem

```
view_plants_energes.sql
view_plants_energetica.sql
view_plants_ercam.sql
view_plants_exiom.sql
view_meterregistry_energetica.sql
view_inverter_energy_daily_exiom.sql
view_inverter_intensity_energes.sql
view_inverter_intensity_ercam.sql
view_inverter_intensity_exiom.sql
view_inverter_power_energes.sql
view_inverter_power_ercam.sql
view_inverter_power_exiom.sql
view_inverterregistry_energes.sql
view_inverterregistry_ercam.sql
view_inverterregistry_exiom.sql
view_inverter_temperature_exiom.sql
view_sensorirradiationregistry_energes.sql
view_sensorirradiationregistry_ercam.sql
```

# no s'han de fer (obsoletes)

```
zero_inverter_power_at_daylight.sql
zero_sonda_irradiation_at_daylight.sql
```