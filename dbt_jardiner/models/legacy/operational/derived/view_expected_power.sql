{{ config(materialized='view') }}

select
  reg.time,
  sensor.plant as plant,
  sensor.id as sensor,
  reg.temperature_dc,
  reg.irradiation_w_m2,
  case
    when reg.irradiation_w_m2 <= 0 then 0 else (
      par.n_modules
      * par.max_power_current_ma / 1000.0
      * par.max_power_voltage_mv / 1000.0
      * (
        reg.irradiation_w_m2
        / par.standard_conditions_irradiation_w_m2::float
        + (reg.temperature_dc - par.standard_conditions_temperature_dc)
        / 10.0
        * par.current_temperature_coefficient_mpercent_c
        / 100000.0
      )
      * (
        1
        + (reg.temperature_dc - par.standard_conditions_temperature_dc)
        / 10.0
        * par.voltage_temperature_coefficient_mpercent_c
        / 100000.0
      )
      * par.degradation_cpercent / 10000.0 -- c% -> factor
      -- c% -> factor
      * par.expected_power_correction_factor_cpercent / 10000.0
      / 1000.0   -- W -> kW
    )
  end as expectedpower
from {{ source('plantmonitor_legacy','sensorirradiationregistry') }} as reg
  left join {{ source('plantmonitor_legacy','sensor') }} as sensor
    on reg.sensor = sensor.id
  left join {{ source('plantmonitor_legacy','plantmoduleparameters') }} as par
    on sensor.plant = par.plant
order by reg.time, sensor.plant, sensor.id

{#
Expected Power
Original excel computation

B1=nModules=4878
B16=Vmp=37.5 V
B17=Imp=9.07 A
B18=Voc=46.1 V
B19=Isc=9.5 A
B42=coefTempIsc=0.05 %
B43=coefTempVoc=-0.31 %
irradiationSC=1000 W/m2

C3=Temp ºC
D3=Irradiation W/m2

E3=Isc*D3/irradiationSC
F3=IF(D3=0;0;E3+(coefTempIsc/100*Isc*(C3-25)))
G3=IF(D3=0;0;Voc+(coefTempVoc/100*Voc*(C3-25)))
H3=F3*Imp/Isc
I3=G3*Vmp/Voc
J3=H3*I3
K3=J3*nModules/1000
L3=K3*0,975

We turned the former into:

factorV = 1 + (T(t)-T_{sc}) * C_{coefTempVoc}
factorI = G(t)/G_{SCT} + (T(t)-T_{sc}) * C_{coefTempIsc}
nModules I_{mp} V_ {mp} * factorV * factorI * degradacion/100.0 / 1000.0
#}
