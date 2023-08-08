.DEFAULT_GOAL := help
.PHONY: help

app_compose_file := ./containers/app/docker-compose.yml
app_compose_env := ./.env
local_airflow_compose_file := containers/airflow-local/docker-compose.airflow-local.yml
local_airflow_compose_env_file := containers/airflow-local/.airflow-local.env
mkdocs_compose_file := containers/mkdocs/docker-compose.mkdocs.yml
mkdocs_compose_env_file := containers/mkdocs/.mkdocs.env

# taken from https://container-solutions.com/tagging-docker-images-the-right-way/

help: ## Print this help
	@grep -E '^[0-9a-zA-Z_\-\.]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

sh: ## run a shell in the container
	@docker compose run --rm -it --entrypoint sh app

build.app: ## build image using docker build
	@COMPOSE_FILE=$(app_compose_file) docker compose build app --progress=plain

build.app_dev: ## build image for development using docker build
	@COMPOSE_FILE=$(app_compose_file) docker compose build app-dev --progress=plain

# ---------------------------------------------------------------------------- #
#                                 dbt commands                                 #
# ---------------------------------------------------------------------------- #

dbt.seed.dev: ## run dbt seed in dev environment
	@docker compose -f $(app_compose_file) run --rm dbt seed --target dev


# ---------------------------------------------------------------------------- #
#                                mkdocs commands                               #
# ---------------------------------------------------------------------------- #

mkdocs.requirements.txt: ## update requirements.txt file from pyproject.toml
	@poetry export -f requirements.txt --only mkdocs --without-hashes > poetry-mkdocs-requirements.txt

mkdocs.serve: ## serve the mkdocs documentation
	@docker compose -f $(mkdocs_compose_file) --env-file $(mkdocs_compose_env_file) up

mkdocs.build-image: ## build the mkdocs image
	@docker compose -f $(mkdocs_compose_file) --env-file $(mkdocs_compose_env_file) build mkdocs

mkdocs.push-image: ## push the mkdocs image with tag: latest
	@docker compose -f $(mkdocs_compose_file) --env-file $(mkdocs_compose_env_file) push mkdocs

mkdocs.build-docs: ## build the mkdocs documentation
	@docker compose -f $(mkdocs_compose_file) --env-file $(mkdocs_compose_env_file) run --rm mkdocs build

mkdocs.logs: ## show the logs of the mkdocs container
	@docker compose -f $(mkdocs_compose_file) --env-file $(mkdocs_compose_env_file) logs -ft mkdocs

# ---------------------------------------------------------------------------- #
#                               dbt-docs commands                              #
# ---------------------------------------------------------------------------- #

dbt_docs.serve: ## serve the dbt-docs documentation
	@docker compose -f $(app_compose_file) --env-file $(app_compose_env_file) up dbt-docs

dbt_docs.build-image: ## build the dbt-docs image
	@docker compose -f $(app_compose_file) --env-file $(app_compose_env_file) build dbt-docs

dbt_docs.push-image: ## push the dbt-docs image with tag: latest
	@docker compose -f $(app_compose_file) --env-file $(app_compose_env_file) push dbt-docs

dbt_docs.build-docs: ## build the dbt-docs documentation
	@docker compose -f $(app_compose_file) --env-file $(app_compose_env_file) run --rm dbt-docs build

dbt_docs.logs: ## show the logs of the dbt-docs container
	@docker compose -f $(app_compose_file) --env-file $(app_compose_env_file) logs -ft dbt-docs
