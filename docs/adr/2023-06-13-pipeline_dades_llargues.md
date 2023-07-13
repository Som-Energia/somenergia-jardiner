# Pipeline de dades revisited

* Status: proposed
* Deciders: Diego, Roger, Pol
* Date: 2023-06-12

Technical Story:

https://trello.com/c/rmCTOJrH/205-decidir-com-farem-lobt-i-el-cincminutal-r%C3%A0pid

Passem a una macrotaula de dades llargues clau-valor per a les dades cincminutals?

Com serà la obt? horaria calculada un cop cada hora? I quan passem a comptadors 15-minutals, segurem amb dbt run 15-minutal? Quina frescor de les dades cal? --> posem la discussió de la obt a [un adr diferent](/adr/2023-06-13-obt_plantes)

## Context and Problem Statement

Ara que sabem molt més dbt i que incorporarem un proveïdor de dades cincminutals amb dades llargues que deprecarà l'esquema antic, ens plantegem si hauríem de basar en una macrotaula de dades llargues per les dades cincminutals.

## Decision Drivers <!-- optional -->

* Ús real del cinc-minutal
* Frescor necessària
* … <!-- numbers of drivers can vary -->

## Considered Options

1. normalitzar dset i fer un multisource normalitzat com està ara
2. desnormalitzar lo que hi ha ara i fer un multisource com ens envia dset
3. fer una pseudo-obt llarga a partir de dset i fer le multisource al mart

## Decision Outcome

Chosen option: opció 3

### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative Consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### [option 1]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### [option 2]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### [option 3]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
