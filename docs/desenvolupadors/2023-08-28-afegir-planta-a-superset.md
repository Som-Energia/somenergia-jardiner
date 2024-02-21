title: Afegir dades de planta des de DSET a dashboards
description: Com afegir una planta (dset)
date: 2023-08-28

# Com afegir dades d'una planta nova a instància de superset

Tenim una instància de [superset](https://indicadors.somenergia.coop) que mostra dades de plantes des de el pipe de transformació de dades arribant del nostre proveïdor de dades.

Per afegir una nova planta a la visualització, cal seguir un protocol documentat al [Formulari d’inscripció de noves plantes a Superset](https://docs.google.com/document/d/172qofxlvavQhdQhyJ9HE73CX6YLVYA2u6Mq3w_NOzyA/edit#heading=h.mcehna5jn0kc)

Un cop aquest formulari estigui completat, cal seguir els següents passos:

!!! warning "Necessites permisos d'administrador"

    Aquesta tasca és per a desenvolupadors que treballen amb el pipe de transformació de dades. Si no ets un desenvolupador, no cal que facis aquesta tasca.

1. Verificar que estem rebent dades dels senyals de la planta nova des de l'API del proveïdor. Si no, avisar a l'equip de gestió d'actius per que facin incidència al proveïdor.
2. Executar la tasca de sync de l'airbyte d'uuids
   1. [Dades fixes de plantes noves](https://airbyte.moll.somenergia.coop/workspaces/12f265b4-e398-44b4-9c95-1b5b165d6883/connections/e3301299-f721-4efb-b864-0e5b0233b145)
   2. [Objectius de producció](https://airbyte.moll.somenergia.coop/workspaces/12f265b4-e398-44b4-9c95-1b5b165d6883/connections/e5a12532-7c8b-4e12-a7ee-9b71f47c655a/status)
   3. [Relacions entre UUIDs de senyals, aparells i plantes](https://airbyte.moll.somenergia.coop/workspaces/12f265b4-e398-44b4-9c95-1b5b165d6883/connections/6ee76168-27ab-4ac4-9f50-b619664191db/status)
3. Executar `dbt snapshot` per tractar canvis a les plantes segons SCD2, si ni ha hagut. Tenir cura que al actualitzar les dades de la planta, s'ha de modificar les columnes del tipus `updated_at` dins dels documents a omplir.
4. Verificar que les dades apareixen a la visualització de superset.
5. Actualitzar els filtres i els rols de seguretat de la nova planta a superset. Veure [Row Level Security](2024-02-16-row-level-security.md) per més informació.

!!! info Per què no un ORM?

    Tenim al roadmap fer-ho amb un model normalitzat, però està al roadmap del ERP i no tenim una data concreta.

    Com que ja no tenim ORM que verifiqui la integritat de les dades, tenim tests que compleixen aquesta funció.

    Si algun senyal d'un device no té una definició igual de device (per uuid), els tests no passaran.
    Per a veure quin senyal és el transgressor, executeu amb el flag `--store-failures`
    i així guardarà el resultat de la query del test en una taula sota l'schema `<schema>_dbt_test__audit`

    En particular, podeu veure `test_to_debug_device_uuid_errors` per veure les senyals que no quadren.

