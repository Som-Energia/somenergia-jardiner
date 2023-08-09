# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!-- insertion marker -->
## Unreleased

<small>[Compare with latest](https://github.com/Som-Energia/somenergia-jardiner/compare/v0.1.1...HEAD)</small>

### Fixed

- fix: docker makefile commands (#10) ([a4bf6b9](https://github.com/Som-Energia/somenergia-jardiner/commit/a4bf6b9fb188332efe114fddf39c0985ba968e1a) by Diego Quintana).

<!-- insertion marker -->
## [v0.1.1](https://github.com/Som-Energia/somenergia-jardiner/releases/tag/v0.1.1) - 2023-08-09

<small>[Compare with v0.1.0](https://github.com/Som-Energia/somenergia-jardiner/compare/v0.1.0...v0.1.1)</small>

### Fixed

- fix: update dbt config with anonymous usage data False (#7) ([e4af873](https://github.com/Som-Energia/somenergia-jardiner/commit/e4af8735539648d15b8a21761a571e90371a557e) by Diego Quintana).
- fix: pin moll at random instead of pointing to traefik (#3) ([d694520](https://github.com/Som-Energia/somenergia-jardiner/commit/d69452021b5fb5d56f8c5345e88e9503c2640e65) by Diego Quintana).

## [v0.1.0](https://github.com/Som-Energia/somenergia-jardiner/releases/tag/v0.1.0) - 2023-07-13

<small>[Compare with first commit](https://github.com/Som-Energia/somenergia-jardiner/compare/6fbcd051937eafabad087bfbbd66587b059e9e49...v0.1.0)</small>

### Added

- add adrs about dades llargues and obt ([00aacf7](https://github.com/Som-Energia/somenergia-jardiner/commit/00aacf7c1db7aff121602d3fc1f6bb9058b0e829) by pol).
- add mkdocs github action ([03b7261](https://github.com/Som-Energia/somenergia-jardiner/commit/03b72614d1cf249bbcf548caffc2d7e1a0e058d1) by pol).
- add legacy view_clean_irradiation for compatibility with some redash queries ([1d280e7](https://github.com/Som-Energia/somenergia-jardiner/commit/1d280e7aa603f1c5a6ec9857a803ff84ca01175a) by pol).
- add missing model :sweat: ([67ac680](https://github.com/Som-Energia/somenergia-jardiner/commit/67ac6800d22c77939835213286858a50d9361e99) by pol).
- add view_inverter_metrics_daily which redash still uses ([de04cd4](https://github.com/Som-Energia/somenergia-jardiner/commit/de04cd48020b7a74507be3caa8273dcbdcd4f8c1) by pol).
- add subscriber removal from topic cli ([2012cac](https://github.com/Som-Energia/somenergia-jardiner/commit/2012cac4c1cfe87994c7c14054a2174cd08ce703) by pol).
- add real topics associations PENDING ([35443d8](https://github.com/Som-Energia/somenergia-jardiner/commit/35443d881b6d039d3ac6d808b70e2c7addc43aa0) by Lugadur).
- add topic python interface docs ([7653b05](https://github.com/Som-Energia/somenergia-jardiner/commit/7653b05dab7fc7458b4ebb24511307eaa4e663bc) by Lugadur).
- add csv seed of plant-topic association ([83fb52d](https://github.com/Som-Energia/somenergia-jardiner/commit/83fb52d75f39befc037458b78b49c486317f65a4) by Lugadur).
- add string_id ([113c137](https://github.com/Som-Energia/somenergia-jardiner/commit/113c1372463b19310ea3b4e168fa8ee72ab806ff) by pol).
- add exiom grant post-hook ([8d17050](https://github.com/Som-Energia/somenergia-jardiner/commit/8d17050df9d282fe8d0434cfdd249d42e04efdd7) by pol).
- Adding notifications alarms ([c72e1e7](https://github.com/Som-Energia/somenergia-jardiner/commit/c72e1e7d0ba81a9bf7fb519799c82b45302acc43) by Roger).
- Adding new DAG alert_inverter_zero_power ([b6f28fc](https://github.com/Som-Energia/somenergia-jardiner/commit/b6f28fc00c75164d5fb7d13e1efac2b2d7c37ac2) by Roger).
- add meter reading data ingest lag comment ([a4dd4ab](https://github.com/Som-Energia/somenergia-jardiner/commit/a4dd4ab562602c903fa9b5fbcfce31d08e6bb05c) by pol).
- add variable to pass seed name as command line variable to test alerts ([04bd959](https://github.com/Som-Energia/somenergia-jardiner/commit/04bd959a1af58bcd17457a5360654fceac5b4104) by Lugadur).
- add tmux :hankeye: to .gitignore ([e3da104](https://github.com/Som-Energia/somenergia-jardiner/commit/e3da1048c54164828349b986461166f6cc87db8b) by Roger).
- Adding doc resume of best dbt cmds ([09cecd6](https://github.com/Som-Energia/somenergia-jardiner/commit/09cecd665cb6ab144a50bc0a46602e37443d93f9) by Roger).
- Adding invertergegistry clean at daily level with confidence index ([232a54a](https://github.com/Som-Energia/somenergia-jardiner/commit/232a54ad9740fed917ae756983c1432cc107189c) by Roger).
- Adding inverter tremperature alarm ([7a3bcbc](https://github.com/Som-Energia/somenergia-jardiner/commit/7a3bcbc9bd5c4aa6ea960ae72078eb4309863766) by Roger).
- add ipdb on dev dependencies ([8b37830](https://github.com/Som-Energia/somenergia-jardiner/commit/8b378308f52779175d85e5514ef81a8a4bc18935) by pol).
- add documentation on spine and meter alarm logic ([4f6ef35](https://github.com/Som-Energia/somenergia-jardiner/commit/4f6ef35fd7e743c4c75ea9d564210c2328ce6717) by pol).
- add dbt discussed codei documentation ([62fa9d6](https://github.com/Som-Energia/somenergia-jardiner/commit/62fa9d60c955f702657d21127bef6e1a2390848e) by Roger).
- add adr about batch processing meter alarms ([3c1c8b5](https://github.com/Som-Energia/somenergia-jardiner/commit/3c1c8b51220fc1e711960ed04bbf9c4e7236700b) by pol).
- add env example ([74adfad](https://github.com/Som-Energia/somenergia-jardiner/commit/74adfade1de387f9f8700b67156c663447404915) by pol).
- add documentation and requirements.txt because airflow does not poetry ([944b4a8](https://github.com/Som-Energia/somenergia-jardiner/commit/944b4a831c2ce80e59ffe3c89b7ce3f188198474) by pol).

### Fixed

- fix links ([2b481bf](https://github.com/Som-Energia/somenergia-jardiner/commit/2b481bfde09974a7ace131b2c9229925c1b8ad95) by pol).
- Fix titles and links ([ff4d3d2](https://github.com/Som-Energia/somenergia-jardiner/commit/ff4d3d2f29f175489cd96bc4f995aa1159d6506e) by pol).
- fix mkdocs errors, add plugins ([a8f802e](https://github.com/Som-Energia/somenergia-jardiner/commit/a8f802e1a2fdebab4db676ef8f2961647063b2de) by pol).
- fix concat_bytes for inverter negative values ([ef3afbd](https://github.com/Som-Energia/somenergia-jardiner/commit/ef3afbdacbdf2110a0a4d879408eb11c37185bba) by pol).
- fix concat_bytes macro by complement 2 ([8204b98](https://github.com/Som-Energia/somenergia-jardiner/commit/8204b98d5384f57a50df3e7239e1fdb54af0108a) by pol).
- Fix inconcistencia pipe ++ ([08acd09](https://github.com/Som-Energia/somenergia-jardiner/commit/08acd09e28bfbf9429decef7f17e9f27d107c0f8) by Roger).
- fix a NULL  alert_meter_zero_energy when no reading for more than 30 days ([17656b4](https://github.com/Som-Energia/somenergia-jardiner/commit/17656b42b75b4ec8f88bd07261edbf51ff40b8ea) by Lugadur).
- Fix status tables ([98bb864](https://github.com/Som-Energia/somenergia-jardiner/commit/98bb864ab9823ac767d4a2d90f8947eb62dd0a96) by Roger).
- fix preliminary tests ([7d405d7](https://github.com/Som-Energia/somenergia-jardiner/commit/7d405d798a2ef1f18c6262688ad31ec44dfe31e4) by pol).
- fix orjson broken dependency on pip 20 ([e8297aa](https://github.com/Som-Energia/somenergia-jardiner/commit/e8297aaaccc80c8054bba228263346bfbbf2485f) by pol).
- FIX payload must be a dictionary not array ([eab6c27](https://github.com/Som-Energia/somenergia-jardiner/commit/eab6c27154aac721101012036ea5c557be1496c9) by pol).
- fix spine join ([5aee6ef](https://github.com/Som-Energia/somenergia-jardiner/commit/5aee6efc21d5606188cd1ae926de9b2118427701) by pol).

### Changed

- change to point to dbdades instead of plantmonitor ([cefc611](https://github.com/Som-Energia/somenergia-jardiner/commit/cefc61199bf663f055d5f4b78adee536547cbdd6) by pol).
- change inverter_intensity to stringregistry_multisource ([1e1ce75](https://github.com/Som-Energia/somenergia-jardiner/commit/1e1ce755f7f4190acab81ff1f0d4b0cebae9f9d2) by pol).
- change command to quoted && ([2f10c8c](https://github.com/Som-Energia/somenergia-jardiner/commit/2f10c8cbbed451943052c72cb2ee135fdcd0cc6b) by Lugadur).
- change to update_docker_image, parametrize repo_name ([bc64cb4](https://github.com/Som-Energia/somenergia-jardiner/commit/bc64cb46e51e8aa37ace463d14d1fa4a3d33e0bf) by pol).

### Removed

- remove this branch to the docs build ([6780c54](https://github.com/Som-Energia/somenergia-jardiner/commit/6780c54f63db272541c239f633580a73d58a07f2) by pol).
- Remove timezone(utc,now),make stringregistry_denormalized use all readings instead of just last hour ([4d7395c](https://github.com/Som-Energia/somenergia-jardiner/commit/4d7395c02b2131e452a4d8ed48e497d98bf0810b) by pol).
- remove accented directory ([3866067](https://github.com/Som-Energia/somenergia-jardiner/commit/38660674bbd7498e7306e7497d509d7a4539c21e) by pol).
- remove receiver email from dags python call ([a760161](https://github.com/Som-Energia/somenergia-jardiner/commit/a760161efd64f9fc9418c8e8601f0fb7626d7680) by Lugadur).
- remove all order by time ([869419b](https://github.com/Som-Energia/somenergia-jardiner/commit/869419bb3a9a4c9c8891b0b5869c48f6d17b60f4) by pol).
- remove old comments ([dfa03bd](https://github.com/Som-Energia/somenergia-jardiner/commit/dfa03bdfcc087f01256311916554d216f0e5fcc2) by Lugadur).
- remove timezoned now, lateral on true ([d73886c](https://github.com/Som-Energia/somenergia-jardiner/commit/d73886cdc972247940b9acd64f771f548ae324f7) by pol).

