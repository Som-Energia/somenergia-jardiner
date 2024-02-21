# Contributing to this project

This project is a data pipeline that takes data from the Som Energia plants and processes it to be used in the BI tools. This documentation serves as an onboarding guide for new developers and as a reference for the current ones.

## Using `make`

Check the `Makefile` for the available commands. You can use `make` to run the tests, serve the documentation, and more. Use `make help` to see the available commands.

## Project versioning (experimental)

Since jardiner is not a library but rather a complex system, we version the project using the `git` tags. We use the (`calendar versioning`)[https://calver.org/] to tag the releases. We also use the `CHANGELOG.md` to keep track of the changes along with `git-changelog` to generate the changelog.

Git changelog is a tool that generates a changelog from git tags and the commit messages. We _try_ to follow the [Basic convention](https://pawamoy.github.io/git-changelog/usage/#basic-convention) format.

A way to tag a release is to use the following commands:

```bash
$ git tag $(date +'%Y.%m.%d') -m "$(date +'%Y.%m.%d')"
$ make changelog > CHANGELOG.md
```

## Install dependencies

We use `poetry` to manage the dependencies. You can install it via pipx or the official installer. Check the poetry documentation for more.

In short,

- `poetry add <package>` to add package
- `poetry install` to install `poetry.lock` packages
- `poetry show --tree` will show the dependencies tree.
- Additionally `deptry .` will analyze the project and find inconsistencies between project and dependencies.

### Known issues

If you get wheel errors on manylinux2014, update your `pip` to solve it. `poetry` doesn't fetch wheels from manylinux2014. `orjson` will cause this issue with pip 20 for example.

## Testing

Run `pytest` on the root directory. Also, you can test the data models with `dbt test --target pre --target-dir dbt_jardiner`

## Run

`typer` will tell you what arguments you need to run the notify_alarms script. You will have to provide a dbapi string or the placeholders `prod` or `pre` which will read `.env.prod` and `.env.pre` respectivelly

```bash
python ./jardiner/notify_alarms --help
```

## Deploy

We deploy using local gitlab runners as part of the CI/CD pipeline. Check the `.gitlab-ci.yml` file for more information.

This project features many docker images hosted in our private registry at <https://harbor.somenergia.coop>. Check the `docker-compose.yml` files for more information.

## Update requirements

We use poetry to maintain the requirements, but we can update the requirements like so:

```bash
poetry export --without=dev --without-hashes --format=requirements.txt > requirements.txt
```

## Update documentation

We use mkdocs to serve extra documentation and ADRs (Architecture Decision Records). You can serve the documentation with the following command

```bash
make mkdocs.serve
```
