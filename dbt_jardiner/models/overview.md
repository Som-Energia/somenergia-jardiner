{% docs __dbt_jardiner__ %}

# dbt_jardiner

## Style

### `schema.yaml`

Each `schema.yaml` is split at directory level into `sources` and `models` sections. Their naming convention is `_<dirname>__models.yaml` and `_<dirname>__sources.yaml` respectively.

### Models
Naming convention is `<level>_<source>_<dim/fact concept>_[<device>]__<context>.sql`

Where
- `level` is one of:
  - `raw`, is a raw table
  - `int`, an intermediate table
  - `dm`, is a data mart

- `source` is the data origin, which typically matches the directory name and the `<source>.yaml`

- `dim/fact concept` the concept or abstraction this table contains, is it energy? locations?
Which dimension/fact does it represent if we thought of it in a star schema?

- `context` is any additional context that helps to identify the table, such as the device type,
the aggregation level or the purpose of the model (e.g. superset, dashboard, etc). It is optional and it is separated by `__`
from the rest of the name.

for example, `dm_dset_energy_inverter__agg_monthly_for_om` is a _data mart_ table, with data from the _dset_ source,
with _energy_ data, from _inverter_ devices, aggregated _monthly_, for _operational management_ purposes.


{% enddocs %}