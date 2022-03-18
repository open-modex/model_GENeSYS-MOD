* ############ genesysmod_timeseries_reduction.gms #############
*
* GENeSYS-MOD v2.3 [Global Energy System Model]  ~ June 2019
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* Updated to newest OSeMOSYS-Version (2016.08) and further improved with additional equations 2016 - 2019
* by Konstantin Löffler, Thorsten Burandt, Karlo Hainsch
*
* #############################################################
*
* Copyright 2019 Technische Universität Berlin and DIW Berlin
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* #############################################################

$offorder

Scalar switch_dunkelflaute /%elmod_dunkelflaute%/;

set OLD_TIMESLICE /Q1M,Q1P,Q1A,Q1N,Q2M,Q2P,Q2A,Q2N,Q3M,Q3P,Q3A,Q3N,Q4M,Q4P,Q4A,Q4N/;
alias (ol,OLD_TIMESLICE);

set COUNTRY_DATA_ENTRIES
/load2016,
load2030,
load2050,
import2016,
import2030,
import2050,
pv_opt,
wind_onshore_opt,
wind_offshore,
hydro_ror/;
alias (cde,COUNTRY_DATA_ENTRIES);

parameter CountryData(REGION_FULL,TIMESLICE_FULL,COUNTRY_DATA_ENTRIES);

parameter CountryData_Load(TIMESLICE_FULL,YEAR_FULL,REGION_FULL);
*parameter CountryData_PV_avg(TIMESLICE_FULL,REGION_FULL);
*parameter CountryData_PV_inf(TIMESLICE_FULL,REGION_FULL);
parameter CountryData_PV_opt(TIMESLICE_FULL,REGION_FULL);
*parameter CountryData_Wind_Onshore_avg(TIMESLICE_FULL,REGION_FULL);
*parameter CountryData_Wind_Onshore_inf(TIMESLICE_FULL,REGION_FULL);
parameter CountryData_Wind_Onshore_opt(TIMESLICE_FULL,REGION_FULL);
parameter CountryData_Wind_Offshore(TIMESLICE_FULL,REGION_FULL);
*parameter CountryData_Mobility_Psng(TIMESLICE_FULL,REGION_FULL);
*parameter CountryData_Heat_Low(TIMESLICE_FULL,REGION_FULL);
*parameter CountryData_Heat_High(TIMESLICE_FULL,REGION_FULL);
*parameter CountryData_HeatPump_AirSource(TIMESLICE_FULL,REGION_FULL);
*parameter CountryData_HeatPump_GroundSource(TIMESLICE_FULL,REGION_FULL);
parameter CountryData_Hydro_ror(TIMESLICE_FULL,REGION_FULL);
parameter CountryData_Import(TIMESLICE_FULL,YEAR_FULL,REGION_FULL);

parameter Dunkelflaute(REGION_FULL,TIMESLICE_FULL,COUNTRY_DATA_ENTRIES);

parameter SmoothedCountryData(REGION_FULL,TIMESLICE_FULL,COUNTRY_DATA_ENTRIES);
parameter ScaledCountryData(REGION_FULL,TIMESLICE_FULL,COUNTRY_DATA_ENTRIES);
parameter AverageCapacityFactor(REGION_FULL,COUNTRY_DATA_ENTRIES);


$onecho >%tempdir%temp_%hourly_data_file%_elmod.tmp
se=0
*         par=CountryData_PV_inf            Rng=PV_INF!A1              rdim=1    cdim=1
*         par=CountryData_PV_avg            Rng=PV_AVG!A1              rdim=1    cdim=1
         par=CountryData_PV_opt            Rng=PV_OPT_U!A1              rdim=1    cdim=1
*         par=CountryData_Wind_Onshore_inf  Rng=WIND_ONSHORE_INF!A1    rdim=1    cdim=1
*         par=CountryData_Wind_Onshore_avg  Rng=WIND_ONSHORE_AVG!A1    rdim=1    cdim=1
         par=CountryData_Wind_Onshore_opt  Rng=WIND_ONSHORE_OPT!A1    rdim=1    cdim=1
         par=CountryData_Wind_Offshore Rng=WIND_OFFSHORE!A1   rdim=1    cdim=1
*         par=CountryData_Heat_High     Rng=HEAT_HIGH!A1       rdim=1    cdim=1
*         par=CountryData_Heat_Low      Rng=HEAT_LOW!A1        rdim=1    cdim=1
*         par=CountryData_Mobility_Psng Rng=MOBILITY_PSNG!A1   rdim=1    cdim=1
         par=CountryData_Load          Rng=demand_profile!A1            rdim=2    cdim=1
*         par=CountryData_HeatPump_GroundSource Rng=HP_AIRSOURCE!A1      rdim=1    cdim=1
*         par=CountryData_HeatPump_AirSource    Rng=HP_GROUNDSOURCE!A1   rdim=1    cdim=1
         par=CountryData_Hydro_ror  Rng=HYDRO_ROR!A1    rdim=1    cdim=1
         par=CountryData_Import  Rng=IMPORT!A1   rdim=2  cdim=1

$offecho
$ifi %switch_only_load_gdx%==0 $call "gdxxrw %inputdir%%hourly_data_file%.xlsx @%tempdir%temp_%hourly_data_file%_elmod.tmp o=%gdxdir%%hourly_data_file%_elmod.gdx MaxDupeErrors=99 CheckDate";
$GDXin %gdxdir%%hourly_data_file%_elmod.gdx
$onUNDF
$load CountryData_PV_opt, CountryData_Wind_Onshore_opt, CountryData_Load, CountryData_Wind_Offshore, CountryData_Hydro_ror, CountryData_Import
$offUNDF

CountryData(r_full, l_full, 'load2016') = CountryData_Load(l_full, '2016', r_full);
CountryData(r_full, l_full, 'load2030') = CountryData_Load(l_full, '2030', r_full);
CountryData(r_full, l_full, 'load2050') = CountryData_Load(l_full, '2050', r_full);
CountryData(r_full, l_full, 'import2016') = CountryData_Import(l_full, '2016', r_full);
CountryData(r_full, l_full, 'import2030') = CountryData_Import(l_full, '2030', r_full);
CountryData(r_full, l_full, 'import2050') = CountryData_Import(l_full, '2050', r_full);
CountryData(r_full, l_full, 'pv_opt') = CountryData_PV_opt(l_full,  r_full);
CountryData(r_full, l_full, 'wind_onshore_opt') = CountryData_Wind_Onshore_opt(l_full, r_full);
CountryData(r_full, l_full, 'wind_offshore') = CountryData_Wind_Offshore(l_full, r_full);
CountryData(r_full, l_full, 'hydro_ror') = CountryData_Hydro_ror(l_full, r_full);

$ontext
*CountryData(r_full, l_full, 'pv_inf') = CountryData_PV_inf(l_full,  r_full);
CountryData(r_full, l_full, 'pv_avg') = CountryData_PV_avg(l_full,  r_full);
CountryData(r_full, l_full, 'wind_onshore_avg') = CountryData_Wind_Onshore_avg(l_full, r_full);
CountryData(r_full, l_full, 'wind_onshore_inf') = CountryData_Wind_Onshore_inf(l_full, r_full);
CountryData(r_full, l_full, 'heat_low') = CountryData_Heat_Low(l_full, r_full);
CountryData(r_full, l_full, 'heat_high') = CountryData_Heat_High(l_full, r_full);
CountryData(r_full, l_full, 'heat_pump_air') = CountryData_HeatPump_AirSource(l_full, r_full);
CountryData(r_full, l_full, 'heat_pump_ground') = CountryData_HeatPump_GroundSource(l_full, r_full);
CountryData(r_full, l_full, 'mobility_psng') = CountryData_Mobility_Psng(l_full, r_full);
$offtext

* choose every %elmod_nthhour% hour starting with the %elmod_starthour%
l(l_full) = no;
l(l_full)$(mod((ord(l_full) - %elmod_starthour%), %elmod_nthhour%) = 0) = yes;

set LAST_TIMESLICE(l_full);
set FIRST_TIMESLICE(l_full);

LAST_TIMESLICE(l_full) = NO;
FIRST_TIMESLICE(l_full) = NO;
LAST_TIMESLICE(l)$(ord(l) = card(l)) = YES;
FIRST_TIMESLICE(l)$(ord(l) = 1) = YES;

scalar
iterator /1/
;

$ifthen %elmod_nthhour% == 1

YearSplit(l,y) = 1/card(l);
CapacityFactor(r,t,l,y) = 1;
CapacityFactor(r,'photovoltaics_utility_solar radiation',l,y) = CountryData(r,l,'pv_opt');
CapacityFactor(r,'photovoltaics_rooftop_solar radiation',l,y) = CountryData(r,l,'pv_opt');
CapacityFactor(r,'photovoltaics_unknown_solar radiation',l,y) = CountryData(r,l,'pv_opt');
CapacityFactor(r,'wind turbine_offshore_air',l,y) = CountryData(r,l,'wind_offshore');
CapacityFactor(r,'wind turbine_onshore_air',l,y) = CountryData(r,l,'wind_onshore_opt');
CapacityFactor(r,'hydro turbine_run-of-river_water',l,y) = CountryData(r,l,'hydro_ror');
CapacityFactor(r,'import_dummy',l,'2016') = CountryData(r,l,'import2016');
CapacityFactor(r,'import_dummy',l,'2030') = CountryData(r,l,'import2030');
CapacityFactor(r,'import_dummy',l,'2050') = CountryData(r,l,'import2050');
SpecifiedDemandProfile(r,'electricity',l,'2016') = CountryData(r, l, 'load2016')*YearSplit(l,'2016');
SpecifiedDemandProfile(r,'electricity',l,'2030') = CountryData(r, l, 'load2030')*YearSplit(l,'2030');
SpecifiedDemandProfile(r,'electricity',l,'2050') = CountryData(r, l, 'load2050')*YearSplit(l,'2050');



$else

*insert the Dunkelflaute
while(iterator lt 24 and card(l_full) lt 500,
l(l_full)$(ord(l_full) = (((24 - %elmod_starthour%) * %elmod_nthhour% + %elmod_starthour%) + iterator)) = yes;

*Dunkelflaute(r_full,l_full,'pv_inf')$(ord(l_full) = (((24 - %elmod_starthour%) * %elmod_nthhour% + %elmod_starthour%) + iterator)) = 0.5;
*Dunkelflaute(r_full,l_full,'wind_onshore_inf')$(ord(l_full) = (((24 - %elmod_starthour%) * %elmod_nthhour% + %elmod_starthour%) + iterator)) = 0.1;
*Dunkelflaute(r_full,l_full,'wind_offshore')$(ord(l_full) = (((24 - %elmod_starthour%) * %elmod_nthhour% + %elmod_starthour%) + iterator)) = 0.1;

*Dunkelflaute(r_full,l_full,'pv_avg')$(ord(l_full) = (((24 - %elmod_starthour%) * %elmod_nthhour% + %elmod_starthour%) + iterator)) = 0.5;
*Dunkelflaute(r_full,l_full,'wind_onshore_avg')$(ord(l_full) = (((24 - %elmod_starthour%) * %elmod_nthhour% + %elmod_starthour%) + iterator)) = 0.1;

Dunkelflaute(r_full,l_full,'pv_opt')$(ord(l_full) = (((24 - %elmod_starthour%) * %elmod_nthhour% + %elmod_starthour%) + iterator)) = 0.5;
Dunkelflaute(r_full,l_full,'wind_onshore_opt')$(ord(l_full) = (((24 - %elmod_starthour%) * %elmod_nthhour% + %elmod_starthour%) + iterator)) = 0.1;

*Depending on the length of the total time set the length of the dunkelflaute are included
iterator${%elmod_nthhour% gt 97 } = iterator + 8 ;
iterator${%elmod_nthhour% gt 49 and %elmod_nthhour% le 97} = iterator + 4 ;
iterator${%elmod_nthhour% gt 25 and %elmod_nthhour% le 49} = iterator + 2 ;
iterator${%elmod_nthhour% le 25 } = iterator +1 ;
);

* SCALING

set       set_SmoothedCountryDataMin(r_full,cde,l_full);
set       set_SmoothedCountryDataMax(r_full,cde,l_full);

parameter CountryDataMin(r_full,cde);
parameter CountryDataMax(r_full,cde);
parameter SmoothedCountryDataMin(r_full,cde);
parameter SmoothedCountryDataMax(r_full,cde);

variables
scaling_objective
scaling_exponent(r_full,cde)
scaling_multiplicator(r_full,cde)
scaling_addition(r_full,cde)
;

equations
def_scaling_objective
def_scaling_dummy
def_scaling_flh(r_full,cde)
def_scaling_min(r_full,cde)
def_scaling_max(r_full,cde)
;

def_scaling_dummy.. scaling_objective =g= 0
;

def_scaling_objective.. scaling_objective =e=
sum((r,cde)${AverageCapacityFactor(r,cde) and (SmoothedCountryDataMax(r,cde) - SmoothedCountryDataMin(r,cde)) NE 0},
    Sqr(
      AverageCapacityFactor(r,cde)*card(l) -
     sum(l,
        max(0,
            (
             (
              (
               (
                (SmoothedCountryData(r,l,cde) - SmoothedCountryDataMin(r,cde)) / (SmoothedCountryDataMax(r,cde) - SmoothedCountryDataMin(r,cde))
               )**scaling_exponent(r,cde)
              ) + CountryDataMin(r,cde)
             ) * scaling_multiplicator(r,cde)
            ) + scaling_addition(r,cde)
           )
         )
     )
   )
;


def_scaling_max(r,cde)${AverageCapacityFactor(r,cde) and (SmoothedCountryDataMax(r,cde)-SmoothedCountryDataMin(r,cde)) NE 0}..
         CountryDataMax(r,cde) =e= sum(l${set_SmoothedCountryDataMax(r,cde,l)}, max(0,(((((SmoothedCountryData(r,l,cde)-SmoothedCountryDataMin(r,cde))/(SmoothedCountryDataMax(r,cde)-SmoothedCountryDataMin(r,cde)))**scaling_exponent(r,cde) )+CountryDataMin(r,cde))*scaling_multiplicator(r,cde))+scaling_addition(r,cde)))
;


def_scaling_min(r,cde)${AverageCapacityFactor(r,cde) and (SmoothedCountryDataMax(r,cde)-SmoothedCountryDataMin(r,cde)) NE 0}..
         CountryDataMin(r,cde) =e= sum(l${set_SmoothedCountryDataMin(r,cde,l)}, max(0,(((((SmoothedCountryData(r,l,cde)-SmoothedCountryDataMin(r,cde))/(SmoothedCountryDataMax(r,cde)-SmoothedCountryDataMin(r,cde)))**scaling_exponent(r,cde) )+CountryDataMin(r,cde))*scaling_multiplicator(r,cde))+scaling_addition(r,cde)))
;




model scaling1 /
def_scaling_dummy
def_scaling_min
def_scaling_max
/
;

model scaling2 /
def_scaling_objective
/
;

scaling1.holdfixed=1;
scaling2.holdfixed=1;

AverageCapacityFactor(r,'load2016')$(sum(l, CountryData(r,l,'load2016'))) = sum(l_full,CountryData(r,l_full,'load2016'))/8760;
CountryData(r,l_full,'load2016')$(AverageCapacityFactor(r,'load2016')) = CountryData(r,l_full,'load2016')/AverageCapacityFactor(r,'load2016');
AverageCapacityFactor(r,'load2016')$(sum(l, CountryData(r,l,'load2016'))) = sum(l_full,CountryData(r,l_full,'load2016'))/8760;

AverageCapacityFactor(r,'load2030')$(sum(l, CountryData(r,l,'load2030'))) = sum(l_full,CountryData(r,l_full,'load2030'))/8760;
CountryData(r,l_full,'load2030')$(AverageCapacityFactor(r,'load2030')) = CountryData(r,l_full,'load2030')/AverageCapacityFactor(r,'load2030');
AverageCapacityFactor(r,'load2030')$(sum(l, CountryData(r,l,'load2030'))) = sum(l_full,CountryData(r,l_full,'load2030'))/8760;

AverageCapacityFactor(r,'load2050')$(sum(l, CountryData(r,l,'load2050'))) = sum(l_full,CountryData(r,l_full,'load2050'))/8760;
CountryData(r,l_full,'load2050')$(AverageCapacityFactor(r,'load2050')) = CountryData(r,l_full,'load2050')/AverageCapacityFactor(r,'load2050');
AverageCapacityFactor(r,'load2050')$(sum(l, CountryData(r,l,'load2050'))) = sum(l_full,CountryData(r,l_full,'load2050'))/8760;


*AverageCapacityFactor(r,'heat_low')${sum(l, CountryData(r,l,'heat_low'))} = sum(l_full,CountryData(r,l_full,'heat_low'))/8760;
*CountryData(r,l_full,'heat_low') = CountryData(r,l_full,'heat_low')/AverageCapacityFactor(r,'heat_low');
*AverageCapacityFactor(r,'heat_low')${sum(l, CountryData(r,l,'heat_low'))} = sum(l_full,CountryData(r,l_full,'heat_low'))/8760;

AverageCapacityFactor(r,cde)${sum(l, CountryData(r,l,cde))} = sum(l_full,CountryData(r,l_full,cde))/8760;

parameter smoothing_range(cde);
smoothing_range('load2016') = 3;
smoothing_range('load2030') = 3;
smoothing_range('load2050') = 3;
*smoothing_range('pv_inf') = 1;
*smoothing_range('wind_onshore_inf') = 2;
*smoothing_range('pv_avg') = 1;
*smoothing_range('wind_onshore_avg') = 2;
smoothing_range('pv_opt') = 1;
smoothing_range('wind_onshore_opt') = 2;
smoothing_range('wind_offshore') = 2;
smoothing_range('hydro_ror') = 2;
smoothing_range('import2016') = 2;
smoothing_range('import2030') = 2;
smoothing_range('import2050') = 2;
*smoothing_range('mobility_psng') = 3;
*smoothing_range('heat_low') = 3;
*smoothing_range('heat_high') = 3;
*smoothing_range('heat_pump_air') = 3;
*smoothing_range('heat_pump_ground') = 3;

$ontext
* Full calculation
if(card(l) = 8760,
smoothing_range('load') = 0;
smoothing_range('pv_inf') = 0;
smoothing_range('wind_onshore_inf') = 0;
smoothing_range('pv_avg') = 0;
smoothing_range('wind_onshore_avg') = 0;
smoothing_range('pv_opt') = 0;
smoothing_range('wind_onshore_opt') = 0;
smoothing_range('wind_offshore') = 0;
smoothing_range('mobility_psng') = 0;
smoothing_range('heat_low') = 0;
smoothing_range('heat_high') = 0;
smoothing_range('heat_pump_air') = 0;
smoothing_range('heat_pump_ground') = 0;
);

* Every 25th hour
if(card(l) = 374,
smoothing_range('load') = 3;
smoothing_range('pv_inf') = 1;
smoothing_range('wind_onshore_inf') = 4;
smoothing_range('pv_avg') = 1;
smoothing_range('wind_onshore_avg') = 4;
smoothing_range('pv_opt') = 1;
smoothing_range('wind_onshore_opt') = 4;
smoothing_range('wind_offshore') = 4;
smoothing_range('mobility_psng') = 3;
smoothing_range('heat_low') = 3;
smoothing_range('heat_high') = 3;
smoothing_range('heat_pump_air') = 3;
smoothing_range('heat_pump_ground') = 3;
);

* Every 49th hour
if(card(l) = 191,
smoothing_range('load') = 3;
smoothing_range('pv_inf') = 1;
smoothing_range('wind_onshore_inf') = 3;
smoothing_range('pv_avg') = 1;
smoothing_range('wind_onshore_avg') = 3;
smoothing_range('pv_opt') = 1;
smoothing_range('wind_onshore_opt') = 3;
smoothing_range('wind_offshore') = 3;
smoothing_range('mobility_psng') = 3;
smoothing_range('heat_low') = 3;
smoothing_range('heat_high') = 3;
smoothing_range('heat_pump_air') = 3;
smoothing_range('heat_pump_ground') = 3;
);
$offtext
* If very short time-spans are used (e.g. for testing) decrease smoothing range
smoothing_range(cde)${smoothing_range(cde)*2+1 gt card(l)} = max(0, round(card(l)/2-2));

loop((r,cde)${SUM[ll,CountryData(r,ll,cde)]},

         SmoothedCountryData(r,l,cde)${smoothing_range(cde) = 0} = CountryData(r,l,cde);

         SmoothedCountryData(r,l,cde)${smoothing_range(cde) ge 0} =
                  sum(ll${ord(ll) ge ord(l) - smoothing_range(cde)
                      and ord(ll) le ord(l) + smoothing_range(cde)}, CountryData(r,ll,cde)*(1 + (-1 + Dunkelflaute(r,ll,cde))$(switch_dunkelflaute = 1 and Dunkelflaute(r,ll,cde) gt 0)))
                  /
                  sum(ll${ord(ll) ge ord(l) - smoothing_range(cde)
                      and ord(ll) le ord(l) + smoothing_range(cde)}, 1)
         ;
);

* Determine minimum and maximum values in timeup and timeup_smoothed
CountryDataMin(r,cde)           = smin(l_full, CountryData(r,l_full,cde));
CountryDataMax(r,cde)           = smax(l_full, CountryData(r,l_full,cde));
SmoothedCountryDataMin(r,cde) = smin(l, SmoothedCountryData(r,l,cde));
SmoothedCountryDataMax(r,cde) = smax(l, SmoothedCountryData(r,l,cde));

*Find the t with the highest /lovest value
set_SmoothedCountryDataMin(r,cde,l) = 0;
set_SmoothedCountryDataMax(r,cde,l) = 0;

loop(l,
set_SmoothedCountryDataMin(r,cde,l)${sum((ll)$set_SmoothedCountryDataMin(r,cde,ll),1) = 0 and SmoothedCountryDataMin(r,cde) = SmoothedCountryData(r,l,cde)} = 1;
set_SmoothedCountryDataMax(r,cde,l)${sum((ll)$set_SmoothedCountryDataMax(r,cde,ll),1) = 0 and SmoothedCountryDataMax(r,cde) = SmoothedCountryData(r,l,cde)} = 1;
);

*$ontext


scaling_exponent.lo(r,cde)${AverageCapacityFactor(r,cde)}      = 0;
scaling_multiplicator.lo(r,cde)${AverageCapacityFactor(r,cde)} = 0;
scaling_addition.lo(r,cde)${AverageCapacityFactor(r,cde)}      = -100;

scaling_exponent.up(r,cde)${AverageCapacityFactor(r,cde)}      = 100;
scaling_multiplicator.up(r,cde)${AverageCapacityFactor(r,cde)} = 100;
scaling_addition.up(r,cde)${AverageCapacityFactor(r,cde)}      = 100;

* Determine Variables
scaling_exponent.l(r,cde)${AverageCapacityFactor(r,cde)}      = 1;
scaling_multiplicator.l(r,cde)${AverageCapacityFactor(r,cde)} = 1;
scaling_addition.l(r,cde)${AverageCapacityFactor(r,cde)}      = 0;

scaling_exponent.fx(r,cde)${AverageCapacityFactor(r,cde)}      = 1;
scaling_multiplicator.l(r,cde)${AverageCapacityFactor(r,cde)} = 1;
scaling_addition.l(r,cde)${AverageCapacityFactor(r,cde)}       = 0;


solve scaling1 min scaling_objective using DNLP;

abort$(scaling1.solvestat <> %solvestat.NormalCompletion%)  'Solvestat is wrong';
abort$(scaling1.modelstat <> 1 and scaling1.modelstat <> 2 and scaling1.modelstat <> 8)  'Modelstat is wrong';

scaling_exponent.lo(r,cde)${AverageCapacityFactor(r,cde)}      = 0;
scaling_exponent.up(r,cde)${AverageCapacityFactor(r,cde)}      = 10;

scaling_multiplicator.fx(r,cde)${AverageCapacityFactor(r,cde)} = scaling_multiplicator.l(r,cde);
scaling_addition.fx(r,cde)${AverageCapacityFactor(r,cde)}      = scaling_addition.l(r,cde);

solve scaling2 min scaling_objective using DNLP;

abort$(scaling2.solvestat <> %solvestat.NormalCompletion%)  'Solvestat is wrong';
abort$(scaling2.modelstat <> 1 and scaling2.modelstat <> 2 and scaling2.modelstat <> 8)  'Modelstat is wrong';

ScaledCountryData(r,l,cde)${ (SmoothedCountryDataMax(r,cde) - SmoothedCountryDataMin(r,cde)) NE 0} =
        max(0,
            (
             (
              (
               (
                (SmoothedCountryData(r,l,cde) - SmoothedCountryDataMin(r,cde)) / (SmoothedCountryDataMax(r,cde) - SmoothedCountryDataMin(r,cde))
               )**scaling_exponent.l(r,cde)
              ) + CountryDataMin(r,cde)
             ) * scaling_multiplicator.l(r,cde)
            ) + scaling_addition.l(r,cde)
           )
;
*$offtext

YearSplit(l,y) = 1/card(l);

DaySplit(y,l) = 1/24/8760;


SpecifiedDemandProfile(r,'electricity',l,'2016') = ScaledCountryData(r, l, 'load2016')/card(l);
SpecifiedDemandProfile(r,'electricity',l,'2030') = ScaledCountryData(r, l, 'load2030')/card(l);
SpecifiedDemandProfile(r,'electricity',l,'2050') = ScaledCountryData(r, l, 'load2050')/card(l);

$ontext
SpecifiedDemandProfile(r,f,l,y)$(SpecifiedAnnualDemand(r,f,y)) = ScaledCountryData(r,l,'load')/card(l);
SpecifiedDemandProfile(r,'Mobility_Passenger',l,y) = ScaledCountryData(r,l,'mobility_psng')/sum(ll,ScaledCountryData(r,ll,'mobility_psng'));
SpecifiedDemandProfile(r,'Mobility_Freight',l,y) = ScaledCountryData(r,l,'mobility_psng')/sum(ll,ScaledCountryData(r,ll,'mobility_psng'));
SpecifiedDemandProfile(r,'Heat_Low_Residential',l,y) = ScaledCountryData(r,l,'heat_low')/sum(ll,ScaledCountryData(r,ll,'heat_low'));
SpecifiedDemandProfile(r,'Heat_Low_Industrial',l,y) = ScaledCountryData(r,l,'heat_high')/sum(ll,ScaledCountryData(r,ll,'heat_high'));
SpecifiedDemandProfile(r,'Heat_Medium_Industrial',l,y) = ScaledCountryData(r,l,'heat_high')/sum(ll,ScaledCountryData(r,ll,'heat_high'));
SpecifiedDemandProfile(r,'Heat_High_Industrial',l,y) = ScaledCountryData(r,l,'heat_high')/sum(ll,ScaledCountryData(r,ll,'heat_high'));
$offtext

CapacityFactor(r,t,l,y) = 1;
*CapacityFactor(r,Solar,l,y) = 0;
*CapacityFactor(r,Wind,l,y) = 0;
$ontext
CapacityFactor(r,'HLR_Heatpump_Aerial',l,y) = ScaledCountryData(r,l,'heat_pump_air');
CapacityFactor(r,'HLR_Heatpump_Ground',l,y) = ScaledCountryData(r,l,'heat_pump_ground');


$offtext
*CapacityFactor(r,'Photovoltaics',l,y) = ScaledCountryData(r,l,'pv_avg');

$ontext
CapacityFactor(r,'Res_Wind_Onshore_avg',l,y) = ScaledCountryData(r,l,'wind_onshore_avg');
CapacityFactor(r,'Res_Wind_Offshore_Shallow',l,y) = ScaledCountryData(r,l,'wind_offshore')*0.75;

CapacityFactor(r,'Res_pv_utility_inf',l,y) = ScaledCountryData(r,l,'pv_inf');
CapacityFactor(r,'Res_Wind_Onshore_inf',l,y) = ScaledCountryData(r,l,'wind_onshore_inf');
CapacityFactor(r,'Res_Wind_Offshore_Deep',l,y) = ScaledCountryData(r,l,'wind_offshore')*1.25;
$offtext
*if(card(l) = 8760,
$ontext
CapacityFactor(r,'HLR_Heatpump_Aerial',l,y) = CountryData(r,l,'heat_pump_air');
CapacityFactor(r,'HLR_Heatpump_Ground',l,y) = CountryData(r,l,'heat_pump_ground');

CapacityFactor(r,'Res_pv_utility_opt',l,y) = CountryData(r,l,'pv_opt');
CapacityFactor(r,'Res_Wind_Onshore_opt',l,y) = CountryData(r,l,'wind_onshore_opt');
CapacityFactor(r,'Res_Wind_Offshore_Transitional',l,y) = CountryData(r,l,'wind_offshore');
CapacityFactor(r,'Res_Wind_Onshore_avg',l,y) = CountryData(r,l,'wind_onshore_avg');
CapacityFactor(r,'Res_Wind_Offshore_Shallow',l,y) = CountryData(r,l,'wind_offshore')*0.75;

CapacityFactor(r,'Res_pv_utility_inf',l,y) = CountryData(r,l,'pv_inf');
CapacityFactor(r,'Res_Wind_Onshore_inf',l,y) = CountryData(r,l,'wind_onshore_inf');
CapacityFactor(r,'Res_Wind_Offshore_Deep',l,y) = CountryData(r,l,'wind_offshore')*1.25;
$offtext

CapacityFactor(r,'photovoltaics_unknown_solar radiation',l,y) = ScaledCountryData(r,l,'pv_opt');
CapacityFactor(r,'photovoltaics_utility_solar radiation',l,y) = ScaledCountryData(r,l,'pv_opt');
CapacityFactor(r,'photovoltaics_rooftop_solar radiation',l,y) = ScaledCountryData(r,l,'pv_opt');
CapacityFactor(r,'wind turbine_offshore_air',l,y) = ScaledCountryData(r,l,'wind_offshore');
CapacityFactor(r,'wind turbine_onshore_air',l,y) = ScaledCountryData(r,l,'wind_onshore_opt');
CapacityFactor(r,'hydro turbine_run-of-river_water',l,y) = ScaledCountryData(r,l,'hydro_ror');
CapacityFactor(r,'import_dummy',l,'2016') = ScaledCountryData(r,l,'import2016');
CapacityFactor(r,'import_dummy',l,'2030') = ScaledCountryData(r,l,'import2030');
CapacityFactor(r,'import_dummy',l,'2050') = ScaledCountryData(r,l,'import2050');
*);

$endif





parameter Conversionls(TIMESLICE_FULL,ls);
parameter Conversionld(TIMESLICE_FULL,ld);
parameter Conversionlh(TIMESLICE_FULL,lh);


*Conversionls(l,'1')$(ord(l) ge 0             and ord(l) le (card(l)/4)) = 1;
*Conversionls(l,'2')$(ord(l) > (card(l)/4)    and ord(l) le (card(l)/4*2)) = 1;
*Conversionls(l,'3')$(ord(l) > (card(l)/4*2)  and ord(l) le (card(l)/4*3)) = 1;
*Conversionls(l,'4')$(ord(l) > (card(l)/4*3)  and ord(l) le  card(l)) = 1;

*Conversionld(l,ld) = 1;

*Conversionlh(l,lh)$(mod(ord(l)+%elmod_starthour%,24) = ord(lh)) = 1;
