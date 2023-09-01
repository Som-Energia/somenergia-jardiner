{{ config(error_if = '>1000') }}

with valors as (
	select True as rebut_from_dset, signal_uuid
	from {{ ref('dset_responses_raw') }}
	where ts = (select max(ts) from {{ ref('dset_responses_raw') }})
)
select
	signals.plant,
	signals.signal,
	signals.signal_uuid,
	signals.device,
	signals.device_type,
	signals.device_uuid,
	coalesce(rebut_from_dset, False) as rebut_from_dset
from {{ref('signal_device_relation_raw')}} as signals
left join valors on signals.signal_uuid = valors.signal_uuid
where rebut_from_dset is null
order by plant