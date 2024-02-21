# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!-- insertion marker -->
## [v2024.02.19](https://gitlab.somenergia.coop/et/somenergia-jardiner/tags/v2024.02.19) - 2024-02-16

<small>[Compare with v0.1.1](https://gitlab.somenergia.coop/et/somenergia-jardiner/compare/v0.1.1...v2024.02.19)</small>

### Added

- add dset postman docs url ([8935dd9](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/8935dd9272fa5493b56dd0c7291c0e289e90ae61) by pol).
- add dupes test on materialized table, dedup on ts,signal_uuid instead of signal_id (et/somenergia-jardiner!69) ([9fb42f6](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/9fb42f69decd0d7e3f5718ed84d4212be851a177) by Pol Monsó Purtí).
- added new plant paramenters source ([2cf86ec](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/2cf86ec9e55f4afd481fcc397d998278fa53fc7a) by Lugadur).
- add dset basics raw + signals receiver check (et/somenergia-jardiner!5) ([608fd7b](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/608fd7be18581010a3feaf6fb8ab9a20e0f8cb4a) by Roger Sanjaume).

### Fixed

- Fix/instant data (et/somenergia-jardiner!106) ([b8a92d5](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/b8a92d569a3511e53716cab3ea23822340ae36f1) by Lucía).
- fix: change daily inverter energy calculation (et/somenergia-jardiner!103) ([c4c7e56](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/c4c7e56f58d2f9843d5712ec5caed32e31590ef1) by Lucía).
- fix: update tests in dbt after refactoring (et/somenergia-jardiner!100) ([3bd01a3](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/3bd01a33d36f32c70fea49fe4b2da8bdb155ccb0) by Diego Quintana).
- fix: use trigger_rule=all_done in edr task ([2cf0dca](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/2cf0dca0565cd2799c76ea047c924aff6395f022) by Diego Quintana).
- fix: rename files to avoid airflow script name collisions ([1dffd92](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/1dffd927cf2050abeffcae11283e33f73f9950d4) by Diego Quintana).
- fix: delete old models, change dag cron (et/somenergia-jardiner!98) ([74c9102](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/74c9102fb2d422b3cb88d0814785f9369ce3ea55) by Pol Monsó Purtí).
- fix: dm_blabla_5m change parent from spined to values_incremental (et/somenergia-jardiner!97) ([d76728e](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/d76728ededc774656a35b7f6499d87e00d950192) by Pol Monsó Purtí).
- fix: Wrong energy units in instant dm (et/somenergia-jardiner!92) ([4223b3b](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/4223b3bd6e679a5e6be3c600cc2f7c0ffec4368d) by Pol Monsó Purtí).
- fix: dset meters energy is wrong (et/somenergia-jardiner!88) ([7b4c90f](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/7b4c90f83b8afc2c5ce6a2bf6d6bf0e3dff7d033) by Pol Monsó Purtí). Related issues/PRs: [#102](https://gitlab.somenergia.coop/et/somenergia-jardiner/issues/102)
- Fix: revert to erp_meters, fix pr_hourly formula (et/somenergia-jardiner!87) ([1fb21ed](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/1fb21edc8a800b9bb27c035c95ec7dd3b875e3b7) by Pol Monsó Purtí).
- fix: change job artifact used in dbt-build in ci (et/somenergia-jardiner!85) ([ba3e932](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/ba3e932b5778b84dfd793217ebb2a391ee54cd35) by Diego Quintana). Related issues/PRs: [#152](https://gitlab.somenergia.coop/et/somenergia-jardiner/issues/152)
- fix: avoid bumps between daily and hourly dags writing to db (et/somenergia-jardiner!83) ([5a28e7e](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/5a28e7efde4d24efa82460ebeff40091ac8250ea) by Diego Quintana).
- fix: inverter monthly agg (et/somenergia-jardiner!60) ([568e806](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/568e80649801ad682bb3521eb9d3b646892c8d79) by Pol Monsó Purtí). Related issues/PRs: [#24](https://gitlab.somenergia.coop/et/somenergia-jardiner/issues/24), [#99](https://gitlab.somenergia.coop/et/somenergia-jardiner/issues/99)
- fix: fail fast on merge request (but not on prod) (et/somenergia-jardiner!67) ([cdb0c71](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/cdb0c71c77e30bbfedf9e1fb12d6410d7acee7fe) by Pol Monsó Purtí).
- fix: on schema change should be sync_all_columns (et/somenergia-jardiner!66) ([af90c1a](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/af90c1ae9c029ac9a94f796eabcbf9defcccbe7e) by Pol Monsó Purtí).
- fix/dades fixes de plantes (et/somenergia-jardiner!63) ([6f42763](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/6f42763ab415fed7bebaea49f162b44c9798b7e4) by Lucía).
- fix: inverter monthly aggregate is wrong (et/somenergia-jardiner!58) ([31d058c](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/31d058c63975262edac786423f249271229c7b93) by Pol Monsó Purtí). * fix: wrong capitalization on model
- fix: add metric to dm_metrics_production_5min (et/somenergia-jardiner!57) ([93df4e3](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/93df4e36a1bc81d78f9e27772aae0882e92c7dd0) by Pol Monsó Purtí). * fix: add metric_name to dm_metrics_production_5min
- fix: we want also signals dset has not mapped and we expect (et/somenergia-jardiner!54) ([aa64f4c](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/aa64f4c2f3dc7ba491d55dc98a2b0c9ee0a8e67a) by Pol Monsó Purtí). * fix: full outer join in latest batch
- fix: spined dset with metadata is way too slow (et/somenergia-jardiner!52) ([bc3f7c3](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/bc3f7c32e336e2c1ab3708e754be1a8d3d4a3c01) by Pol Monsó Purtí).
- fix: make minio wait for nas (contd. et/somenergia-jardiner!46)(et/somenergia-jardiner!49) ([1bdaed9](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/1bdaed9204f139fb44059ced1dc584a4e537f356) by Diego Quintana). * fix: add sleep to minio task to wait for nas
- fix: make minio mirror task wait for nas volume (et/somenergia-jardiner!46) ([f35659b](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/f35659ba8e3e8908707fee7de467ce6e255bb52d) by Diego Quintana).
- fix: update bad references between models (et/somenergia-jardiner!47) ([0afc8dc](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/0afc8dc950a4235345d6c291240fb85ce5cfc1ad) by Diego Quintana).
- fix: make unique source of truth for plant name from table `plant_parameters` (et/somenergia-jardiner!36) ([f7b03cd](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/f7b03cda479ee640b09d9a2ee98be07d864bbc11) by Pol Monsó Purtí).
- fix: make dbt model with dset joined data point to union instead of raw dbt model (et/somenergia-jardiner!34) ([4bd01b5](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/4bd01b5f2a6447ee91f3eb706954b0e36da3f776) by Diego Quintana). * change: make dbt model with dset joined data point to union instead of raw dbt model
- fix: chown artifacts and refactor pages task in gitlab CI (et/somenergia-jardiner!22) ([5eaf7e3](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/5eaf7e3bfa774507f37d1e1ac2a850fc6d746e17) by Diego Quintana). * change: add chown task and refactor pages task
- fix documentation ([37534c2](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/37534c2a664f1d5fc8a9e164a811be00136a60d7) by Lugadur).
- fix omie price from €/kwh to €/MWh ([6821d77](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/6821d777c27a440a115ef8c98a76c68aa485e20e) by Lugadur).
- Fix/dset changes (et/somenergia-jardiner!19) ([78e2907](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/78e2907b046f94c54a4051520169fcf3c7301d13) by Pol Monsó Purtí).
- fix: multiple last ts within a metric of several device (et/somenergia-jardiner!18) ([a432745](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/a432745c3a68c2dba860ed27a7eba44e17819c23) by Lucía).
- Fix MR !16 (et/somenergia-jardiner!17) ([987f2cc](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/987f2cc35346f83cd4f552a79e50eca615073db9) by Lucía).
- fix: limit the length of API signal_uuid to 36 characters ([126e7bd](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/126e7bd1574ef0453c6164855a33405b00c82170) by Lugadur).
- fix: missing f-strings and task id ([0f12e1b](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/0f12e1b41d19cbff1eea8abc8d3272998d78497c) by Diego Quintana).
- fix: temporary revert registry and image for plant_production_datasets_dag.py ([9b1068c](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/9b1068c93f9efb52abde52dc0828e0d60cb9d5a1) by Diego Quintana).
- fix: entrypoint at Dockerfiles breaking jardiner dags (et/somenergia-jardiner!9) ([b716049](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/b716049a079e108222bf4e1f3b978b6646a9d535) by Diego Quintana). * dev: add max_active_runs=1 to jardiner dags
- fix: update .gitlab-ci.yml with non-deprecated envvars ([f5cf286](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/f5cf2869ca86d034b7a9c4ac6166e0424e707aac) by Diego Quintana).
- fix: update .rsyncignore ([3828f7c](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/3828f7caa373e0ddac3a6a7b8e8338739aff7f33) by Diego Quintana).
- fix: add dbt logs to .rsyncignore ([2d45b32](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/2d45b321ce58778d642ccdc2cae982cf03856c03) by Diego Quintana).
- fix: add dbt_packages to .rsyncignore ([14f2505](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/14f25055f830301e61604ba8bce13e5488da8dba) by Diego Quintana).
- fix: update dbt model with better date_trunc usage (et/somenergia-jardiner!1) ([73551e3](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/73551e34865b99ae75108f6bbffeafd27e60a8ab) by Diego Quintana). * fix: update dbt model with better date_trunc usage
- fix: add dbt target to .rsyncignore ([44b3991](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/44b3991ebd797796a44f238cb62929bbcddca095) by Diego Quintana).
- fix: add missing packages.yml to dbt containers (#13) ([0199954](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/01999541bbc1e2f3762887eb7bf6e3560ed1c221) by Diego Quintana). Co-authored-by: Lugadur <lucia.garcia@somenergia.coop>
- fix: docker makefile commands (#10) ([a4bf6b9](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/a4bf6b9fb188332efe114fddf39c0985ba968e1a) by Diego Quintana). * containers: update docker cache at compose

### Documented

- docs: add colors brilli brilli to the dbt lineage graph (et/somenergia-jardiner!48) ([639752c](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/639752c21e15bcf2763f77599aa179b8b78df544) by Pol Monsó Purtí). * docs: add colors to nodes in dbt lineage graph
- docs: add merge requests templates (et/somenergia-jardiner!21) ([ca8b51c](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/ca8b51c06c91ba1760a58d406750e5fa1a41e75f) by Diego Quintana). Co-authored-by: Pol Monsó Purtí <polmonso@users.noreply.github.com>
- docs: update urls of the CHANGELOG to gitlab ([87fe866](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/87fe866ef85a6154158acde4fc58f106ee050b67) by Diego Quintana).
- docs: add CHANGELOG.md and git-changelog dependency (#11) ([b522370](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/b52237031e7124e72dd37ef6cb833e4f8431d41f) by Diego Quintana).

## [v0.1.1](https://gitlab.somenergia.coop/et/somenergia-jardiner/tags/v0.1.1) - 2023-08-09

<small>[Compare with v0.1.0](https://gitlab.somenergia.coop/et/somenergia-jardiner/compare/v0.1.0...v0.1.1)</small>

### Fixed

- fix: update dbt config with anonymous usage data False (#7) ([e4af873](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/e4af8735539648d15b8a21761a571e90371a557e) by Diego Quintana).
- fix: pin moll at random instead of pointing to traefik (#3) ([d694520](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/d69452021b5fb5d56f8c5345e88e9503c2640e65) by Diego Quintana).

## [v0.1.0](https://gitlab.somenergia.coop/et/somenergia-jardiner/tags/v0.1.0) - 2023-07-13

<small>[Compare with first commit](https://gitlab.somenergia.coop/et/somenergia-jardiner/compare/6fbcd051937eafabad087bfbbd66587b059e9e49...v0.1.0)</small>

### Added

- add adrs about dades llargues and obt ([00aacf7](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/00aacf7c1db7aff121602d3fc1f6bb9058b0e829) by pol).
- add mkdocs github action ([03b7261](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/03b72614d1cf249bbcf548caffc2d7e1a0e058d1) by pol).
- add legacy view_clean_irradiation for compatibility with some redash queries ([1d280e7](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/1d280e7aa603f1c5a6ec9857a803ff84ca01175a) by pol).
- add missing model :sweat: ([67ac680](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/67ac6800d22c77939835213286858a50d9361e99) by pol).
- add view_inverter_metrics_daily which redash still uses ([de04cd4](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/de04cd48020b7a74507be3caa8273dcbdcd4f8c1) by pol).
- add subscriber removal from topic cli ([2012cac](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/2012cac4c1cfe87994c7c14054a2174cd08ce703) by pol).
- add real topics associations PENDING ([35443d8](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/35443d881b6d039d3ac6d808b70e2c7addc43aa0) by Lugadur).
- add topic python interface docs ([7653b05](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/7653b05dab7fc7458b4ebb24511307eaa4e663bc) by Lugadur).
- add csv seed of plant-topic association ([83fb52d](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/83fb52d75f39befc037458b78b49c486317f65a4) by Lugadur).
- add string_id ([113c137](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/113c1372463b19310ea3b4e168fa8ee72ab806ff) by pol).
- add exiom grant post-hook ([8d17050](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/8d17050df9d282fe8d0434cfdd249d42e04efdd7) by pol).
- Adding notifications alarms ([c72e1e7](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/c72e1e7d0ba81a9bf7fb519799c82b45302acc43) by Roger).
- Adding new DAG alert_inverter_zero_power ([b6f28fc](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/b6f28fc00c75164d5fb7d13e1efac2b2d7c37ac2) by Roger).
- add meter reading data ingest lag comment ([a4dd4ab](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/a4dd4ab562602c903fa9b5fbcfce31d08e6bb05c) by pol).
- add variable to pass seed name as command line variable to test alerts ([04bd959](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/04bd959a1af58bcd17457a5360654fceac5b4104) by Lugadur).
- add tmux :hankeye: to .gitignore ([e3da104](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/e3da1048c54164828349b986461166f6cc87db8b) by Roger).
- Adding doc resume of best dbt cmds ([09cecd6](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/09cecd665cb6ab144a50bc0a46602e37443d93f9) by Roger).
- Adding invertergegistry clean at daily level with confidence index ([232a54a](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/232a54ad9740fed917ae756983c1432cc107189c) by Roger).
- Adding inverter tremperature alarm ([7a3bcbc](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/7a3bcbc9bd5c4aa6ea960ae72078eb4309863766) by Roger).
- add ipdb on dev dependencies ([8b37830](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/8b378308f52779175d85e5514ef81a8a4bc18935) by pol).
- add documentation on spine and meter alarm logic ([4f6ef35](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/4f6ef35fd7e743c4c75ea9d564210c2328ce6717) by pol).
- add dbt discussed codei documentation ([62fa9d6](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/62fa9d60c955f702657d21127bef6e1a2390848e) by Roger).
- add adr about batch processing meter alarms ([3c1c8b5](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/3c1c8b51220fc1e711960ed04bbf9c4e7236700b) by pol).
- add env example ([74adfad](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/74adfade1de387f9f8700b67156c663447404915) by pol).
- add documentation and requirements.txt because airflow does not poetry ([944b4a8](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/944b4a831c2ce80e59ffe3c89b7ce3f188198474) by pol).

### Removed

- remove this branch to the docs build ([6780c54](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/6780c54f63db272541c239f633580a73d58a07f2) by pol).
- Remove timezone(utc,now),make stringregistry_denormalized use all readings instead of just last hour ([4d7395c](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/4d7395c02b2131e452a4d8ed48e497d98bf0810b) by pol).
- remove accented directory ([3866067](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/38660674bbd7498e7306e7497d509d7a4539c21e) by pol).
- remove receiver email from dags python call ([a760161](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/a760161efd64f9fc9418c8e8601f0fb7626d7680) by Lugadur).
- remove all order by time ([869419b](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/869419bb3a9a4c9c8891b0b5869c48f6d17b60f4) by pol).
- remove old comments ([dfa03bd](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/dfa03bdfcc087f01256311916554d216f0e5fcc2) by Lugadur).
- remove timezoned now, lateral on true ([d73886c](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/d73886cdc972247940b9acd64f771f548ae324f7) by pol).

### Fixed

- fix links ([2b481bf](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/2b481bfde09974a7ace131b2c9229925c1b8ad95) by pol).
- Fix titles and links ([ff4d3d2](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/ff4d3d2f29f175489cd96bc4f995aa1159d6506e) by pol).
- fix mkdocs errors, add plugins ([a8f802e](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/a8f802e1a2fdebab4db676ef8f2961647063b2de) by pol).
- fix concat_bytes for inverter negative values ([ef3afbd](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/ef3afbdacbdf2110a0a4d879408eb11c37185bba) by pol).
- fix concat_bytes macro by complement 2 ([8204b98](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/8204b98d5384f57a50df3e7239e1fdb54af0108a) by pol).
- Fix inconcistencia pipe ++ ([08acd09](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/08acd09e28bfbf9429decef7f17e9f27d107c0f8) by Roger).
- fix a NULL  alert_meter_zero_energy when no reading for more than 30 days ([17656b4](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/17656b42b75b4ec8f88bd07261edbf51ff40b8ea) by Lugadur).
- Fix status tables ([98bb864](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/98bb864ab9823ac767d4a2d90f8947eb62dd0a96) by Roger).
- fix preliminary tests ([7d405d7](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/7d405d798a2ef1f18c6262688ad31ec44dfe31e4) by pol).
- fix orjson broken dependency on pip 20 ([e8297aa](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/e8297aaaccc80c8054bba228263346bfbbf2485f) by pol).
- FIX payload must be a dictionary not array ([eab6c27](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/eab6c27154aac721101012036ea5c557be1496c9) by pol).
- fix spine join ([5aee6ef](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/5aee6efc21d5606188cd1ae926de9b2118427701) by pol).

### Documented

- docs: small fixes on graph, better roadmap ([e11fa2a](https://gitlab.somenergia.coop/et/somenergia-jardiner/commit/e11fa2a09fa76ea27f71a9a1880583f239190e06) by pol).

