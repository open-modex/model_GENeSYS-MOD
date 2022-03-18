* ################## genesysmod_dataload.gms ###################
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

Parameter
Readin_TradeCosts
Readin_TradeRoute2015(f,r_full,rr_full, y_full)
Readin_PowerTradeCapacity(f,r_full,rr_full,y_full)
Readin_TotalTechnologyModelPeriodActivityUpperLimit(REGION_FULL,TECHNOLOGY)
Readin_Fuelcost(r_full,TECHNOLOGY,m,y_full)
;

$onecho >%tempdir%temp_%data_file%.tmp
se=0
        set=Emission                 Rng=Sets!A2                         rdim=1        cdim=0
        dset=Technology              Rng=Sets!B2                         rdim=1        cdim=0
        dset=Fuel                    Rng=Sets!C2                         rdim=1        cdim=0
        set=Year                     Rng=Sets!D2                         rdim=1        cdim=0
*        set=Timeslice                Rng=Sets!E2                         rdim=1        cdim=0
        set=Mode_of_operation        Rng=Sets!G2                         rdim=1        cdim=0
        set=Region_full              Rng=Sets!E2                         rdim=1        cdim=0
*        set=Season                   Rng=Sets!H2                         rdim=1        cdim=0
*        set=Daytype                  Rng=Sets!I2                         rdim=1        cdim=0
*        set=Dailytimebracket         Rng=Sets!J2                         rdim=1        cdim=0
        set=Storage                  Rng=Sets!F2                         rdim=1        cdim=0
*        set=ModalType                Rng=Sets!L2                         rdim=1        cdim=0

*        par=Yearsplit                Rng=Par_YearSplit!A5                rdim=1        cdim=1
*        par=Daysplit                 Rng=Par_Daysplit!A5                rdim=1        cdim=1
        par=CapacityToActivityUnit   Rng=Par_CapacityToActivityUnit!A1   rdim=2        cdim=0
*        par=Conversionls             Rng=Par_Conversionls!A5             rdim=1        cdim=1
*        par=Conversionld             Rng=Par_Conversionld!A5             rdim=1        cdim=1
*        par=Conversionlh             Rng=Par_Conversionlh!A5             rdim=1        cdim=1

        par=SpecifiedAnnualDemand    Rng=Par_SpecifiedAnnualDemand!A1                   rdim=2  cdim=1
*        par=SpecifiedDemandProfile   Rng=Par_SpecifiedDemandProfile!A5                  rdim=3  cdim=1
*        par=ReserveMarginTagFuel     Rng=Par_ReserveMarginTagFuel!A5                    rdim=2  cdim=1

        par=EmissionsPenalty         Rng=Par_EmissionsPenalty!A1                         rdim=2  cdim=1
        par=EmissionsPenaltyTagTechnology         Rng=Par_EmissionPenaltyTagTech!A1                         rdim=3  cdim=1
*        par=ReserveMargin            Rng=Par_ReserveMargin!A5                            rdim=1  cdim=1
*        par=AnnualExogenousEmission  Rng=Par_AnnualExogenousEmission!A4                  rdim=2  cdim=1
*        par=RegionalAnnualEmissionLimit      Rng=Par_RegionalEmissionLimit!A1                      rdim=2  cdim=1
        par=AnnualEmissionLimit      Rng=Par_AnnualEmissionLimit!A1                      rdim=1  cdim=1
        par=Readin_TradeRoute2015    Rng=Par_TradeRoute!A1                          rdim=3  cdim=1
*        par=Readin_TradeCosts        Rng=Par_TransportCosts!A5                           rdim=2  cdim=1
        par=Readin_PowerTradeCapacity  Rng=Par_TradeCapacity!A1            rdim=3  cdim=1
        par=TotalAnnualMaxTradeCapacity Rng=Par_TotalAnnualMaxTradeCapacity!A1            rdim=3 cdim=1
        par=Readin_Fuelcost              Rng=Par_FuelCost!A1             rdim=3 cdim=1

*        par=GrowthRateTradeCapacity         Rng=Par_GrowthRateTradeCapacity!A5  rdim=3 cdim=1
        par=TradeCapacityGrowthCosts        Rng=Par_TradeCapacityGrowthCost!A1  rdim=2 cdim=1

        par=InputActivityRatio       Rng=Par_InputActivityRatio!A1                       rdim=4        cdim=1
        par=OutputActivityRatio      Rng=Par_OutputActivityRatio!A1                      rdim=4        cdim=1
        par=FixedCost                Rng=Par_FixedCost!A1                                rdim=2        cdim=1
        par=CapitalCost              Rng=Par_CapitalCost!A1                              rdim=2        cdim=1
        par=VariableCost             Rng=Par_VariableCost!A1                             rdim=3        cdim=1
        par=ResidualCapacity         Rng=Par_ResidualCapacity!A1                         rdim=2        cdim=1
        par=AvailabilityFactor       Rng=Par_AvailabilityFactor!A1                       rdim=2        cdim=1
*        par=CapacityFactor           Rng=Par_CapacityFactor!A5                           rdim=3        cdim=1
        par=EmissionActivityRatio    Rng=Par_EmissionActivityRatio!A1                    rdim=4        cdim=1
        par=EmissionContentPerFuel   Rng=Par_EmissionContentPerFuel!A2                   rdim=2        cdim=0
        par=OperationalLife          Rng=Par_OperationalLife!A1                          rdim=2        cdim=0
        par=TotalAnnualMaxCapacity   Rng=Par_TotalAnnualMaxCapacity!A1                   rdim=2        cdim=1
*        par=TotalAnnualMinCapacity   Rng=Par_TotalAnnualMinCapacity!A5                   rdim=2        cdim=1
*        par=Readin_TotalTechnologyModelPeriodActivityUpperLimit   Rng=Par_ModelPeriodActivityMaxLimit!A5         rdim=2        cdim=0

        par=TotalTechnologyAnnualActivityUpperLimit   Rng=Par_TotalAnnualMaxActivity!A1                   rdim=2        cdim=1
*        par=TotalTechnologyAnnualActivityLowerLimit   Rng=Par_TotalAnnualMinActivity!A5                   rdim=2        cdim=1

*        par=ReserveMarginTagTechnology  Rng=Par_ReserveMarginTagTechnology!A5            rdim=2        cdim=1

        par=TechnologyToStorage   Rng=Par_TechnologyToStorage!A1                         rdim=4        cdim=0
        par=TechnologyFromStorage Rng=Par_TechnologyFromStorage!A1                       rdim=4        cdim=0
        par=StorageLevelStart     Rng=Par_StorageLevelStart!A6                           rdim=1        cdim=1
        par=StorageMaxChargeRate  Rng=Par_StorageMaxChargeRate!A1                        rdim=2        cdim=0
        par=StorageMaxDischargeRate Rng=Par_StorageMaxDischargeRate!A1                   rdim=2        cdim=0
        par=MinStorageCharge      Rng=Par_MinStorageCharge!A5                            rdim=2        cdim=1
        par=OperationalLifeStorage Rng=Par_OperationalLifeStorage!A1                     rdim=3        cdim=0
        par=CapitalCostStorage    Rng=Par_CapitalCostStorage!A5                          rdim=2        cdim=1
        par=ResidualStorageCapacity Rng=Par_ResidualStorageCapacity!A5                   rdim=2        cdim=1

*        par=ModalSplitByFuelAndModalType   Rng=Par_ModalSplitByFuel!A5                    rdim=3        cdim=1
*        par=TagTechnologyToModalType       Rng=Par_TagTechnologyToModalType!A5                       rdim=2        cdim=1

*        par=BaseYearProduction   Rng=Par_BaseYearProduction!A5                    rdim=2        cdim=0
         par=REMinProductionTarget Rng=Par_REMinProductionTarget!A1                           rdim=2          cdim=1
         par=RETagTechnology Rng=Par_RETagTechnology!A1                           rdim=2          cdim=1


$offecho

$ifi %switch_only_load_gdx%==0 $call "gdxxrw %inputdir%%data_file%.xlsx @%tempdir%temp_%data_file%.tmp o=%gdxdir%%data_file%.gdx MaxDupeErrors=99 CheckDate ";
$GDXin %gdxdir%%data_file%.gdx
$onUNDF
$loadm Year
*$loadm Emission Technology Fuel Timeslice Mode_of_operation Region_full Season Daytype Dailytimebracket Storage ModalType
$loadm Emission Technology Fuel Mode_of_operation Region_full Storage
*$loadm Yearsplit Daysplit CapacityToActivityUnit Conversionls Conversionld Conversionlh
$loadm CapacityToActivityUnit
$loadm SpecifiedAnnualDemand Readin_Fuelcost
*SpecifiedDemandProfile ReserveMarginTagFuel
*$loadm EmissionsPenalty ReserveMargin AnnualExogenousEmission RegionalAnnualEmissionLimit ReserveMarginTagTechnology
$loadm EmissionsPenalty AnnualEmissionLimit
*$loadm ReserveMarginTagFuel Readin_TradeRoute2015 Readin_PowerTradeCapacity GrowthRateTradeCapacity TradeCapacityGrowthCosts Readin_TradeCosts
$loadm Readin_TradeRoute2015 Readin_PowerTradeCapacity TotalAnnualMaxTradeCapacity
$loadm InputActivityRatio OutputActivityRatio FixedCost CapitalCost VariableCost ResidualCapacity   EmissionsPenaltyTagTechnology
*$loadm AvailabilityFactor CapacityFactor EmissionActivityRatio OperationalLife TotalAnnualMaxCapacity TotalAnnualMinCapacity EmissionContentPerFuel
$loadm AvailabilityFactor EmissionActivityRatio OperationalLife TotalAnnualMaxCapacity EmissionContentPerFuel TradeCapacityGrowthCosts
*$loadm TotalTechnologyAnnualActivityLowerLimit TotalTechnologyAnnualActivityUpperLimit
$loadm TotalTechnologyAnnualActivityUpperLimit
$loadm REMinProductionTarget

*$loadm Readin_TotalTechnologyModelPeriodActivityUpperLimit
$loadm TechnologyToStorage TechnologyFromStorage StorageLevelStart StorageMaxChargeRate StorageMaxDischargeRate MinStorageCharge
$loadm CapitalCostStorage OperationalLifeStorage
$load  ResidualStorageCapacity RETagTechnology
*$load  ModalSplitByFuelAndModalType TagTechnologyToModalType BaseYearProduction
$offUNDF



***UnitConversion for MODEX***
*Demand in GWh
SpecifiedAnnualDemand(REGION_FULL,FUEL,YEAR_FULL)$SpecifiedAnnualDemand(REGION_FULL,FUEL,YEAR_FULL) = SpecifiedAnnualDemand(REGION_FULL,FUEL,YEAR_FULL)/1000;
*AnnualEmissionLimit in MT
AnnualEmissionLimit(Emission,YEAR_FULL)$AnnualEmissionLimit(Emission,YEAR_FULL) = AnnualEmissionLimit(Emission,YEAR_FULL) / 1000000;
AnnualEmissionLimit(Emission,'2016') = 999999;
* Readin_PowerTradeCapacity in GW
Readin_PowerTradeCapacity(f,r_full,rr_full,y_full)$Readin_PowerTradeCapacity(f,r_full,rr_full,y_full) = Readin_PowerTradeCapacity(f,r_full,rr_full,y_full)/1000;
*FixedCost in Mio € / GW
FixedCost(r_full,t,y_full)$FixedCost(r_full,t,y_full) = FixedCost(r_full,t,y_full)/1000;
*CapitalCost in Mio € / GW
CapitalCost(r_full,t,y_full)$CapitalCost(r_full,t,y_full) = CapitalCost(r_full,t,y_full)/1000;
CapitalCost(r_full,'storage_battery_electricity',y_full) = CapitalCost(r_full,'storage_battery_electricity',y_full) * StorageMaxChargeRate('DE','S_storage_battery_electricity');
CapitalCost(r_full,'storage_salt cavern_hydrogen',y_full) = CapitalCost(r_full,'storage_salt cavern_hydrogen',y_full) * StorageMaxChargeRate('DE','S_storage_salt cavern_hydrogen');   
*VariableCost in Mio € / GWh
VariableCost(r_full,t,m,y_full)$VariableCost(r_full,t,m,y_full) = (VariableCost(r_full,t,m,y_full)+sum(f,InputActivityRatio(r_full,t,f,'1',y_full)*Readin_Fuelcost(r_full,t,m,y_full)))/1000;
*ResidualCapacity in GW
ResidualCapacity(r_full,t,y_full)$ResidualCapacity(r_full,t,y_full) = ResidualCapacity(r_full,t,y_full)/1000;
ResidualCapacity(r_full,t,y_full)$(ResidualCapacity(r_full,t,y_full)<0.001) = 0;
*ResidualCapacity(r_full,'photovoltaics_unknown_solar radiation',y_full) = ResidualCapacity(r_full,'photovoltaics_utility_solar radiation',y_full) + ResidualCapacity(r_full,'photovoltaics_rooftop_solar radiation',y_full);
OperationalLife(r_full,'photovoltaics_unknown_solar radiation') = 30;
OperationalLife(r_full,'wind turbine_offshore_air') = 25.4;
TradeCapacityGrowthCosts('electricity',r_full,rr_full) = TradeCapacityGrowthCosts('electricity','DE','DE')/1000;
*ResidualCapacity(r_full,'photovoltaics_utility_solar radiation',y_full) = 0;
*ResidualCapacity(r_full,'photovoltaics_rooftop_solar radiation',y_full) = 0;
CapitalCost(r_full,'photovoltaics_unknown_solar radiation',y_full)= CapitalCost(r_full,'photovoltaics_utility_solar radiation',y_full);
FixedCost(r_full,'photovoltaics_unknown_solar radiation',y_full)= FixedCost(r_full,'photovoltaics_utility_solar radiation',y_full);
*TotalAnnualMaxCapacity in GW
TotalAnnualMaxCapacity(r_full,t,y_full)$TotalAnnualMaxCapacity(r_full,t,y_full) = TotalAnnualMaxCapacity(r_full,t,y_full)/1000;
*EmissionActivityRatio in Mt/GWh
EmissionActivityRatio(r_full,t,e,m,y_full) = EmissionActivityRatio(r_full,t,e,m,y_full)/1000;
*EmissionPenalty for all regions
EmissionsPenalty(r_full,e,y_full) = EmissionsPenalty('DE',e,y_full);
*REMinProductionTarget for all Regions
REMinProductionTarget(r_full,f,y_full) = REMinProductionTarget('DE',f,y_full);
*TotalAnnualMaxTradeCapacity in GW
TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full) = TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full)/1000;
TotalAnnualMaxTradeCapacity(f,rr_full,r_full,y_full)$(TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full)>0 and TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full) < 999.999) = TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full);
Parameter TotalAnnualMaxDCTradeCapacity;
TotalAnnualMaxDCTRadeCapacity(f,r_full,rr_full,y_full)$(TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full) > 0 and TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full) < 999.999) = TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full);
TotalAnnualMaxDCTRadeCapacity(f,rr_full,r_full,y_full)$(TotalAnnualMaxDCTRadeCapacity(f,r_full,rr_full,y_full) > 0) = TotalAnnualMaxDCTRadeCapacity(f,r_full,rr_full,y_full);
TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full)$(Readin_PowerTradeCapacity(f,r_full,rr_full,y_full)>TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full)) = Readin_PowerTradeCapacity(f,r_full,rr_full,y_full);
TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full)$(TotalAnnualMaxDCTRadeCapacity(f,r_full,rr_full,y_full) > 0 and (TotalAnnualMaxDCTRadeCapacity(f,r_full,rr_full,y_full) > TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full) or TotalAnnualMaxDCTRadeCapacity(f,r_full,rr_full,y_full) < TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full))) = TotalAnnualMaxTradeCapacity(f,r_full,rr_full,y_full) + TotalAnnualMaxDCTRadeCapacity(f,r_full,rr_full,y_full);
TotalAnnualMaxTradeCapacity('electricity','NI','NW',y)$(ord(y)>1 and TotalAnnualMaxTradeCapacity('electricity','NI','NW',y)>0) = 999.999;
TotalAnnualMaxTradeCapacity('electricity','NW','NI',y)$(ord(y)>1 and TotalAnnualMaxTradeCapacity('electricity','NW','NI',y)>0) = 999.999;
Readin_PowerTradeCapacity(f,r_full,rr_full,y_full) = Readin_PowerTradeCapacity(f,r_full,rr_full,y_full) + TotalAnnualMaxDCTRadeCapacity(f,rr_full,r_full,y_full);
*TotalTechnologyAnnualActivityUpperLimit in GWh
TotalTechnologyAnnualActivityUpperLimit(r_full,t,y_full) = TotalTechnologyAnnualActivityUpperLimit(r_full,t,y_full)*1000/3.6;


*Storage Cost change
$ontext
CapitalCostStorage(r_full,'S_storage_battery_electricity',y_full) = CapitalCost(r_full,'storage_battery_electricity',y_full);
CapitalCostStorage(r_full,'S_storage_hydrogen fuelcell_electricity',y_full) = CapitalCost(r_full,'storage_hydrogen fuelcell_electricity',y_full);
CapitalCostStorage(r_full,'S_storage_hydrogen gas_electricity',y_full) = CapitalCost(r_full,'storage_hydrogen gas_electricity',y_full);
CapitalCostStorage(r_full,'S_storage_pumped_electricity',y_full) = CapitalCost(r_full,'storage_pumped_electricity',y_full);

CapitalCost(r_full,'storage_battery_electricity',y_full) = 0;
CapitalCost(r_full,'storage_hydrogen fuelcell_electricity',y_full) = 0;
CapitalCost(r_full,'storage_hydrogen gas_electricity',y_full) = 0;
CapitalCost(r_full,'storage_pumped_electricity',y_full) = 0;
$offtext

*InputActivity und OutputActivity gefixt
*InputActivityRatio(r_full,t,f,m,y_full)$(InputActivityRatio(r_full,t,f,m,y_full)) = 1/InputActivityRatio(r_full,t,f,m,y_full);



*
* ####### Including Subsets #############
*

$include genesysmod_subsets.gms

StartYear = %year% ;

$ifthen %switch_all_regions% == 1
REGION(REGION_FULL) = yes;
$else
REGION(REGION_FULL)$(ord(REGION_FULL) < 4) = yes;
$endif

$ifthen %switch_aggregate_region% == 1

$onmulti
Set REGION_FULL / %model_region% /;
$offmulti
REGION(REGION_FULL) = yes;
REGION('%model_region%') = no;

$endif

*TechnologyFromStorage(y,m,'D_PHS',s)=0.94;

*
* ####### Assigning TradeRoutes depending on initialized Regions and Year #############
*
TradeRoute(y,f,r,rr) = Readin_TradeRoute2015(f,r,rr, y);
TradeCapacity(y,f,r,rr) = Readin_PowerTradeCapacity(f,r,rr,y);
*TradeCosts(f,r,rr) = Readin_TradeCosts(f,r,rr);
*GrowthRateTradeCapacity(y,'Elec',r,rr) = GrowthRateTradeCapacity('2015','Elec',r,rr);

*TradeLossFactor(y,'Elec') = 0.00003;
*TradeLossBetweenRegions(y,f,r,rr) = TradeLossFactor(y,f)*TradeRoute(y,f,r,rr);
TradeLossBetweenRegions(y,f,r,rr) = 0.03;


*
* ######### Missing in Excel, Overwriten later in scenario data #############
*
ModelPeriodEmissionLimit(EMISSION) = 99999;
RegionalModelPeriodEmissionLimit(EMISSION,REGION_FULL) = 99999;

*
* ######### YearValue assignment #############
*
parameter YearVal(y_full);
YearVal(y) = y.val ;

*
* ####### Set regional values, if only value given for base-region #############
*

CapitalCost(REGION,TECHNOLOGY,y)$(CapitalCost(REGION,TECHNOLOGY,y) = 0) = CapitalCost('%data_base_region%',TECHNOLOGY,y);
VariableCost(REGION,TECHNOLOGY,MODE_OF_OPERATION,y)$(VariableCost(REGION,TECHNOLOGY,MODE_OF_OPERATION,y) = 0) = VariableCost('%data_base_region%',TECHNOLOGY,MODE_OF_OPERATION,y);
FixedCost(REGION,TECHNOLOGY,y)$(FixedCost(REGION,TECHNOLOGY,y) = 0) = FixedCost('%data_base_region%',TECHNOLOGY,y);
AvailabilityFactor(REGION,TECHNOLOGY,y)$(AvailabilityFactor(REGION,TECHNOLOGY,y) = 0) = AvailabilityFactor('%data_base_region%',TECHNOLOGY,y);
InputActivityRatio(REGION,TECHNOLOGY,FUEL,MODE_OF_OPERATION,y)$(InputActivityRatio(REGION,TECHNOLOGY,FUEL,MODE_OF_OPERATION,y) = 0) = InputActivityRatio('%data_base_region%',TECHNOLOGY,FUEL,MODE_OF_OPERATION,y);
OutputActivityRatio(REGION,TECHNOLOGY,FUEL,MODE_OF_OPERATION,y)$(OutputActivityRatio(REGION,TECHNOLOGY,FUEL,MODE_OF_OPERATION,y) = 0) = OutputActivityRatio('%data_base_region%',TECHNOLOGY,FUEL,MODE_OF_OPERATION,y);
OperationalLife(REGION,TECHNOLOGY)$(OperationalLife(REGION,TECHNOLOGY) = 0) = OperationalLife('%data_base_region%',TECHNOLOGY);
OperationalLifeStorage(REGION,STORAGE,YEAR)$(OperationalLifeStorage(REGION,STORAGE,YEAR) = 0) = OperationalLifeStorage('%data_base_region%',STORAGE,YEAR);
EmissionsPenaltyTagTechnology(REGION,t,e,y)$(EmissionsPenaltyTagTechnology(REGION,t,e,y) = 0) = EmissionsPenaltyTagTechnology('%data_base_region%',t,e,y);

*ReserveMarginTagTechnology(REGION,TECHNOLOGY,y)$(ReserveMarginTagTechnology(REGION,TECHNOLOGY,y) = 0) = ReserveMarginTagTechnology('%data_base_region%',TECHNOLOGY,y);

StorageMaxChargeRate(REGION,s)$(StorageMaxChargeRate(REGION,s) = 0) = StorageMaxChargeRate('%data_base_region%',s);
StorageMaxDischargeRate(REGION,s)$(StorageMaxDischargeRate(REGION,s) = 0) = StorageMaxDischargeRate('%data_base_region%',s);
EmissionActivityRatio(REGION,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR)$(EmissionActivityRatio(REGION,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR)=0) =  EmissionActivityRatio('%data_base_region%',TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR);

CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = CapacityToActivityUnit('%data_base_region%',t);
*
* ####### Load from hourly Data #############
*
$ifthen %timeseries% == elmod
$offlisting
$include genesysmod_timeseries_reduction.gms

$elseif %timeseries% == classic
$offlisting
$include genesysmod_timeseries_timeslices.gms

CapacityFactor(r,Solar,'Q1N',y) = 0;
CapacityFactor(r,Solar,'Q2N',y) = 0;
CapacityFactor(r,Solar,'Q3N',y) = 0;
CapacityFactor(r,Solar,'Q4N',y) = 0;
$endif

AvailabilityFactor(Region,'nuclear_unknown_uranium','2030') = 0;
AvailabilityFactor(Region,'nuclear_unknown_uranium','2050') = 0;


VariableCost(r_full,t,m,y_full)$(InputActivityRatio(r_full,t,'biogas',m,y_full) > 0) = VariableCost(r_full,t,m,y_full) - VariableCost(r_full,'R_biogas',m,y_full);
VariableCost(r_full,t,m,y_full)$(InputActivityRatio(r_full,t,'biomass',m,y_full) > 0) = VariableCost(r_full,t,m,y_full) - VariableCost(r_full,'R_biomass',m,y_full);
VariableCost(r_full,t,m,y_full)$(InputActivityRatio(r_full,t,'hard coal',m,y_full) > 0) = VariableCost(r_full,t,m,y_full) - VariableCost(r_full,'R_hard coal',m,y_full);
VariableCost(r_full,t,m,y_full)$(InputActivityRatio(r_full,t,'light oil',m,y_full) > 0) = VariableCost(r_full,t,m,y_full) - VariableCost(r_full,'R_light oil',m,y_full);
VariableCost(r_full,t,m,y_full)$(InputActivityRatio(r_full,t,'lignite',m,y_full) > 0) = VariableCost(r_full,t,m,y_full) - VariableCost(r_full,'R_lignite',m,y_full);
VariableCost(r_full,t,m,y_full)$(InputActivityRatio(r_full,t,'uranium',m,y_full) > 0) = VariableCost(r_full,t,m,y_full) - VariableCost(r_full,'R_uranium',m,y_full);
VariableCost(r_full,t,m,y_full)$(InputActivityRatio(r_full,t,'natural gas',m,y_full) > 0) = VariableCost(r_full,t,m,y_full) - VariableCost(r_full,'R_natural gas',m,y_full);








