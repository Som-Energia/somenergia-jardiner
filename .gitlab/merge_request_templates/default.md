# New merge request

## Description

This merge request addresses, and describe the problem or user story being addressed.

## Related Issues

Provide links to the related issues or feature requests.

## Related links

- Any link to trello, helpscout, etc. That could be useful to understand the context of the MR.

## General checklist

- [ ] I have run pre-commit hooks locally and fixed any issues.
- [ ] I have removed any commented out code.
- [ ] I have removed any TODO comments and added an issue for each one of them.
- [ ] I have added tests to cover the changes.
- [ ] I have added documentation to cover the changes.

## dbt checklist

- [ ] This MR includes changes to the dbt models in the project
- [ ] All models in this MR [follow naming schemes](outline.somenergia.coop)
- [ ] All models in this MR have a valid `_<scope>__models.yml` file
- [ ] All models in this MR have a description and are documented, to some extent, throught the `_<scope>__models.yml` file
- [ ] All models in this MR have valid tags
- [ ] All models in this MR have a valid `_<scope>__sources.yml` file
- [ ] All models are formatted using the [`henriblancke.vscode-dbt-formatter`](https://marketplace.visualstudio.com/items?itemName=henriblancke.vscode-dbt-formatter) VSCode extension

## airflow checklist

- [ ] This MR includes changes to the DAGs in the project
- [ ] All DAGs in this MR have a valid collection of tags
- [ ] All DAGS in this MR contain a value for `__doc___`, passed to the `doc_md` parameter of the `DAG` constructor
- [ ] There is maximum one DAG per file

## security checklist

- [ ] This MR does not introduce sensible data in the repository

## deployment checklist

- [ ] This MR does not introduce changes to the deployment process

<!-- If this MR introduces changes to the deployment process, please describe them here. -->
<!-- ### deployment changes -->

/assign me