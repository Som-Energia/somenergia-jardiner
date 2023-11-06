# New merge request for dbt related changes

## Co-authored by

%{co_authored_by}

## Description

%{first_multiline_commit}

## Commit list

%{all_commits}

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

## Security checklist

- [ ] I have verified that this MR does not introduce sensible data in the repository

## Deployment checklist

- [ ] I have verified that this MR does not introduce changes to the deployment process

<!-- If this MR introduces changes to the deployment process, please describe them here. -->
<!-- ### deployment changes -->

/assign me