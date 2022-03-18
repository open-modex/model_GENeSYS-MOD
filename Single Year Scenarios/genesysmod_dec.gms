* #################### genesysmod_dec.gms #####################
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



$offOrder

$ifthen %timeseries% == elmod
set TIMESLICE_FULL /0*8759/;
alias (l_full,ll_full,TIMESLICE_FULL);

set DAILYTIMEBRACKET /1*24/;
alias (lh,DAILYTIMEBRACKET,lhlh);

$else
set HOUR /0*8759/
alias (h,hh,HOUR);

set TIMESLICE_FULL /Q1M,Q1P,Q1A,Q1N,Q2M,Q2P,Q2A,Q2N,Q3M,Q3P,Q3A,Q3N,Q4M,Q4P,Q4A,Q4N/;
alias (l_full,ll_full,TIMESLICE_FULL);

set DAILYTIMEBRACKET;
alias (lh,DAILYTIMEBRACKET,lhlh);
$endif

set TIMESLICE(l_full);
alias (l,ll,TIMESLICE);

Set YEAR_FULL /2015*2050/;
alias (y_full, yy_full, YEAR_FULL);

set YEAR(y_full);
alias (y,yy,YEAR);

set REGION_FULL ;
alias (REGION_FULL,r_full,rr_full);

set REGION(REGION_FULL);
alias (REGION,r,rr)

set TECHNOLOGY /Infeasability_Power,
                Infeasability_HLI,
                Infeasability_HMI,
                Infeasability_HHI,
                Infeasability_HRI,
                Infeasability_Mob_pass, Infeasability_Mob_freight /;
alias (t,TECHNOLOGY);

set DummyTechnology(TECHNOLOGY)

set FUEL;
alias (f,FUEL);
set EMISSION;
alias (e,EMISSION);
set MODE_OF_OPERATION ;
alias (m,MODE_OF_OPERATION);
set STORAGE;
alias (s,STORAGE);
set SEASON;
alias (ls,SEASON);
set DAYTYPE;
alias (ld,DAYTYPE);
set DAILYTIMEBRACKET;
alias (lh,DAILYTIMEBRACKET,lhlh);

set MODALTYPE;
alias (mt,MODALTYPE);

*
* ####################
* # Parameters #
* ####################
*
* ####### Global #############
*
parameter StartYear;
parameter YearSplit(TIMESLICE_FULL,y_full);
parameter DiscountRate(REGION_FULL);

*
* ####### Demands #############
*
parameter SpecifiedAnnualDemand(REGION_FULL,FUEL,y_full);
parameter SpecifiedDemandProfile(REGION_FULL,FUEL,TIMESLICE_FULL,y_full);
parameter RateOfDemand(y_full,TIMESLICE_FULL,FUEL,REGION_FULL);
parameter Demand(y_full,TIMESLICE_FULL,FUEL,REGION_FULL);
*parameter AccumulatedAnnualDemand(REGION_FULL,FUEL,y_full);
parameter DepreciationMethod(REGION_FULL);

*
* ######## Technology Performance #############
*
parameter CapacityToActivityUnit(REGION_FULL,TECHNOLOGY);
parameter CapacityFactor(REGION_FULL,TECHNOLOGY,TIMESLICE_FULL,y_full);
parameter AvailabilityFactor(REGION_FULL,TECHNOLOGY,y_full);
parameter OperationalLife(REGION_FULL,TECHNOLOGY);
parameter ResidualCapacity(REGION_FULL,TECHNOLOGY,y_full);
parameter InputActivityRatio(REGION_FULL,TECHNOLOGY,FUEL,MODE_OF_OPERATION,y_full);
parameter OutputActivityRatio(REGION_FULL,TECHNOLOGY,FUEL,MODE_OF_OPERATION,y_full);
parameter CapacityOfOneTechnologyUnit(y_full, TECHNOLOGY, REGION_FULL);
parameter TagDispatchableTechnology(TECHNOLOGY);
parameter BaseYearProduction(TECHNOLOGY,FUEL);

*
* ######## Technology Costs #############
*
parameter CapitalCost(REGION_FULL,TECHNOLOGY,y_full);
parameter VariableCost(REGION_FULL,TECHNOLOGY,MODE_OF_OPERATION,y_full);
parameter FixedCost(REGION_FULL,TECHNOLOGY,y_full);

*
* ######## Storage Parameters #############
*
parameter StorageLevelStart(REGION_FULL,STORAGE);
parameter StorageMaxChargeRate(REGION_FULL,STORAGE);
parameter StorageMaxDischargeRate(REGION_FULL,STORAGE);
parameter MinStorageCharge(REGION_FULL,STORAGE,YEAR_FULL);
parameter OperationalLifeStorage(REGION_FULL,STORAGE,YEAR_FULL);
parameter CapitalCostStorage(REGION_FULL,STORAGE,YEAR_FULL);
parameter ResidualStorageCapacity(REGION_FULL,STORAGE,YEAR_FULL);
parameter TechnologyToStorage(YEAR_FULL,MODE_OF_OPERATION,TECHNOLOGY,STORAGE);
parameter TechnologyFromStorage(YEAR_FULL,MODE_OF_OPERATION,TECHNOLOGY,STORAGE);

parameter StorageMaxCapacity(REGION_FULL,STORAGE,YEAR_FULL);

*
* ######## Capacity Constraints #############
*
parameter TotalAnnualMaxCapacity(REGION_FULL,TECHNOLOGY,y_full);
parameter TotalAnnualMinCapacity(REGION_FULL,TECHNOLOGY,y_full);

*
* ######## Investment Constraints #############
*
parameter TotalAnnualMaxCapacityInvestment(REGION_FULL,TECHNOLOGY,y_full);
parameter TotalAnnualMinCapacityInvestment(REGION_FULL,TECHNOLOGY,y_full);

*
* ######## Activity Constraints #############
*
parameter TotalTechnologyAnnualActivityUpperLimit(REGION_FULL,TECHNOLOGY,y_full);
parameter TotalTechnologyAnnualActivityLowerLimit(REGION_FULL,TECHNOLOGY,y_full);
parameter TotalTechnologyModelPeriodActivityUpperLimit(REGION_FULL,TECHNOLOGY);
parameter TotalTechnologyModelPeriodActivityLowerLimit(REGION_FULL,TECHNOLOGY);

*
* ######## Reserve Margin ############
*
parameter ReserveMarginTagTechnology(REGION_FULL,TECHNOLOGY,y_full);
parameter ReserveMarginTagFuel(REGION_FULL,FUEL,y_full);
parameter ReserveMargin(REGION_FULL,y_full);

*
* ######## RE Generation Target ############
*
parameter RETagTechnology(REGION_FULL,TECHNOLOGY,y_full);
parameter RETagFuel(REGION_FULL,FUEL,y_full);
parameter REMinProductionTarget(REGION_FULL,FUEL,y_full);

*
* ######### Emissions & Penalties #############
*
parameter EmissionActivityRatio(REGION_FULL,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,y_full);
parameter EmissionContentPerFuel(FUEL,EMISSION);
parameter EmissionsPenalty(REGION_FULL,EMISSION,y_full);
parameter EmissionsPenaltyTagTechnology(REGION_FULL,TECHNOLOGY,EMISSION,y_full);
parameter AnnualExogenousEmission(REGION_FULL,EMISSION,y_full);
parameter AnnualEmissionLimit(EMISSION,y_full);
parameter RegionalAnnualEmissionLimit(REGION_FULL,EMISSION,y_full);
parameter ModelPeriodExogenousEmission(REGION_FULL,EMISSION);
parameter ModelPeriodEmissionLimit(EMISSION);
parameter RegionalModelPeriodEmissionLimit(EMISSION,REGION_FULL);
parameter CurtailmentCostFactor(REGION_FULL,FUEL,YEAR_FULL);

*
* ######### Trade #############
*
parameter TradeRoute(y_full,FUEL,REGION_FULL,rr_full);
parameter TradeCosts(FUEL,REGION_FULL,rr_full);
parameter TradeLossFactor(YEAR_FULL,FUEL);
parameter TradeRouteInstalledCapacity(y_full,f,r_full,rr_full);
parameter TradeLossBetweenRegions(y_full,FUEL,REGION_FULL,RR_FULL);


parameter AdditionalTradeCapacity(y_full,f,r_full,rr_full);
parameter TradeCapacity(y_full,f,r_full,rr_full);
parameter TradeCapacityGrowthCosts(f, r_full, rr_full);
parameter GrowthRateTradeCapacity(y_full, f, r_full, rr_full);
parameter TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full);

*
* ######### Time Slice Conversion #############
*
parameter Conversionls(TIMESLICE_FULL,ls);
parameter Conversionld(TIMESLICE_FULL,ld);
parameter Conversionlh(TIMESLICE_FULL,lh);
parameter DaySplit(y_full,TIMESLICE_FULL);
parameter DaysInDayType(y_full,SEASON,DAYTYPE);

*
* ######### Transportation #############
*
parameter ModalSplitByFuelAndModalType(REGION_FULL,FUEL,YEAR_FULL,MODALTYPE);
parameter TagTechnologyToModalType(TECHNOLOGY,MODE_OF_OPERATION,MODALTYPE);

* #####################
* # Model Variables #
* #####################
*
* ############### Capacity Variables ############*
*
positive variable NewCapacity(y_full,TECHNOLOGY,REGION_FULL);
positive variable AccumulatedNewCapacity(y_full,TECHNOLOGY,REGION_FULL);
positive variable TotalCapacityAnnual(y_full,TECHNOLOGY,REGION_FULL);

*
* ############### Activity Variables #############
*
positive variable RateOfActivity(y_full,TIMESLICE_FULL,TECHNOLOGY,MODE_OF_OPERATION,REGION_FULL);
positive variable RateOfTotalActivity(y_full,TIMESLICE_FULL,TECHNOLOGY,REGION_FULL);
positive variable TotalTechnologyAnnualActivity(y_full,TECHNOLOGY,REGION_FULL);
positive variable TotalAnnualTechnologyActivityByMode(y_full,TECHNOLOGY,MODE_OF_OPERATION,REGION_FULL);
positive variable RateOfProductionByTechnologyByMode(y_full,TIMESLICE_FULL,TECHNOLOGY,MODE_OF_OPERATION,FUEL,REGION_FULL);
positive variable RateOfProductionByTechnology(y_full,TIMESLICE_FULL,TECHNOLOGY,FUEL,REGION_FULL);
positive variable ProductionByTechnology(y_full,TIMESLICE_FULL,TECHNOLOGY,FUEL,REGION_FULL);
positive variable ProductionByTechnologyAnnual(y_full,TECHNOLOGY,FUEL,REGION_FULL);
positive variable RateOfProduction(y_full,TIMESLICE_FULL,FUEL,REGION_FULL);
positive variable Production(y_full,TIMESLICE_FULL,FUEL,REGION_FULL);
positive variable RateOfUseByTechnologyByMode(y_full,TIMESLICE_FULL,TECHNOLOGY,MODE_OF_OPERATION,FUEL,REGION_FULL);
positive variable RateOfUseByTechnology(y_full,TIMESLICE_FULL,TECHNOLOGY,FUEL,REGION_FULL);
positive variable UseByTechnologyAnnual(y_full,TECHNOLOGY,FUEL,REGION_FULL);
positive variable RateOfUse(y_full,TIMESLICE_FULL,FUEL,REGION_FULL);
positive variable UseByTechnology(y_full,TIMESLICE_FULL,TECHNOLOGY,FUEL,REGION_FULL);
positive variable Use(y_full,TIMESLICE_FULL,FUEL,REGION_FULL);
positive variable ProductionAnnual(y_full,FUEL,REGION_FULL);
positive variable UseAnnual(y_full,FUEL,REGION_FULL);
positive variable TotalActivityPerYear(REGION_FULL,TIMESLICE_FULL,TECHNOLOGY,YEAR_FULL);
positive variable Curtailment(y_full,TIMESLICE_FULL,f,r_full);
positive variable CurtailmentAnnual(y_full,f,r_full);
positive variable DispatchDummy(r_full,TIMESLICE_FULL,t,y_full);

*
* ############### Costing Variables #############
*
positive variable CapitalInvestment(y_full,TECHNOLOGY,REGION_FULL);
positive variable DiscountedCapitalInvestment(y_full,TECHNOLOGY,REGION_FULL);
positive variable SalvageValue(y_full,TECHNOLOGY,REGION_FULL);
positive variable DiscountedSalvageValue(y_full,TECHNOLOGY,REGION_FULL);
positive variable OperatingCost(y_full,TECHNOLOGY,REGION_FULL);
positive variable DiscountedOperatingCost(y_full,TECHNOLOGY,REGION_FULL);
positive variable AnnualVariableOperatingCost(y_full,TECHNOLOGY,REGION_FULL);
positive variable AnnualFixedOperatingCost(y_full,TECHNOLOGY,REGION_FULL);
positive variable VariableOperatingCost(y_full,TIMESLICE_FULL,TECHNOLOGY,REGION_FULL);
positive variable TotalDiscountedCost(y_full,REGION_FULL);
positive variable TotalDiscountedCostByTechnology(y_full,TECHNOLOGY,REGION_FULL)
positive variable ModelPeriodCostByRegion (REGION_FULL);

positive variable AnnualCurtailmentCost(YEAR_FULL,FUEL,REGION_FULL);
positive variable DiscountedAnnualCurtailmentCost(YEAR_FULL,FUEL,REGION_FULL);


*
* ############### Storage Variables #############
*
free variable  RateOfStorageCharge(s,y_full,ls,ld,lh,REGION_FULL);
free variable  RateOfStorageDischarge(s,y_full,ls,ld,lh,REGION_FULL);
free variable  NetChargeWithinYear(s,y_full,ls,ld,lh,REGION_FULL);
free variable  NetChargeWithinDay(s,y_full,ls,ld,lh,REGION_FULL);
positive variable StorageLevelYearStart(s,y_full,REGION_FULL);
positive variable StorageLevelTSStart(s,y_full,TIMESLICE_FULL,REGION_FULL);

positive variable StorageLevelYearFinish(s,y_full,REGION_FULL);
positive variable StorageLevelSeasonStart(s,y_full,ls,REGION_FULL);
positive variable StorageLevelDayTypeStart(s,y_full,ls,ld,REGION_FULL);
positive variable StorageLevelDayTypeFinish(s,y_full,ls,ld,REGION_FULL);
positive variable StorageLowerLimit(s,y_full,REGION_FULL);
positive variable StorageUpperLimit(s,y_full,REGION_FULL);
positive variable AccumulatedNewStorageCapacity(s,y_full,REGION_FULL);
positive variable NewStorageCapacity(s,y_full,REGION_FULL);
positive variable CapitalInvestmentStorage(s,y_full,REGION_FULL);
positive variable DiscountedCapitalInvestmentStorage(s,y_full,REGION_FULL);
positive variable SalvageValueStorage(s,y_full,REGION_FULL);
positive variable DiscountedSalvageValueStorage(s,y_full,REGION_FULL);
positive variable TotalDiscountedStorageCost(s,y_full,REGION_FULL);

*
* ######## Reserve Margin #############
*
positive variable TotalActivityInReserveMargin(REGION_FULL,y_full,TIMESLICE_FULL);
positive variable DemandNeedingReserveMargin(y_full,TIMESLICE_FULL,REGION_FULL);

*
* ######## RE Gen Target #############
*
free variable TotalREProductionAnnual(y_full,REGION_FULL,FUEL);
free variable RETotalDemandOfTargetFuelAnnual(y_full,REGION_FULL,FUEL);
free variable TotalTechnologyModelPeriodActivity(TECHNOLOGY,REGION_FULL);
positive variable RETargetMin(YEAR_FULL,REGION_FULL);
*positive variable TotalREProductionLastYear(y_full,r_full);

*
* ######## Emissions #############
*
variable AnnualTechnologyEmissionByMode(y_full,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,REGION_FULL);
variable AnnualTechnologyEmission(y_full,TECHNOLOGY,EMISSION,REGION_FULL);
variable AnnualTechnologyEmissionPenaltyByEmission(y_full,TECHNOLOGY,EMISSION,REGION_FULL);
variable AnnualTechnologyEmissionsPenalty(y_full,TECHNOLOGY,REGION_FULL);
variable DiscountedTechnologyEmissionsPenalty(y_full,TECHNOLOGY,REGION_FULL);
variable AnnualEmissions(y_full,EMISSION,REGION_FULL);
variable ModelPeriodEmissions(EMISSION,REGION_FULL);

*
* ######### Trade #############
*
positive variable Import(y_full,TIMESLICE_FULL,FUEL,REGION_FULL,rr_full);
positive variable Export(y_full,TIMESLICE_FULL,FUEL,REGION_FULL,rr_full);

positive variable NewTradeCapacity(YEAR_FULL, FUEL, REGION_FULL, rr_full);
positive variable TotalTradeCapacity(YEAR_FULL, FUEL, REGION_FULL, rr_full);
positive variable NewTradeCapacityCosts(YEAR_FULL, FUEL, REGION_FULL, rr_full);
positive variable DiscountedNewTradeCapacityCosts(YEAR_FULL, FUEL, REGION_FULL, rr_full);

free variable NetTrade(y_full,TIMESLICE_FULL,FUEL,REGION_FULL);
free variable NetTradeAnnual(y_full,FUEL,REGION_FULL);
free variable TotalTradeCosts(y_full,TIMESLICE_FULL,REGION_FULL);
free variable AnnualTotalTradeCosts(y_full,REGION_FULL);
free variable DiscountedAnnualTotalTradeCosts(y_full,REGION_FULL);

*
* ######### Transportation #############
*

parameter TrajectoryLowerLimit(y_full);
parameter TrajectoryUpperLimit(y_full);

positive variable DemandSplitByModalType(MODALTYPE,REGION_FULL,FUEL,YEAR_FULL);
positive variable ProductionSplitByModalType(MODALTYPE,REGION_FULL,FUEL,YEAR_FULL);

$ifthen %switch_ramping% == 1
*
* ######## Ramping #############
*
parameter RampingUpFactor(REGION_FULL,TECHNOLOGY,y_full);
parameter RampingDownFactor(REGION_FULL,TECHNOLOGY,y_full);

parameter ProductionChangeCost(REGION_FULL,TECHNOLOGY,y_full);

parameter MinActiveProductionPerTimeslice(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);

positive variable ProductionUpChangeInTimeslice(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);
positive variable ProductionDownChangeInTimeslice(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);

positive variable AnnualProductionChangeCost(y_full,TECHNOLOGY,REGION_FULL);
positive variable DiscountedAnnualProductionChangeCost(y_full,TECHNOLOGY,REGION_FULL);

$endif

