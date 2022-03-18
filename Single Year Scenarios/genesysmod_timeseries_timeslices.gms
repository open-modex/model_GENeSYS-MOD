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
*
* ######### Load Hourly Data #############
*

set COUNTRY_DATA_ENTRIES
/load,
pv_avg, pv_inf, pv_opt,
wind_onshore_avg, wind_onshore_inf, wind_onshore_opt,
wind_offshore,
mobility_psng,
heat_low, heat_high,
hp_air, hp_ground/;
alias (cde,COUNTRY_DATA_ENTRIES);

parameter CountryData(REGION_FULL,HOUR,TIMESLICE,COUNTRY_DATA_ENTRIES);
parameter CountryDataPerTimeslice(REGION_FULL,TIMESLICE,COUNTRY_DATA_ENTRIES);
parameter EntriesPerTimeslice(TIMESLICE);

parameter CountryData_Load(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_PV_inf(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_PV_avg(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_PV_opt(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_Wind_Onshore_inf(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_Wind_Onshore_avg(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_Wind_Onshore_opt(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_Wind_Offshore(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_Mobility_Psng(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_Heat_Low(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_Heat_High(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_HeatPump_GroundSource(HOUR,TIMESLICE,REGION_FULL);
parameter CountryData_HeatPump_AirSource(HOUR,TIMESLICE,REGION_FULL);

$onecho >%tempdir%temp_%hourly_data_file%.tmp
se=0
         par=EntriesPerTimeslice       Rng=MAPPING_HELPER!A2  rdim=1    cdim=0
         par=CountryData_PV_inf            Rng=PV_INF!A1              rdim=2    cdim=1
         par=CountryData_Wind_Onshore_inf  Rng=WIND_ONSHORE_INF!A1    rdim=2    cdim=1
         par=CountryData_PV_avg            Rng=PV_AVG!A1              rdim=2    cdim=1
         par=CountryData_Wind_Onshore_avg  Rng=WIND_ONSHORE_AVG!A1    rdim=2    cdim=1
         par=CountryData_PV_opt            Rng=PV_OPT!A1              rdim=2    cdim=1
         par=CountryData_Wind_Onshore_opt  Rng=WIND_ONSHORE_OPT!A1    rdim=2    cdim=1
         par=CountryData_Wind_Offshore Rng=WIND_OFFSHORE!A1   rdim=2    cdim=1
         par=CountryData_Heat_High     Rng=HEAT_HIGH!A1       rdim=2    cdim=1
         par=CountryData_Heat_Low      Rng=HEAT_LOW!A1        rdim=2    cdim=1
         par=CountryData_Mobility_Psng Rng=MOBILITY_PSNG!A1   rdim=2    cdim=1
         par=CountryData_Load          Rng=LOAD!A1            rdim=2    cdim=1
         par=CountryData_HeatPump_GroundSource Rng=HP_AIRSOURCE!A1            rdim=2    cdim=1
         par=CountryData_HeatPump_AirSource    Rng=HP_GROUNDSOURCE!A1            rdim=2    cdim=1
$offecho
$ifi %switch_only_load_gdx%==0 $call "gdxxrw %inputdir%%hourly_data_file%.xlsx @%tempdir%temp_%hourly_data_file%.tmp o=%gdxdir%%hourly_data_file%.gdx MaxDupeErrors=99";
$GDXin %gdxdir%%hourly_data_file%.gdx
$onUNDF
$load CountryData_PV_inf, CountryData_PV_avg, CountryData_PV_opt, CountryData_Wind_Onshore_inf, CountryData_Wind_Onshore_avg, CountryData_Wind_Onshore_opt, CountryData_HeatPump_GroundSource, CountryData_HeatPump_AirSource, CountryData_Load, CountryData_Wind_Offshore, CountryData_Heat_High, CountryData_Heat_Low, CountryData_Mobility_Psng, EntriesPerTimeslice
$offUNDF

CountryData(r, h, l, 'mobility_psng') = CountryData_Mobility_Psng(h, l, r);
CountryData(r, h, l, 'heat_low') = CountryData_Heat_Low(h, l, r);
CountryData(r, h, l, 'heat_high') = CountryData_Heat_High(h, l, r);
CountryData(r, h, l, 'pv_inf') = CountryData_PV_inf(h, l, r);
CountryData(r, h, l, 'wind_onshore_inf') = CountryData_Wind_Onshore_inf(h, l, r);
CountryData(r, h, l, 'pv_avg') = CountryData_PV_avg(h, l, r);
CountryData(r, h, l, 'wind_onshore_avg') = CountryData_Wind_Onshore_avg(h, l, r);
CountryData(r, h, l, 'pv_opt') = CountryData_PV_opt(h, l, r);
CountryData(r, h, l, 'wind_onshore_opt') = CountryData_Wind_Onshore_opt(h, l, r);
CountryData(r, h, l, 'wind_offshore') = CountryData_Wind_Offshore(h, l, r);
CountryData(r, h, l, 'load') = CountryData_Load(h, l, r);
CountryData(r, h, l, 'hp_ground') = CountryData_HeatPump_GroundSource(h, l, r);
CountryData(r, h, l, 'hp_air') = CountryData_HeatPump_AirSource(h, l, r);

CountryDataPerTimeslice(r, l, cde)$(EntriesPerTimeslice(l) > 0) = sum(h,CountryData(r, h, l, cde))/EntriesPerTimeslice(l);

CapacityFactor(r,t,l,y) = 1;
CapacityFactor(r,Solar,l,y) = 0;
CapacityFactor(r,Wind,l,y) = 0;

CapacityFactor(r,'Res_pv_utility_avg',l,y) = CountryDataPerTimeslice(r,l,'pv_avg');
CapacityFactor(r,'Res_Wind_Onshore_avg',l,y) = CountryDataPerTimeslice(r,l,'wind_onshore_avg');
CapacityFactor(r,'Res_Wind_Offshore_Transitional',l,y) = CountryDataPerTimeslice(r,l,'wind_offshore');

CapacityFactor(r,'Res_pv_utility_opt',l,y) = CountryDataPerTimeslice(r,l,'pv_opt');
CapacityFactor(r,'Res_Wind_Onshore_opt',l,y) = CountryDataPerTimeslice(r,l,'wind_onshore_opt');
CapacityFactor(r,'Res_Wind_Offshore_Deep',l,y) = CountryDataPerTimeslice(r,l,'wind_offshore')*1.25;

CapacityFactor(r,'Res_pv_utility_inf',l,y) = CountryDataPerTimeslice(r,l,'pv_inf');
CapacityFactor(r,'Res_Wind_Onshore_inf',l,y) = CountryDataPerTimeslice(r,l,'wind_onshore_inf');
CapacityFactor(r,'Res_Wind_Offshore_Shallow',l,y) = CountryDataPerTimeslice(r,l,'wind_offshore')*0.75;

CapacityFactor(r,'Res_PV_Rooftop_Commercial',l,y) = CountryDataPerTimeslice(r,l,'pv_avg');

CapacityFactor(r,'HLR_Heatpump_Ground',l,y) = CountryDataPerTimeslice(r,l,'hp_ground');
CapacityFactor(r,'HLR_Heatpump_Aerial',l,y) = CountryDataPerTimeslice(r,l,'hp_air');


parameter checkDataMissing(r_full,cde);
checkDataMissing(r,cde)$(sum(ll,CountryDataPerTimeslice(r,ll,cde)) = 0) = 1;

* normalize Demand profile to 1
SpecifiedDemandProfile(r,'Mobility_Passenger',l,y)     = CountryDataPerTimeslice(r,l,'mobility_psng')/sum(ll,CountryDataPerTimeslice(r,ll,'mobility_psng'));
SpecifiedDemandProfile(r,'Mobility_Freight',l,y)     = SpecifiedDemandProfile(r,'Mobility_Passenger',l,y);
SpecifiedDemandProfile(r,'Heat_Low_Residential',l,y)      = CountryDataPerTimeslice(r,l,'heat_low')/sum(ll,CountryDataPerTimeslice(r,ll,'heat_low'));
SpecifiedDemandProfile(r,'Heat_Low_Industrial',l,y)    = CountryDataPerTimeslice(r,l,'heat_high')/sum(ll,CountryDataPerTimeslice(r,ll,'heat_high'));
SpecifiedDemandProfile(r,'Heat_Medium_Industrial',l,y) = CountryDataPerTimeslice(r,l,'heat_high')/sum(ll,CountryDataPerTimeslice(r,ll,'heat_high'));
SpecifiedDemandProfile(r,'Heat_High_Industrial',l,y)   = CountryDataPerTimeslice(r,l,'heat_high')/sum(ll,CountryDataPerTimeslice(r,ll,'heat_high'));
SpecifiedDemandProfile(r,'Power',l,y)                  = CountryDataPerTimeslice(r,l,'load')/sum(ll,CountryDataPerTimeslice(r,ll,'load'));


parameter checkDemandProfile(r_full,f);
checkDemandProfile(r,f)$(sum((l),SpecifiedDemandProfile(r,f,l,'2015')) > 1.0000000000001) = 1;

* setting small values to zero to avoid scaling issues
CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y) < 0.01) = 0;

