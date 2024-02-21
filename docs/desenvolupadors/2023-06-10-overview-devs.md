title: Overview for devs
description: Overview of the project for developers
date: 2023-06-10
tags: dbt, airflow, plantmonitor, plantreader, jardiner

# Overview for devs

## quickstart

To fully deploy the dbt models to the production schema you can do

```bash
dbt build -s tag:jardiner,tag:legacy --store-failures --full-refresh --target prod
```

You will need to have the `prod` profile in your `~/.dbt/profiles.yml` file.

## Current State of the project

### Pieces

#### repos

[Plantmonitor](https://github.com/Som-Energia/plantmonitor)

Fa d'ORM de les plantes, conté la api i és codi de les raspberrypis. A més a més també té el codi d'ingesta d'apis de tercers.

!!! warning

    La meitat del plantmonitor acabarà deprecated pel proveïdor de dades

[Plant Reader](https://github.com/Som-Energia/somenergia-plant-reader)

Lectura remota de les plantes. Actualment només Asomada es llegeix remotament i es guarda a `plant_lake`.

Acabarà deprecated pel proveïdor de dades.

Actualment també allotja la lectura de la API del proveïdor de dades.

[Jardiner](https://github.com/Som-Energia/somenergia-jardiner)

dbt de les plantes. Actualment tot views.

#### Data sources

- rPIs
- plant_reader
- Irradiation satellite data provider (SAT)
- Meteo forecast provider (METEO)
- Plant data provider (PLANT)
- Price provider (Planned) (PRICE)

#### Visualization

- redash
- novu notifications -> helpscout/mail
- superset (other àmbits of the cooperative)

### Project tructure

#### Actual

```mermaid
flowchart LR

dw[db/plants]

plants -- pull 5' \n plant_reader/dags --> lake[db/plant_lake]
lake -- push 5' \n airbyte --> dw

plants -- pull 5' \n plantmonitor/main.py --> rPIs -- push 5'  --> dw
plants -- pull 2h/12h \n meter \n ERP's import_tm_data_click.py --> ERP -- pull 20'º\n meter data --> dw
SAT -- pull dailyº\n irr/expected energy --> dw
METEO <-- pull dailyº\n meter data +  irr/kWh forecast --> dw
plants -- pull 15'\n plant_reader/dags --> PLANT -- pull 15'\n devices data --> db/plant_lake

dw -- dbt views --> prod --> alarms
prod --> alerts
prod --> datasets
```

º: plantmonitor does it. Update rate defined at conf/startup_configuration.py and each task is run as a function.

#### Planned scheme

```mermaid
flowchart LR

dw[db/plants]

plants -- pull 2h/12h \n meter \n import_tm_data_click.py --> ERP -- pull 20' º\n meter data --> dw
SAT -- pull daily\n irr/expected energy --> dw
METEO <-- pull daily\n meter data +  irr/kWh forecast --> dw
plants -- pull 15' --> PLANT -- pull 15'\n devices data --> dw


dw -- dbt fast --> fast[dbt_prod/fast_] --> union
dw -- dbt --> obt --> alarms
obt --> union
union -- notify.py --> alerts
obt --> datasets
```

Després de l'[ADR d'estructura de pipeline](../adr/2023-06-13-pipeline_dades_llargues.md)

See [Roadmap](""../projecte/2023-06-03-macrofase roadmap.md")
