# New merge request for airflow related changes

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

## airflow checklist

- [ ] This MR includes changes to the DAGs in the project
- [ ] All DAGs in this MR have a valid collection of tags
- [ ] All DAGS in this MR contain a value for `__doc___`, passed to the `doc_md` parameter of the `DAG` constructor
- [ ] There is maximum one DAG per file

## Security checklist

- [ ] I have verified that this MR does not introduce sensible data in the repository

## Deployment checklist

- [ ] I have verified that this MR does not introduce changes to the deployment process

<!-- If this MR introduces changes to the deployment process, please describe them here. -->
<!-- ### deployment changes -->

/assign me