{{ config(enabled=true, severity='warn', warn_if = '>0') }}

select distinct on (plant_name, device_name, signal_uuid)
	*
from {{ ref('obs_dset_responses__with_signal_metadata') }}
where signal_value between 65500 and 65599
order by plant_name asc, device_name asc, signal_uuid asc, ts desc
