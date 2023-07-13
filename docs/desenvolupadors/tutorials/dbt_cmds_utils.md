# dbt commands

1. Generar i servir la documentació per a poder veure el directed graph.

```bash
dbt docs generate --project-dir dbt_jardiner --target pre

dbt docs serve --project-dir dbt_jardiner --target pre --port 8010
```

2. Pujar tots els CSVs de seeds

```bash
dbt seed --project-dir dbt_jardiner
```

3. Podem passar variables per command line (en comptes de definir-les a dbt_project.yml i fer-les accesibles per diferents resources):

```bash
dbt run --vars '{"variable":"value"}'
```
Per fer testing amb un csv determinat:

```bash
dbt run --project-dir project_x --target testing --vars '{"test_sample":"nom_del_csv"}' -m model_x
```