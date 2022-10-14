# [short title of solved problem and solution]

* Status: [proposed | rejected | accepted | deprecated | … | superseded by [ADR-0005](0005-example.md)] <!-- optional -->
* Deciders: [list everyone involved in the decision] <!-- optional -->
* Date: [YYYY-MM-DD when the decision was last updated] <!-- optional -->

Technical Story: [description | ticket/issue URL] <!-- optional -->

## Context and Problem Statement

Les alarmes de comptadors s'han de notificar.

## Decision Drivers <!-- optional -->

coberts:
* moxa ens arriben les lectures cada 24h
* hi ha comptadors sense lectures durant temps
* la notificació diuen que la volen un cop al dia al llegir del moxa

* també volem notificacions de quant s'ha arreglat una planta que estava en alarma

## Considered Options

* fer un post per cada planta un cop cada 24h amb el resum de l'estat de les alarmes [OK|NOK]
* tenir una taula de canvis d'estat i notificar-la
* guardar la taula i fer un diff al dia seguent

## Decision Outcome



### Positive Consequences


### Negative Consequences

* rebran un e-mail cada dia si hi ha un comptador que no va o reporta 0
--> poden desubstriure's de l'alarma

podem

## Pros and Cons of the Options <!-- optional -->

### guardar taula i fer diff

* guardar la taula i fer un diff al dia seguent

ho farem amb un pandas/sql fàcil per no posar dbt a producció encara

--> ho acabarà fent dbt a mig termini


## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
