# somenergia-jardiner

Mending and nurturing of green energy plants

## Usuàries de Gestió d'actius

Gestió d'actius! Aneu [aquí](/docs/gestio-d'actius/)

SomEnergia Devs! Aneu [aquí](/docs/desenvolupadors/)

## install dependencies

The appropriate way to install poetry is in its own isolated environment

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

Otherwise [poetry will delete itself](https://github.com/python-poetry/poetry/issues/3957) when running `poetry install --sync`


alternativelly you can do

```bash
pip install -r requirements.txt
```

Check the poetry documentation for more, shortlist `poetry add <package>` to add package, `poetry install` to install `poetry.lock` packages
and `poetry show --tree` will show the dependencies tree. Additionally `deptry .` will analyze the project and find inconsistencies between project and dependencies.

If you get wheel errors on manylinux2014, update your `pip` to solve it. `poetry` doesn't fetch wheels from manylinux2014. `orjson` will cause this issue with pip 20 for example.

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
