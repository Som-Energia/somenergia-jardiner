{{ config(error_if = '>1000') }}

with valors as (
	select True as rebut_from_dset, signal_uuid
	from {{ ref('raw_dset_responses__api_response') }}
	where ts = (select max(ts) from {{ ref('raw_dset_responses__api_response') }})
)
select
	signals.plant,
	signals.signal,
	signals.signal_uuid,
	signals.device,
	signals.device_type,
	signals.device_uuid,
	coalesce(rebut_from_dset, False) as rebut_from_dset
from {{ ref('raw_gestio_actius__signal_denormalized') }} as signals
left join valors on signals.signal_uuid = valors.signal_uuid
where rebut_from_dset is null
order by plant