# Pipeline de dades revisited

* Status: proposed
* Deciders: Dades
* Date: 2023-09-12


## Context and Problem Statement

En el seu moment vam triar redash perquè podia tenir apis com a sources i el dev és molt més còmode perquè no està tant layeritzat (dataset/query - chart - dashboard).

A la pràctica no hem fet servir mai la lectura directa de les apis perquè les autèntificacions no estaven suportades, ens agradava tenir una còpia, t'obligava a treballar en queries de l'sqlite de redash.

A més a més, redash delega la gestió d'usuaris a la db, cosa que implica que no pots limitar que un usuari pugui veure uns valors d'una query i no uns altres, per exemple filtrar per plantes la producció, els permisos es fan a nivell de db.

La macrofase de plantmonitor i l'evolució de l'equip de dades cap a superset amb els altres equips ens porta a replantejar-nos-ho.

Iniciem un spike de superset per a fer els nous dashboards.

## Decision Drivers <!-- optional -->

* Ús real del cinc-minutal
* Frescor necessària
* … <!-- numbers of drivers can vary -->

## Considered Options

1. superset
2. redash
3. metabase -- en Diego comenta que en la versió free no tens la capa semàntica

## Decision Outcome

Chosen option: ?

### Positive Consequences

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative Consequences

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options

### redash

👍

mustache

definir parametres a nivell de default de charts, de chart especific o dashboard

👎

no apte per heavy duty (cache regular)

### superset

👍

cohesió cooperativa -- tota la cooperativa fa servir superset

👎

No pots fixar filtres a nivell de chart al dashboard, cal fer-ne una còpia. Implica que
si volem canviar com s'ensenya un chart de planta, els haurem de canviar tots un a un.

El jinja és funky. No és clar com fer servir el "filter_values" a dins d'una query.
Les queries dinàmiques són molt menys directes de fer que al redash.