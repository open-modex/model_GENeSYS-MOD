* ################### genesysmod_bounds.gms ####################
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



*
* ####### Default Values #############
*

*RETagTechnology(r,RES,y) = 1;
RETagFuel(r,'electricity',y) = 1;
*RETagFuel(r,'Heat_Low_Residential',y) = 1;
*RETagFuel(r,'Heat_Low_Industrial',y) = 1;
*RETagFuel(r,'Heat_Medium_Industrial',y) = 1;
*RETagFuel(r,'Heat_High_Industrial',y) = 1;

TotalAnnualMaxCapacityInvestment(REGION,TECHNOLOGY,y) = 999999;
TotalAnnualMinCapacityInvestment(REGION,TECHNOLOGY,y) = 0 ;
TotalTechnologyModelPeriodActivityUpperLimit(REGION,TECHNOLOGY) = 999999;
TotalTechnologyModelPeriodActivityLowerLimit(REGION,TECHNOLOGY) = 0;
TotalTechnologyAnnualActivityUpperLimit(REGION,TECHNOLOGY,y)$(TotalTechnologyAnnualActivityUpperLimit(REGION,TECHNOLOGY,y) = 0 and not sameas(TECHNOLOGY,'R_Biogas')) = 999999;

*** Important multiplication due to 5-year-steps
EmissionActivityRatio(r,t,e,m,y) =  EmissionActivityRatio(r,t,e,m,y);
VariableCost(r,t,m,y) = VariableCost(r,t,m,y);
FixedCost(r,t,y) = FixedCost(r,t,y);

*** Same thing, only for resource limits
*TotalTechnologyModelPeriodActivityUpperLimit(REGION,FossilFuels)$(not sameas('R_Nuclear',FossilFuels)) = Readin_TotalTechnologyModelPeriodActivityUpperLimit(REGION,FossilFuels)/5;
*TotalTechnologyModelPeriodActivityUpperLimit(REGION,'A_CCS_Capacity') = Readin_TotalTechnologyModelPeriodActivityUpperLimit(REGION,'A_CCS_Capacity')/5;

*** Error handling, in case residual capacity > maximum capacity
TotalAnnualMaxCapacity(r,t,y)$(ResidualCapacity(r,t,y) > TotalAnnualMaxCapacity(r,t,y)) = ResidualCapacity(r,t,y);

*
* ####### Dummy-Technologies [enable for test purposes, if model runs infeasible] #############
*
DummyTechnology('Infeasability_HLI') = yes;
*DummyTechnology('Infeasability_HMI') = yes;
*DummyTechnology('Infeasability_HHI') = yes;
*DummyTechnology('Infeasability_HRI') = yes;
DummyTechnology('Infeasability_Power') = yes;
*DummyTechnology('Infeasability_Mob_pass') = yes;
*DummyTechnology('Infeasability_Mob_freight') = yes;

AvailabilityFactor(r,DummyTechnology,y) = 0;

$ifthen %switch_infeasibility_tech% == 1
OutputActivityRatio(REGION,'Infeasability_HLI','natural gas','1',y) = 1;
*OutputActivityRatio(REGION,'Infeasability_HMI','Heat_Medium_Industrial','1',y) = 1;
*OutputActivityRatio(REGION,'Infeasability_HHI','Heat_High_Industrial','1',y) = 1;
*OutputActivityRatio(REGION,'Infeasability_HRI','Heat_Low_Residential','1',y) = 1;
OutputActivityRatio(REGION,'Infeasability_Power','electricity','1',y) = 1;
*OutputActivityRatio(REGION,'Infeasability_mob_freight','Mobility_Freight','1',y) = 1 ;
*OutputActivityRatio(REGION,'Infeasability_mob_freight','Mobility_Freight','1',y) = 1 ;
RETagTechnology(r_full,'Infeasability_Power',y_full) = 1;
RETagTechnology(r_full,'storage_battery_electricity',y_full) = 1;
RETagTechnology(r_full,'storage_salt cavern_hydrogen',y_full) = 1;
RETagTechnology(r_full,'storage_pumped_electricity',y_full) = 1;
RETagTechnology(r_full,'import_dummy',y_full) = 1;
RETagTechnology(r_full,'generator_steam_waste',y_full) = 1;
RETagTechnology(r_full,'generator_gas_hydrogen',y_full) = 1;

CapacityToActivityUnit(r,DummyTechnology) = 8760;

TotalAnnualMaxCapacity(r,DummyTechnology,y) = 999999;

FixedCost(r,DummyTechnology,y) = 9999;
CapitalCost(r,DummyTechnology,y) = 9999;
VariableCost(r,DummyTechnology,m,y) = 999;
AvailabilityFactor(r,DummyTechnology,y) = 1;
CapacityFactor(r,DummyTechnology,l,y) = 1;
OperationalLife(r,DummyTechnology) = 1;
EmissionActivityRatio(r,DummyTechnology,e,m,y) = 0;
$endif

*
* ####### Bounds for non-supply technologies #############
*
*TotalAnnualMaxCapacity(r,Transformation,y) = 999999;
*TotalAnnualMaxCapacity(r,FossilPower,y) = 999999;
*TotalAnnualMaxCapacity(r,FossilFuels,y) = 999999;
*TotalAnnualMaxCapacity(r,CHPs,y) = 999999;
*TotalAnnualMaxCapacity(r,Transport,y) = 999999;
*TotalAnnualMaxCapacity(r,ImportTechnology,y) = 999999;
*TotalAnnualMaxCapacity(r,'RES_Biomass',y) = 999999;
*TotalAnnualMaxCapacity(r,'P_Biomass',y) = 999999;

*AvailabilityFactor(r,ImportTechnology,y) = 1;
*CapacityFactor(r,ImportTechnology,l,y) = 1 ;
*OperationalLife(r,ImportTechnology) = 1 ;
*Elec(r,ImportTechnology) = 999999;

*
* ####### Bounds for storage technologies #############
*

StorageLevelYearFinish.fx(s,y,r) = 0;
StorageLevelTSStart.fx('S_storage_battery_electricity',y,l,r)$(mod((ord(l)),(24)) = 8) = 0;
*StorageLevelDayTypeFinish.fx('S_Battery_Redox',y,ls,ld,r) = 0;



*
* ####### Capacity factor for heat technologies #############
*
*CapacityFactor(r,Heat,l,y)$(sum(ll,CapacityFactor(r,Heat,ll,y)) = 0) = 1;

*CapacityFactor(r,'HLI_Solar_Thermal',l,y) = CapacityFactor(r,'Res_PV_Rooftop_Commercial',l,y);
*CapacityFactor(r,'HLR_Solar_Thermal',l,y) = CapacityFactor(r,'Res_PV_Rooftop_Commercial',l,y);
*CapacityFactor(r,'Res_PV_Rooftop_Residential',l,y) = CapacityFactor(r,'Res_PV_Rooftop_Commercial',l,y);

*
* ####### No new capacity construction in 2015 #############
*

*### WICHTIG: Wieder einkommentieren, wenn Daten vollständig! ###

*NewCapacity.fx('2015',Transformation,r) = 0;
*NewCapacity.fx('2015',PowerSupply,r) = 0;
*NewCapacity.fx('2015',SectorCoupling,r) = 0;
*NewCapacity.fx('2015',Transformation,r) = 0;
*NewCapacity.fx('2015',StorageDummies,r) = 0;

*NewCapacity.up('2015','RES_Biomass',r) = +INF;

*** ReserveMargin corrections
ReserveMargin(r,y) = 0;


Parameter PhaseOut(YEAR_FULL) this is an upper limit for fossil generation based on the previous year - to remove choose large value
/        2020    2
         2025    2
         2030    2
         2035    2
         2040    2
         2045    2
         2050    2
/
PhaseIn(YEAR_FULL) this is a lower bound for renewable integration based on the previous year - to remove choose 0
/        2020    1
         2025    0.85
         2030    0.85
         2035    0.85
         2040    0.85
         2045    0.85
         2050    0.85
/;


*** Term for error handling
parameter ToSmallResidualCapacity;
ToSmallResidualCapacity(r,t,y)$(ResidualCapacity(r,t,y) > TotalAnnualMaxCapacity(r,t,y)) = ResidualCapacity(r,t,y);
TotalAnnualMaxCapacity(r,t,y)$(ResidualCapacity(r,t,y) > TotalAnnualMaxCapacity(r,t,y)) = ResidualCapacity(r,t,y);

*** Relevant for Europe due to unimplemented data
AdditionalTradeCapacity(y,f,r,rr) = 0;

*** CO2 Storage Potentials cannot be used in one year alone, instead are assumed to distributed evenly across yars
*TotalTechnologyAnnualActivityUpperLimit(r,'A_CCS_Capacity',y) = TotalTechnologyModelPeriodActivityUpperLimit(r,'A_CCS_Capacity')/card(y);

*** Adds (negligible) variable costs to transport technologies, since they only had fuel costs before
*** This is to combat strange "curtailment" effects of some transportation technologies
*VariableCost(r,Transport,m,y) = 0.09;

ModelPeriodExogenousEmission(REGION,EMISSION) = 0;
*REMinProductionTarget(r,f,y) = 0;

*
* ####### Dispatch and Curtailment #############
*
TagDispatchableTechnology(TECHNOLOGY) = 1;
TagDispatchableTechnology('photovoltaics_rooftop_solar radiation') = 0;
TagDispatchableTechnology('photovoltaics_unknown_solar radiation ') = 0;
TagDispatchableTechnology('photovoltaics_utility_solar radiation') = 0;
TagDispatchableTechnology('wind turbine_offshore_air') = 0;
TagDispatchableTechnology('wind turbine_onshore_air') = 0;


*TagDispatchableTechnology(Wind) = 0;
*AvailabilityFactor(REGION,Solar,y) = 1;
*TagDispatchableTechnology(Transport) = 0;
*Curtailment.fx(y,l,TransportFuels,r) = 0;

*
* ####### CCS #############
*

$ifthen %switch_ccs% == 1
AvailabilityFactor(r,CCS,y) = 0;

AvailabilityFactor(r,CCS,y)$(YearVal(y) > 2020) = 0.95;

AvailabilityFactor(r,CCS,y)$(TotalTechnologyAnnualActivityUpperLimit(r,'A_CCS_Capacity',y) = 0) = 0;
TotalAnnualMaxCapacity(r,CCS,y)$(TotalTechnologyAnnualActivityUpperLimit(r,'A_CCS_Capacity',y) = 0) = 0;
TotalAnnualMaxCapacity(r,CCS,y)$(AvailabilityFactor(r,CCS,y) = 0) = 0;

Productionbytechnologyannual.fx(y,CCS,f,r)$(AvailabilityFactor(r,CCS,y) = 0) = 0;

parameter CCSLimit(REGION_FULL);
CCSLimit(r) = TotalTechnologyModelPeriodActivityUpperLimit(r,'A_CCS_Capacity');

TotalTechnologyAnnualActivityUpperLimit(r,'A_CCS_Capacity',y) = 999999;
TotalTechnologyModelPeriodActivityUpperLimit(r,'A_CCS_Capacity') = 999999;

$else

*AvailabilityFactor(r,CCS,y) = 0;
*TotalAnnualMaxCapacity(r,CCS,y) = 0;
*TotalTechnologyAnnualActivityUpperLimit(r,'A_CCS_Capacity',y) = 0;

*Productionbytechnologyannual.fx(y,CCS,f,r) = 0;
$endif


*
* ####### Ramping #############
*

$ifthen %switch_ramping% == 1

RampingUpFactor(r,'RES_Hydro_Large',y) = 0.25;
RampingUpFactor(r,PowerBiomass,y) = 0.04;
RampingUpFactor(r,FossilPower,y) = 0.04;
RampingUpFactor(r,Coal,y) = 0.02;
RampingUpFactor(r,Gas,y) = 0.2;
RampingUpFactor(r,'P_Nuclear',y) = 0.01;
RampingUpFactor(r,HeatSlowRamper,y) = 0.1;
RampingUpFactor(r,HeatQuickRamper,y) = 0;

RampingDownFactor(r,'RES_Hydro_Large',y) = 0.25;
RampingDownFactor(r,PowerBiomass,y) = 0.04;
RampingDownFactor(r,FossilPower,y) = 0.04;
RampingDownFactor(r,Coal,y) = 0.02;
RampingDownFactor(r,Gas,y) = 0.2;
RampingDownFactor(r,'P_Nuclear',y) = 0.01;
RampingDownFactor(r,HeatSlowRamper,y) = 0.1;
RampingDownFactor(r,HeatQuickRamper,y) = 0;

ProductionChangeCost(r,'RES_Hydro_Large',y) = 50/3.6;
ProductionChangeCost(r,PowerBiomass,y) = 100/3.6;
ProductionChangeCost(r,FossilPower,y) = 100/3.6;
ProductionChangeCost(r,Coal,y) = 50/3.6;
ProductionChangeCost(r,Gas,y) = 20/3.6;
ProductionChangeCost(r,'P_Nuclear',y) = 200/3.6;
ProductionChangeCost(r,HeatSlowRamper,y) = 100/3.6;
ProductionChangeCost(r,HeatQuickRamper,y) = 0;

MinActiveProductionPerTimeslice(y,l,'electricity','RES_Hydro_Large',r) = 0.1;
MinActiveProductionPerTimeslice(y,l,'electricity','RES_Hydro_Small',r) = 0.05;

$endif

*marginal costs for better numerical stability
*CapitalCostStorage(r,s,y) = 0.5;
CapitalCost(r,t,y)$(CapitalCost(r,t,y) = 0) = 0.5;

CurtailmentCostFactor(r,f,y) = 0;

TrajectoryLowerLimit('2020') = 0.7;
TrajectoryUpperLimit('2020') = 1.45;

*CapacityFactor(r,'S_GAS',l,y) = 1 ;

TradeCosts(f,r,rr) = 0;
TotalAnnualMinCapacity(r,t,y) = 0;
AnnualExogenousEmission(r,e,y) = 0;
RegionalAnnualEmissionLimit(r,e,y) = 999999;

***MODEX Quick and Dirty Fixes ****

*Total Annual Max Capacity for R-Technologies
TotalAnnualMaxCapacity(r_full,'R_air',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_biogas',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_biomass',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_hard coal',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_heat',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_light oil',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_lignite',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_natural gas',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_solar radiation',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_uranium',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_waste',y) = 999999;
TotalAnnualMaxCapacity(r_full,'R_water',y) = 999999;
OperationalLife(r_full,'R_air')=50;
OperationalLife(r_full,'R_biogas')=50;
OperationalLife(r_full,'R_biomass')=50;
OperationalLife(r_full,'R_hard coal')=50;
OperationalLife(r_full,'R_heat')=50;
OperationalLife(r_full,'R_light oil')=50;
OperationalLife(r_full,'R_lignite')=50;
OperationalLife(r_full,'R_natural gas')=50;
OperationalLife(r_full,'R_solar radiation')=50;
OperationalLife(r_full,'R_uranium')=50;
OperationalLife(r_full,'R_waste')=50;
OperationalLife(r_full,'R_water')=50;
CapacityToActivityUnit(r_full,'R_air')=8760;
CapacityToActivityUnit(r_full,'R_biogas')=8760;
CapacityToActivityUnit(r_full,'R_biomass')=8760;
CapacityToActivityUnit(r_full,'R_hard coal')=8760;
CapacityToActivityUnit(r_full,'R_heat')=8760;
CapacityToActivityUnit(r_full,'R_light oil')=8760;
CapacityToActivityUnit(r_full,'R_lignite')=8760;
CapacityToActivityUnit(r_full,'R_natural gas')=8760;
CapacityToActivityUnit(r_full,'R_solar radiation')=8760;
CapacityToActivityUnit(r_full,'R_uranium')=8760;
CapacityToActivityUnit(r_full,'R_waste')=8760;
CapacityToActivityUnit(r_full,'R_water')=8760;


*OutputActivityRatios for Renewables
OutputActivityRatio(r_full,'hydro turbine_run-of-river_water','electricity','1',y) = 1;
OutputActivityRatio(r_full,'photovoltaics_rooftop_solar radiation','electricity','1',y) = 1;
OutputActivityRatio(r_full,'photovoltaics_unknown_solar radiation','electricity','1',y) = 1;
OutputActivityRatio(r_full,'photovoltaics_utility_solar radiation','electricity','1',y) = 1;
OutputActivityRatio(r_full,'wind turbine_offshore_air','electricity','1',y) = 1;
OutputActivityRatio(r_full,'wind turbine_onshore_air','electricity','1',y) = 1;

TotalCapacityAnnual.up(y_full,t,r_full) = 99999;
