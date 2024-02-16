El procés és:

1. Crear un rol `Manteniment_<nom empresa>`
1. Afegir una regla [Row Level Security](https://indicadors.somenergia.coop/rowlevelsecurity/list/) <br>
![image](https://gitlab.somenergia.coop/et/somenergia-jardiner/uploads/b9ed42b43f95f2c9a527db63ebb18113/image.png)<br>
Pareu atenció al camp "clause", s'afegirà com a condició where exclusiva (and) als datasets que seleccionem.
1. Donar accés als charts d'un dashboard<br>
![image](https://gitlab.somenergia.coop/et/somenergia-jardiner/uploads/238587e65493d666317a60fee0521fa4/image.png)
1. [Afegir la o les usuàries](https://indicadors.somenergia.coop/users/list/) i assignar-los els rols [Gamma] i `[Manteniment_<nom empresa>]`

easy peasy. Ho he fet amb energes amb la clause `nom_planta in (noms plantes)`

Hem decidit a 02/2024 que no val la pena propagar l'empresa de manteniment en el pipe per a cobrir aquest use case, ja que no cal afegir 5m aquestes metadadades per a un tema de visualització i permisos. Ho gestionem en la capa de visualització.

:warning: Canvis d'empresa de manteniment s'hauran de fer al Superset (i a les metadades de la planta, per coherència).

Més Context: [#101](https://gitlab.somenergia.coop/et/somenergia-jardiner/-/issues/101) i [Trello](https://trello.com/c/mPOAsMe8/211-spike-superset)
