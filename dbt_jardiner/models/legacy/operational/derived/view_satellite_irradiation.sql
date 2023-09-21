{{config(materialized='view')}}

SELECT sir.plant,
    time_bucket('1 hour', sir."time") as time,
    sir.global_tilted_irradiation_wh_m2 AS irradiation_wh_m2
FROM {{source('plantmonitor_legacy', 'satellite_readings')}} as sir


-- https://solargis.atlassian.net/wiki/spaces/public/pages/7602367/Solargis+API+User+Guide#SolargisAPIUserGuide-XMLresponse
-- #GTI - Global tilted irradiance [W/m2] (fixed inclination: 25 deg. azimuth: 180 deg.), no data value -9