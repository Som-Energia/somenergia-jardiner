# somenergia-jardiner
Mending and ternuring of green energy plants


## install dependencies

```bash
pip install poetry
poetry install
```

alternativelly you can do

```bash
pip install -r requirements.txt
```

## testing

just run `pytest` on the root directory

also you can test the data models with `dbt test --target pre --target-dir dbt_jardiner`

## run

`typer` will tell you what arguments you need to run the notify_alarms script. You will have to provide a dbapi string or the placeholders `prod` or `pre` which will read `.env.prod` and `.env.pre` respectivelly

`python ./jardiner/notify_alarms --help`

## deploy

deploy is in continuos delivery on main branch, but dbt models must be manually ran at the moment.

`dbt run --target prod --target-dir dbt_jardiner`

## update requirements

We use poetry to maintain the requirements, but we can update the requirements like so:

`poetry export --without=dev --without-hashes --format=requirements.txt > requirements.txt`

## update documentation

We use mkdocs to serve extra documentation and adrs

`mkdocs serve`