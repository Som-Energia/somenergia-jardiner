select
    id as string_id,
    name as string_name,
    inverter as inverter_id,
    stringbox_name
from {{ source('plantmonitordb','string') }}