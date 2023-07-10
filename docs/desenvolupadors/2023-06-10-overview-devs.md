# Overview for devs

## Current State of the project

### Pieces

#### repos

[Plantmonitor](https://github.com/Som-Energia/plantmonitor)

Fa d'ORM de les plantes, conté la api i és codi de les raspberrypis. A més a més també té el codi d'ingesta d'apis de tercers.

La meitat del plantmonitor acabarà deprecated pel proveïdor de dades.

[Plant Reader](https://github.com/Som-Energia/somenergia-plant-reader)

Lectura remota de les plantes. Actualment només Asomada es llegeix remotament.

Acabarà deprecated pel proveïdor de dades.

[Jardiner](https://github.com/Som-Energia/somenergia-jardiner)

dbt de les plantes. Actualment tot views.

#### Data sources

- rPIs
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

rPIs -- push 5'  --> dw[db/plants]
ERP -- pull 20' º\n meter data --> dw
SAT -- pull daily\n irr/expected energy --> dw
METEO <-- pull daily\n meter data +  irr/kWh forecast --> dw
PLANT -- pull 15'\n devices data --> dw

dw -- dbt views --> prod --> alarms
prod --> alerts
```

º: plantmonitor does it. Update rate defined at conf/startup_configuration.py

#### Planned scheme

```mermaid
flowchart LR

ERP -- pull 20' º\n meter data --> dw
SAT -- pull daily\n irr/expected energy --> dw
METEO <-- pull daily\n meter data +  irr/kWh forecast --> dw
PLANT -- pull 15'\n devices data --> dw


dw -- dbt fast --> fast[dbt_prod/fast_] --> union
dw -- dbt --> obt --> alarms
obt --> union
union -- notify.py --> alerts
```

See [Roadmap](docs/projecte/2023-06-03-macrofase%20roadmap)


