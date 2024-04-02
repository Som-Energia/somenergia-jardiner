{{ config(materialized='view') }}

select
  sir.plant,
  sir.global_tilted_irradiation_wh_m2 as irradiation_wh_m2,
  time_bucket('1 hour', sir."time") as time --noqa: RF04
from {{ source('plantmonitor_legacy', 'satellite_readings') }} as sir


-- https://solargis.atlassian.net/wiki/spaces/public/pages/7602367/Solargis+API+User+Guide#SolargisAPIUserGuide-XMLresponse
-- #GTI - Global tilted irradiance [W/m2] (fixed inclination: 25 deg. azimuth: 180 deg.), no data value -9
