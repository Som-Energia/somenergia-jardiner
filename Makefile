.DEFAULT_GOAL			:= help
.PHONY: help

main_compose_file		:= docker-compose.main.yml
mkdocs_compose_file		:= docker-compose.mkdocs.yml

# ---------------------------------------------------------------------------- #

help: ## Print this help
	@grep -E '^[0-9a-zA-Z_\-\.]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

sh: ## run a shell in the container
	@docker compose run --rm -it --entrypoint sh main

main.build: ## build docker image
	@docker compose -f $(main_compose_file)  build main --progress=plain

main.push: ## push docker image to registry
	@docker compose -f $(main_compose_file)  push main

main_dev.build: ## build docker image for development
	@docker compose -f $(main_compose_file)  build dev --progress=plain

main_dev.up: ## start container from dev image
	@docker compose -f $(main_compose_file)  up -d dev


# ---------------------------------------------------------------------------- #
#                                 dbt commands                                 #
# ---------------------------------------------------------------------------- #

dbt.seed.dev: ## run dbt seed in dev environment
	@docker compose -f $(main_compose_file) run --rm dbt seed --target dev

# ---------------------------------------------------------------------------- #
#                                mkdocs commands                               #
# ---------------------------------------------------------------------------- #

mkdocs.requirements.txt: ## update requirements.txt file from pyproject.toml
	@poetry export -f requirements.txt --only mkdocs --without-hashes > poetry-mkdocs-requirements.txt
	@echo "poetry-mkdocs-requirements.txt file updated"

mkdocs.serve: ## serve the mkdocs documentation
	@docker compose -f $(mkdocs_compose_file) up

mkdocs.build_image: ## build the mkdocs image
	@docker compose -f $(mkdocs_compose_file) build mkdocs

mkdocs.push_image: ## push the mkdocs image with tag: latest
	@docker compose -f $(mkdocs_compose_file) push mkdocs

mkdocs.build_docs: ## build the mkdocs documentation
	@docker compose -f $(mkdocs_compose_file) run --rm mkdocs build

mkdocs.logs: ## show the logs of the mkdocs container
	@docker compose -f $(mkdocs_compose_file) logs -ft mkdocs

# ---------------------------------------------------------------------------- #
#                               dbt-docs commands                              #
# ---------------------------------------------------------------------------- #

dbt_docs.build:  dbt_deps.build ## alias for dbt-deps.build


dbt_docs.serve: ## serve the dbt documentation from the dbt-docs image
	@docker compose -f $(main_compose_file)  up dbt-docs

dbt_docs.build_docs: ## build the dbt-docs documentation
	@docker compose -f $(main_compose_file)  run --rm dbt-docs build

# ---------------------------------------------------------------------------- #
#                               dbt-deps commands                              #
# ---------------------------------------------------------------------------- #


dbt_deps.build: ## build the dbt-deps image
	@docker compose -f $(main_compose_file)  build dbt-deps --progress plain

dbt_deps.push: ## push the dbt-deps image with tag: latest
	@docker compose -f $(main_compose_file)  push dbt-deps

dbt_deps.logs: ## show the logs of the dbt-deps container
	@docker compose -f $(main_compose_file)  logs -ft dbt-deps

dbt_deps.bash: ## run a bash shell in the dbt-deps container
	@docker compose -f $(main_compose_file)  run --rm -it --entrypoint bash dbt-deps

# ---------------------------------------------------------------------------- #
#                             local commands                                   #
# ---------------------------------------------------------------------------- #

dev.git-changelog.docker: ## generate changelog usind docker image
	@docker compose -f $(main_compose_file)  run --rm -it --entrypoint git-changelog dev
