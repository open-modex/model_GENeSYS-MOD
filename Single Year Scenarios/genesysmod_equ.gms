* #################### genesysmod_equ.gms #####################
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



* ######################
* # Objective Function #
* ######################

free variable z;
equation cost;
cost.. z =e= sum((y,r), TotalDiscountedCost(y,r)) + sum((y,r), DiscountedAnnualTotalTradeCosts(y,r)) + sum((y,f,r,rr), DiscountedNewTradeCapacityCosts(y,f,r,rr)) + sum((y,f,r), DiscountedAnnualCurtailmentCost(y,f,r));

* #########################
* # Parameter assignments #
* #########################



RateOfDemand(y,l,f,r) = SpecifiedAnnualDemand(r,f,y)*SpecifiedDemandProfile(r,f,l,y) / YearSplit(l,y);
Demand(y,l,f,r) = RateOfDemand(y,l,f,r)*YearSplit(l,y);



parameter CanFuelBeUsedByModeByTech(YEAR_FULL, FUEL, REGION_FULL,TECHNOLOGY,MODE_OF_OPERATION);
CanFuelBeUsedByModeByTech(y,f,r,t,m)$
(InputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            sum(l,CapacityFactor(r,t,l,y))*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y)
 > 0) = 1;



parameter CanFuelBeUsedByTech(YEAR_FULL, FUEL, REGION_FULL,TECHNOLOGY);
CanFuelBeUsedByTech(y,f,r,t)$
(sum((m), InputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            sum(l,CapacityFactor(r,t,l,y))*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y))
 > 0) = 1;


parameter CanFuelBeUsed(YEAR_FULL, FUEL, REGION_FULL);
CanFuelBeUsed(y,f,r)$
(sum((m,t), InputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            sum(l,CapacityFactor(r,t,l,y))*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y))
 > 0) = 1;

parameter CanFuelBeUsedInTimeslice(YEAR_FULL, TIMESLICE_FULL, FUEL, REGION_FULL);
CanFuelBeUsedInTimeslice(y,l,f,r)$
(sum((m,t), InputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            CapacityFactor(r,t,l,y)*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y))
 > 0) = 1;

parameter CanFuelBeUsedOrDemanded(YEAR_FULL, FUEL, REGION_FULL);
CanFuelBeUsedOrDemanded(y,f,r)$
(sum((m,t), InputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            sum(l,CapacityFactor(r,t,l,y))*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y))
 > 0 or SpecifiedAnnualDemand(r,f,y) > 0) = 1;

parameter CanFuelBeProducedByModeByTech(YEAR_FULL, FUEL, REGION_FULL,TECHNOLOGY,MODE_OF_OPERATION);
CanFuelBeProducedByModeByTech(y,f,r,t,m)$
(OutputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            sum(l,CapacityFactor(r,t,l,y))*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y)
 > 0) = 1;

parameter CanFuelBeProducedByTech(YEAR_FULL, FUEL, REGION_FULL,TECHNOLOGY);
CanFuelBeProducedByTech(y,f,r,t)$
(sum((m), OutputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            sum(l,CapacityFactor(r,t,l,y))*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y))
 > 0) = 1;


parameter CanFuelBeProduced(YEAR_FULL, FUEL, REGION_FULL);
CanFuelBeProduced(y,f,r)$
(sum((m,t), OutputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            sum(l,CapacityFactor(r,t,l,y))*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y))
 > 0) = 1;

parameter CanFuelBeProducedInTimeslice(YEAR_FULL, TIMESLICE_FULL, FUEL, REGION_FULL);
CanFuelBeProducedInTimeslice(y,l,f,r)$
(sum((m,t), OutputActivityRatio(r,t,f,m,y)*
            TotalAnnualMaxCapacity(r,t,y)*
            CapacityFactor(r,t,l,y)*
            AvailabilityFactor(r,t,y)*
            TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
            TotalTechnologyAnnualActivityUpperLimit(r,t,y))
 > 0) = 1;

parameter IgnoreFuel(YEAR_FULL, FUEL, REGION_FULL);
IgnoreFuel(y,f,r)$
(CanFuelBeUsedOrDemanded(y,f,r) = 1 and CanFuelBeProduced(y,f,r) = 0) = 1;

parameter PureDemandFuel(YEAR_FULL, FUEL, REGION_FULL);
PureDemandFuel(y,f,r)$
(CanFuelBeUsed(y,f,r) = 0 and SpecifiedAnnualDemand(r,f,y) > 0) = 1;

* ###############
* # Constraints #
* ###############


*
* ############### Capacity Adequacy A #############
*
equation CAa1_TotalNewCapacity(YEAR_FULL,TECHNOLOGY,REGION_FULL);
CAa1_TotalNewCapacity(y,t,r)$(sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)), TotalAnnualMaxCapacity(r,t,yy)) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0).. AccumulatedNewCapacity(y,t,r) =e= sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)), NewCapacity(yy,t,r));
AccumulatedNewCapacity.fx(y,t,r)$(sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)), TotalAnnualMaxCapacity(r,t,yy)) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0) = 0;
AccumulatedNewCapacity.fx(y,t,r)$(sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)), TotalAnnualMaxCapacity(r,t,yy)) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0) = 0;

equation CAa2_TotalAnnualCapacity(YEAR_FULL,TECHNOLOGY,REGION_FULL);
CAa2_TotalAnnualCapacity(y,t,r)$(AccumulatedNewCapacity.up(y,t,r) > 0 or ResidualCapacity(r,t,y) > 0).. AccumulatedNewCapacity(y,t,r) + ResidualCapacity(r,t,y) =e= TotalCapacityAnnual(y,t,r);
TotalCapacityAnnual.fx(y,t,r)$(AccumulatedNewCapacity.up(y,t,r) = 0 and ResidualCapacity(r,t,y) = 0) = 0;
AccumulatedNewCapacity.fx(y,t,r)$(AccumulatedNewCapacity.up(y,t,r) = 0) = 0;

equation CAa3_TotalActivityOfEachTechnology(YEAR_FULL,TECHNOLOGY,TIMESLICE_FULL,REGION_FULL);
CAa3_TotalActivityOfEachTechnology(y,t,l,r)$(CapacityFactor(r,t,l,y) > 0 and AvailabilityFactor(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0).. sum(m, RateOfActivity(y,l,t,m,r)) =e= RateOfTotalActivity(y,l,t,r);
RateOfTotalActivity.fx(y,l,t,r)$(CapacityFactor(r,t,l,y) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0) = 0;
RateOfActivity.fx(y,l,t,m,r)$(CapacityFactor(r,t,l,y) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0) = 0;

equation CAa4_Constraint_Capacity(REGION_FULL,TIMESLICE_FULL,TECHNOLOGY,YEAR_FULL);
CAa4_Constraint_Capacity(r,l,t,y)$(CapacityFactor(r,t,l,y) > 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0).. RateOfTotalActivity(y,l,t,r) =e= TotalActivityPerYear(r,l,t,y) - DispatchDummy(r,l,t,y)*TagDispatchableTechnology(t);
TotalActivityPerYear.fx(r,l,t,y)$(CapacityFactor(r,t,l,y) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0) = 0;

equation CAaT_TESTVARIABLE_Intertemporal(REGION_FULL,TIMESLICE_FULL,TECHNOLOGY,YEAR_FULL);
CAaT_TESTVARIABLE_Intertemporal(r,l,t,y)$((sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)),CapacityFactor(r,t,l,yy)) > 0 or sum(yy$(ord(yy)=1),CapacityFactor(r,t,l,y)) > 0) and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0).. TotalActivityPerYear(r,l,t,y) =e= sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)),(NewCapacity(yy,t,r) * CapacityFactor(r,t,l,yy) * CapacityToActivityUnit(r,t)))+(ResidualCapacity(r,t,y)*sum(yy$(ord(yy)=1),CapacityFactor(r,t,l,yy)) * CapacityToActivityUnit(r,t));
TotalActivityPerYear.fx(r,l,t,y)$((sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)),CapacityFactor(r,t,l,yy)) = 0 and sum(yy$(ord(yy)=1),CapacityFactor(r,t,l,y)) = 0) or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0) = 0;
*CapacityFactor(r,t,l,'2030') = 0)

$ifthen  %UseMipSolver% == yes
equation CAa5_TotalNewCapacity(YEAR_FULL,TECHNOLOGY,REGION_FULL);
CAa5_TotalNewCapacity(y,t,r)$(CapacityOfOneTechnologyUnit(y,t,r) <> 0 and AvailabilityFactor(r,t,y) > 0).. CapacityOfOneTechnologyUnit(y,t,r) * NumberOfNewTechnologyUnits(y,t,r) =e= NewCapacity(y,t,r);
$endif

*
* ############### Capacity Adequacy B #############
*
equation CAb1_PlannedMaintenance(YEAR_FULL,TECHNOLOGY,REGION_FULL);
CAb1_PlannedMaintenance(y,t,r)$(AvailabilityFactor(r,t,y)<1 and TagDispatchableTechnology(t)=1 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0 and TotalCapacityAnnual.up(y,t,r) > 0).. sum(l, RateOfTotalActivity(y,l,t,r)*YearSplit(l,y)) =l= sum(l,TotalCapacityAnnual(y,t,r)*CapacityFactor(r,t,l,y)*YearSplit(l,y)*AvailabilityFactor(r,t,y)*CapacityToActivityUnit(r,t));
RateOfTotalActivity.fx(y,l,t,r)$(CapacityFactor(r,t,l,y) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or TotalCapacityAnnual.up(y,t,r) = 0) = 0;

*
* ##############* Energy Balance A #############
*


parameter CanBuildTechnology(YEAR_FULL, TECHNOLOGY, REGION_FULL);
CanBuildTechnology(y,t,r)$
(TotalAnnualMaxCapacity(r,t,y)*
 sum(l,CapacityFactor(r,t,l,y))*
 AvailabilityFactor(r,t,y)*
 TotalTechnologyModelPeriodActivityUpperLimit(r,t)*
 TotalTechnologyAnnualActivityUpperLimit(r,t,y)
 > 0 and TotalCapacityAnnual.up(y,t,r) > 0) = 1;

equation EBa1_RateOfFuelProduction1(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,MODE_OF_OPERATION,REGION_FULL);
EBa1_RateOfFuelProduction1(y,l,f,t,m,r)$(OutputActivityRatio(r,t,f,m,y) <> 0 and CanFuelBeProducedByModeByTech(y,f,r,t,m) > 0 and CapacityFactor(r,t,l,y) > 0)..
         RateOfActivity(y,l,t,m,r)*OutputActivityRatio(r,t,f,m,y) =e= RateOfProductionByTechnologyByMode(y,l,t,m,f,r);
RateOfProductionByTechnologyByMode.fx(y,l,t,m,f,r)$(OutputActivityRatio(r,t,f,m,y) = 0 or CanFuelBeProducedByModeByTech(y,f,r,t,m) = 0 or CapacityFactor(r,t,l,y) = 0) = 0;

equation EBa2_RateOfFuelProduction2(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);
EBa2_RateOfFuelProduction2(y,l,f,t,r)$(sum(m, OutputActivityRatio(r,t,f,m,y)) > 0 and CanFuelBeProducedByTech(y,f,r,t) > 0 and CapacityFactor(r,t,l,y) > 0)..
         sum(m$(OutputActivityRatio(r,t,f,m,y) <> 0), RateOfProductionByTechnologyByMode(y,l,t,m,f,r)) =e= RateOfProductionByTechnology(y,l,t,f,r);
RateOfProductionByTechnology.fx(y,l,t,f,r)$(sum(m, OutputActivityRatio(r,t,f,m,y)) = 0 or CanFuelBeProducedByTech(y,f,r,t) = 0 or CapacityFactor(r,t,l,y) = 0) = 0;

equation EBa3_RateOfFuelProduction3(YEAR_FULL,TIMESLICE_FULL,FUEL,REGION_FULL);
EBa3_RateOfFuelProduction3(y,l,f,r)$(CanFuelBeProducedInTimeslice(y,l,f,r) > 0).. sum(t, RateOfProductionByTechnology(y,l,t,f,r)) =e= RateOfProduction(y,l,f,r);
RateOfProduction.fx(y,l,f,r)$(CanFuelBeProducedInTimeslice(y,l,f,r) = 0) = 0;

equation EBa4_RateOfFuelUse1(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,MODE_OF_OPERATION,REGION_FULL);
EBa4_RateOfFuelUse1(y,l,f,t,m,r)$(InputActivityRatio(r,t,f,m,y) <> 0 and CanFuelBeUsedByModeByTech(y,f,r,t,m) > 0 and CapacityFactor(r,t,l,y) > 0)..
         RateOfActivity(y,l,t,m,r)*InputActivityRatio(r,t,f,m,y) =e= RateOfUseByTechnologyByMode(y,l,t,m,f,r);
RateOfUseByTechnologyByMode.fx(y,l,t,m,f,r)$(InputActivityRatio(r,t,f,m,y) = 0 or CanFuelBeUsedByModeByTech(y,f,r,t,m) = 0 or CapacityFactor(r,t,l,y) = 0) = 0;

equation EBa5_RateOfFuelUse2(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);
EBa5_RateOfFuelUse2(y,l,f,t,r)$(sum(m, InputActivityRatio(r,t,f,m,y)) > 0 and CanFuelBeUsedByTech(y,f,r,t) > 0 and CapacityFactor(r,t,l,y) > 0)..
         sum(m$(InputActivityRatio(r,t,f,m,y) <> 0), RateOfUseByTechnologyByMode(y,l,t,m,f,r)) =e= RateOfUseByTechnology(y,l,t,f,r);
RateOfUseByTechnology.fx(y,l,t,f,r)$(sum(m, InputActivityRatio(r,t,f,m,y)) = 0 or CanFuelBeUsedByTech(y,f,r,t) = 0 or CapacityFactor(r,t,l,y) = 0) = 0;

equation EBa6_RateOfFuelUse3(YEAR_FULL,TIMESLICE_FULL,FUEL,REGION_FULL);
EBa6_RateOfFuelUse3(y,l,f,r)$(CanFuelBeUsedInTimeslice(y,l,f,r) > 0).. sum(t, RateOfUseByTechnology(y,l,t,f,r)) =e= RateOfUse(y,l,f,r);
RateOfUse.fx(y,l,f,r)$(CanFuelBeUsedInTimeslice(y,l,f,r) = 0) = 0;

equation EBa7_EnergyBalanceEachTS1(YEAR_FULL,TIMESLICE_FULL,FUEL,REGION_FULL);
EBa7_EnergyBalanceEachTS1(y,l,f,r)$(RateOfProduction.up(y,l,f,r) > 0).. RateOfProduction(y,l,f,r)*YearSplit(l,y) =e= Production(y,l,f,r);
Production.fx(y,l,f,r)$(RateOfProduction.up(y,l,f,r) = 0) = 0;

equation EBa8_EnergyBalanceEachTS2(YEAR_FULL,TIMESLICE_FULL,FUEL,REGION_FULL);
EBa8_EnergyBalanceEachTS2(y,l,f,r)$(RateOfUse.up(y,l,f,r) > 0).. RateOfUse(y,l,f,r)*YearSplit(l,y) =e= Use(y,l,f,r);
Use.fx(y,l,f,r)$(RateOfUse.up(y,l,f,r) = 0) = 0;

equation EBa10_EnergyBalanceEachTS4(YEAR_FULL,TIMESLICE_FULL,FUEL,r_full,rr_FULL);
EBa10_EnergyBalanceEachTS4(y,l,f,r,rr)$(TradeRoute(y,f,r,rr)).. Import(y,l,f,r,rr) =e= Export(y,l,f,rr,r);
Import.fx(y,l,f,r,rr)$(TradeRoute(y,f,r,rr) = 0) = 0;
Export.fx(y,l,f,rr,r)$(TradeRoute(y,f,r,rr) = 0) = 0;

NetTrade.fx(y,l,f,r)$(sum(rr,TradeRoute(y,f,r,rr)) = 0) = 0;
*Production.fx(y,l,f,r)$(Use.up(y,l,f,r) = 0 and NetTrade.up(y,l,f,r) = 0) = 0;
*Use.fx(y,l,f,r)$(Production.up(y,l,f,r) = 0 and NetTrade.up(y,l,f,r) = 0) = 0;

equation EBa11_EnergyBalanceEachTS5(YEAR_FULL,TIMESLICE_FULL,FUEL,REGION_FULL);
EBa11_EnergyBalanceEachTS5(y,l,f,r)$(IgnoreFuel(y,f,r) = 0).. Production(y,l,f,r) =e= (Demand(y,l,f,r) + Use(y,l,f,r) + NetTrade(y,l,f,r) +  Curtailment(y,l,f,r));
* + NetTrade(y,l,f,r) + Curtailment(y,l,f,r));

equation EBa12_NetTradeBalance(YEAR_FULL,TIMESLICE_FULL,FUEL,REGION_FULL);
EBa12_NetTradeBalance(y,l,f,r)$(sum(rr,TradeRoute(y,f,r,rr)) > 0).. sum(rr$(TradeRoute(y,f,r,rr)), Export(y,l,f,r,rr)*(1+TradeLossBetweenRegions(y,f,r,rr)) - Import(y,l,f,r,rr)) =e= NetTrade(y,l,f,r);

equation EBa13_CurtailmentAnnual(YEAR_FULL,FUEL,REGION_FULL);
EBa13_CurtailmentAnnual(y,f,r).. CurtailmentAnnual(y,f,r) =e= sum(l,Curtailment(y,l,f,r));
*CurtailmentAnnual.fx(y,f,r)$(sum(l,Curtailment.up(y,l,f,r)) = 0) = 0;

*
* ##############* Energy Balance B #############
*


equation EBb1_EnergyBalanceEachYear1(YEAR_FULL,FUEL,REGION_FULL);
EBb1_EnergyBalanceEachYear1(y,f,r)$(IgnoreFuel(y,f,r) = 0).. sum(l, Production(y,l,f,r)) =e= ProductionAnnual(y,f,r);
ProductionAnnual.fx(y,f,r)$(IgnoreFuel(y,f,r) > 0) = 0;

equation EBb2_EnergyBalanceEachYear2(YEAR_FULL,FUEL,REGION_FULL);
EBb2_EnergyBalanceEachYear2(y,f,r)$(PureDemandFuel(y,f,r) = 0).. sum(l, Use(y,l,f,r)) =e= UseAnnual(y,f,r);
UseAnnual.fx(y,f,r)$(PureDemandFuel(y,f,r) > 0) = 0;

equation EBb3_EnergyBalanceEachYear3(YEAR_FULL,FUEL,REGION_FULL);
EBb3_EnergyBalanceEachYear3(y,f,r)$(sum(rr,TradeRoute(y,f,r,rr)) > 0).. sum(l, (NetTrade(y,l,f,r))) =e= NetTradeAnnual(y,f,r);
NetTradeAnnual.fx(y,f,r)$(sum(rr,TradeRoute(y,f,r,rr)) = 0) = 0;
NetTradeAnnual.fx(y,f,r)$(UseAnnual.up(y,f,r) = 0 and ProductionAnnual.up(y,f,r) = 0) = 0;

equation EBb4_EnergyBalanceEachYear4(YEAR_FULL,FUEL,REGION_FULL);
EBb4_EnergyBalanceEachYear4(y,f,r).. ProductionAnnual(y,f,r) =g= UseAnnual(y,f,r) + NetTradeAnnual(y,f,r);


*
* ##############* Trade Capacities & Investments #############
*
equation TrC1_TradeCapacityPowerLinesImport(YEAR_FULL,TIMESLICE_FULL,FUEL,REGION_FULL,rr_full);
TrC1_TradeCapacityPowerLinesImport(y,l,'electricity',r,rr)$(TradeRoute(y,'electricity',rr,r) > 0).. (Import(y,l,'electricity',r,rr)) =l= TotalTradeCapacity(y,'electricity',rr,r)*8760*YearSplit(l,y);
equation TrC1_TradeCapacityPowerLinesExport(YEAR_FULL,TIMESLICE_FULL,FUEL,REGION_FULL,rr_full);
TrC1_TradeCapacityPowerLinesExport(y,l,'electricity',r,rr)$(TradeRoute(y,'electricity',r,rr) > 0).. (Export(y,l,'electricity',r,rr)) =l= TotalTradeCapacity(y,'electricity',r,rr)*8760*YearSplit(l,y);


equation TrC2a_TotalTradeCapacity(YEAR_FULL,FUEL,REGION_FULL,rr_full);
TrC2a_TotalTradeCapacity(y,'electricity',r,rr)$(TradeRoute(y,'electricity',r,rr) > 0 and ord(y)=1).. TotalTradeCapacity(y,'electricity',r,rr) =e= TradeCapacity(y,'electricity',r,rr)+NewTradeCapacity(y,'electricity',r,rr);
NewTradeCapacity.fx('2016','electricity',r,rr)=0;
equation TrC2b_TotalTradeCapacity(YEAR_FULL,FUEL,REGION_FULL,rr_full);
TrC2b_TotalTradeCapacity(y,'electricity',r,rr)$(TradeRoute(y,'electricity',r,rr) > 0 and ord(y)>1).. TotalTradeCapacity(y,'electricity',r,rr) =e= TotalTradeCapacity(y-1,'electricity',r,rr) + NewTradeCapacity(y,'electricity',r,rr) + AdditionalTradeCapacity(y,'electricity',r,rr);
equation TrC2c_TotalMaxTradeCapacity(YEAR_FULL,FUEL,REGION_FULL,rr_full);
TrC2c_TotalMaxTradeCapacity(y,f,r,rr).. TotalTradeCapacity(y,f,r,rr) =l= TotalAnnualMaxTradeCapacity(f,r,rr,y);
equation TRC2d_TotalTradeCapacitySymmetry(YEAR_FULL,FUEL,REGION_FULL,rr_full);
TRC2d_TotalTradeCapacitySymmetry(y,f,r,rr)$(TradeRoute(y,'electricity',r,rr) > 0).. TotalTradeCapacity(y,'electricity',r,rr) =e= TotalTradeCapacity(y,'electricity',rr,r);
*equation TrC3_NewTradeCapacityLimit(YEAR_FULL,FUEL,REGION_FULL,rr_full);
*TrC3_NewTradeCapacityLimit(y,'electricity',r,rr)$(TradeRoute(y,'electricity',r,rr) > 0 and GrowthRateTradeCapacity(y,'electricity',r,rr) > 0).. GrowthRateTradeCapacity(y,'electricity',r,rr)*(TotalTradeCapacity(y-1,'electricity',r,rr)) =g= NewTradeCapacity(y,'electricity',r,rr);
*NewTradeCapacity.fx(y,'electricity',r,rr)$(TradeRoute(y,'electricity',r,rr) = 0 or GrowthRateTradeCapacity(y,'electricity',r,rr) = 0) = 0;

equation TrC4_NewTradeCapacityCosts(YEAR_FULL,FUEL,REGION_FULL,rr_full);
TrC4_NewTradeCapacityCosts(y,'electricity',r,rr)$(TradeRoute(y,'electricity',r,rr) > 0)..  NewTradeCapacity(y,'electricity',r,rr)*TradeCapacityGrowthCosts('electricity',r,rr)*TradeRoute(y,'electricity',r,rr)/2 =e= NewTradeCapacityCosts(y,'electricity',r,rr);
equation TrC5_DiscountedNewTradeCapacityCosts(YEAR_FULL,FUEL,REGION_FULL,rr_full);
TrC5_DiscountedNewTradeCapacityCosts(y,'electricity',r,rr)$(TradeRoute(y,'electricity',r,rr) > 0).. NewTradeCapacityCosts(y,'electricity',r,rr)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedNewTradeCapacityCosts(y,'electricity',r,rr);
DiscountedNewTradeCapacityCosts.fx(y,f,r,rr)$(TradeRoute(y,f,r,rr) = 0 or (not sameAs('electricity',f))) = 0;

*
* ##############* Trading Costs #############
*
equation Tc1_TradeCosts(y_full,REGION_FULL);
Tc1_TradeCosts(y,r)$(sum((f,rr),TradeRoute(y,f,r,rr)) > 0).. sum((l,f,rr)$(TradeRoute(y,f,r,rr)),Import(y,l,f,r,rr) * TradeCosts(f,r,rr)) =e= AnnualTotalTradeCosts(y,r);
AnnualTotalTradeCosts.fx(y,r)$(sum((f,rr),TradeRoute(y,f,r,rr)) = 0) = 0;

equation Tc3_DiscountedAnnualTradeCosts(y_full,REGION_FULL);
Tc3_DiscountedAnnualTradeCosts(y,r)..  AnnualTotalTradeCosts(y,r)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedAnnualTotalTradeCosts(y,r);


*
* ##############* Accounting Technology Production/Use #############
*
equation Acc1_FuelProductionByTechnology(YEAR_FULL,TIMESLICE_FULL,TECHNOLOGY,FUEL,REGION_FULL);
Acc1_FuelProductionByTechnology(y,l,t,f,r)$(sum(m, OutputActivityRatio(r,t,f,m,y)) > 0 and CapacityFactor(r,t,l,y) > 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0 and TotalCapacityAnnual.up(y,t,r) > 0).. RateOfProductionByTechnology(y,l,t,f,r) * YearSplit(l,y) =e= ProductionByTechnology(y,l,t,f,r);
ProductionByTechnology.fx(y,l,t,f,r)$(sum(m, OutputActivityRatio(r,t,f,m,y)) = 0 or CapacityFactor(r,t,l,y) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or TotalCapacityAnnual.up(y,t,r) = 0) = 0;

equation Acc2_FuelUseByTechnology(YEAR_FULL,TIMESLICE_FULL,TECHNOLOGY,FUEL,REGION_FULL);
Acc2_FuelUseByTechnology(y,l,t,f,r)$(sum(m, InputActivityRatio(r,t,f,m,y)) > 0 and CapacityFactor(r,t,l,y) > 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0 and TotalCapacityAnnual.up(y,t,r) > 0).. RateOfUseByTechnology(y,l,t,f,r) * YearSplit(l,y) =e= UseByTechnology(y,l,t,f,r);
UseByTechnology.fx(y,l,t,f,r)$(sum(m, InputActivityRatio(r,t,f,m,y)) = 0 or CapacityFactor(r,t,l,y) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or TotalCapacityAnnual.up(y,t,r) = 0) = 0;

equation Acc3_AverageAnnualRateOfActivity(YEAR_FULL,TECHNOLOGY,MODE_OF_OPERATION,REGION_FULL);
Acc3_AverageAnnualRateOfActivity(y,t,m,r)$(CanBuildTechnology(y,t,r) > 0).. sum(l, RateOfActivity(y,l,t,m,r)*YearSplit(l,y)) =e= TotalAnnualTechnologyActivityByMode(y,t,m,r);
TotalAnnualTechnologyActivityByMode.fx(y,t,m,r)$(CanBuildTechnology(y,t,r) = 0) = 0;

equation Acc4_ModelPeriodCostByRegion(REGION_FULL);
Acc4_ModelPeriodCostByRegion(r)..sum((y), TotalDiscountedCost(y,r)) =e= ModelPeriodCostByRegion(r);




*
* ############### Capital Costs #############
*
equation CC1_UndiscountedCapitalInvestment(YEAR_FULL,TECHNOLOGY,REGION_FULL);
CC1_UndiscountedCapitalInvestment(y,t,r).. CapitalCost(r,t,y) * NewCapacity(y,t,r) =e= CapitalInvestment(y,t,r);
equation CC2_DiscountingCapitalInvestmenta(YEAR_FULL,TECHNOLOGY,REGION_FULL);
CC2_DiscountingCapitalInvestmenta(y,t,r).. CapitalInvestment(y,t,r)/((1+DiscountRate(r))**(YearVal(y)-StartYear)) =e= DiscountedCapitalInvestment(y,t,r);


*
* ############### Investment & Capacity Limits #############
*

$ifthen %switch_investLimit% == 1

*$ontext
equation CC3_InvestmentLimit(YEAR_FULL,REGION_FULL);
CC3_InvestmentLimit(y,r).. sum(t,CapitalInvestment(y,t,r)) =l= InvestmentLimit*sum(yy,sum(t,CapitalInvestment(yy,t,r)));

equation CC4_CapacityLimit(YEAR_FULL,REGION_FULL,TECHNOLOGY);
CC4_CapacityLimit(y,r,Renewables).. NewCapacity(y,Renewables,r) =l= NewRESCapacity*TotalAnnualMaxCapacity(r,Renewables,y);

equation CC5c_NoWayBack(YEAR_FULL,REGION_FULL,TECHNOLOGY,FUEL);
CC5c_NoWayBack(y,r,PhaseInSet,f)$(Yearval(y) > 2016).. ProductionByTechnologyAnnual(y,PhaseInSet,f,r) =g= ProductionByTechnologyAnnual(y-1,PhaseInSet,f,r)*PhaseIn(y);

equation CC5d_NoCoalNoMore(YEAR_FULL,REGION_FULL,TECHNOLOGY,FUEL);
CC5d_NoCoalNoMore(y,r,PhaseOutSet,f)$(Yearval(y) > 2016).. ProductionByTechnologyAnnual(y,PhaseOutSet,f,r) =l= ProductionByTechnologyAnnual(y-1,PhaseOutSet,f,r)*PhaseOut(y);

equation CC5f_PowerStability(YEAR_FULL,REGION_FULL,FUEL);
CC5f_PowerStability(y,r,'electricity')$(Yearval(y) > 2016).. sum(t$(RETagTechnology(r,t,y)=1),ProductionByTechnologyAnnual(y,t,'electricity',r)-ProductionByTechnologyAnnual(y-1,t,'electricity',r)) =l= PowerStability*sum((t),ProductionByTechnologyAnnual(y-1,t,'electricity',r))

equation CC5f_HeatStability(YEAR_FULL,REGION_FULL,FUEL);
CC5f_HeatStability(y,r,HeatFuels)$(Yearval(y) > 2016).. sum(RenewableTransformation,ProductionByTechnologyAnnual(y,RenewableTransformation,HeatFuels,r)-ProductionByTechnologyAnnual(y-1,RenewableTransformation,HeatFuels,r)) =l= PowerStability*sum((t),ProductionByTechnologyAnnual(y-1,t,HeatFuels,r))

$ifthen %switch_ccs% == 1
equation CC5g_CCSAddition(YEAR_FULL,REGION_FULL,FUEL);
CC5g_CCSAddition(y,r,f)$(Yearval(y) > 2016).. sum(CCS,ProductionByTechnologyAnnual(y,CCS,f,r)-ProductionByTechnologyAnnual(y-1,CCS,f,r)) =l= (PowerStability+0.05)*sum((t),ProductionByTechnologyAnnual(y-1,t,f,r))
$endif

equation CC5h_StorageStability(YEAR_FULL,REGION_FULL,FUEL);
CC5h_StorageStability(y,r,f)$(Yearval(y) > 2016).. sum(StorageDummies,ProductionByTechnologyAnnual(y,StorageDummies,f,r)-ProductionByTechnologyAnnual(y-1,StorageDummies,f,r)) =l= (PowerStability+0.075)*sum((t),ProductionByTechnologyAnnual(y-1,t,f,r))

$endif
*$offtext

*
* ##############* Salvage Value #############
*
equation SV1_SalvageValueAtEndOfPeriod1(YEAR_FULL,TECHNOLOGY,REGION_FULL);
SV1_SalvageValueAtEndOfPeriod1(y,t,r)$(DepreciationMethod(r)=1 and ((YearVal(y) + OperationalLife(r,t)-1 > smax(yy, YearVal(yy))) and (DiscountRate(r) > 0)))..
SalvageValue(y,t,r) =e= CapitalCost(r,t,y)*NewCapacity(y,t,r)*(1-(((1+DiscountRate(r))**(smax(yy, YearVal(yy)) - YearVal(y)+1) -1)
/((1+DiscountRate(r))**OperationalLife(r,t)-1)));
equation SV2_SalvageValueAtEndOfPeriod2(YEAR_FULL,TECHNOLOGY,REGION_FULL);
SV2_SalvageValueAtEndOfPeriod2(y,t,r)$((((YearVal(y) + OperationalLife(r,t)-1 > smax(yy, YearVal(yy))) and (DiscountRate(r) = 0)) or (DepreciationMethod(r)=2 and (YearVal(y) + OperationalLife(r,t)-1 > smax(yy, YearVal(yy))))))..
SalvageValue(y,t,r) =e= CapitalCost(r,t,y)*NewCapacity(y,t,r)*(1-smax(yy, YearVal(yy))- YearVal(y)+1)/OperationalLife(r,t);
equation SV3_SalvageValueAtEndOfPeriod3(YEAR_FULL,TECHNOLOGY,REGION_FULL);
SV3_SalvageValueAtEndOfPeriod3(y,t,r)$(YearVal(y) + OperationalLife(r,t)-1 <= smax(yy, YearVal(yy)))..
SalvageValue(y,t,r) =e= 0;
equation SV4_SalvageValueDiscToStartYr(YEAR_FULL,TECHNOLOGY,REGION_FULL);
SV4_SalvageValueDiscToStartYr(y,t,r)..
DiscountedSalvageValue(y,t,r) =e= SalvageValue(y,t,r)/((1+DiscountRate(r))**(1+smax(yy, YearVal(yy)) - smin(yy, YearVal(yy))));

*
* ############### Operating Costs #############
*
equation OC1_OperatingCostsVariable(YEAR_FULL,TECHNOLOGY,REGION_FULL);
OC1_OperatingCostsVariable(y,t,r)$(sum(m,VariableCost(r,t,m,y) > 0) and CanBuildTechnology(y,t,r) > 0).. sum(m, (TotalAnnualTechnologyActivityByMode(y,t,m,r)*VariableCost(r,t,m,y))) =e= AnnualVariableOperatingCost(y,t,r);
AnnualVariableOperatingCost.fx(y,t,r)$(CanBuildTechnology(y,t,r) = 0) = 0;

equation OC2_OperatingCostsFixedAnnual(YEAR_FULL,TECHNOLOGY,REGION_FULL);
OC2_OperatingCostsFixedAnnual(y,t,r)$(FixedCost(r,t,y) > 0 and CanBuildTechnology(y,t,r) > 0).. sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)), TotalCapacityAnnual(yy,t,r)*FixedCost(r,t,yy)) =e= AnnualFixedOperatingCost(y,t,r);
AnnualFixedOperatingCost.fx(y,t,r)$(CanBuildTechnology(y,t,r) = 0) = 0;

equation OC3_OperatingCostsTotalAnnual(YEAR_FULL,TECHNOLOGY,REGION_FULL);
OC3_OperatingCostsTotalAnnual(y,t,r)$(AnnualVariableOperatingCost.up(y,t,r) > 0 and AnnualFixedOperatingCost.up(y,t,r)  > 0).. AnnualFixedOperatingCost(y,t,r) + AnnualVariableOperatingCost(y,t,r) =e= OperatingCost(y,t,r);
OperatingCost.fx(y,t,r)$(AnnualVariableOperatingCost.up(y,t,r) = 0 and AnnualFixedOperatingCost.up(y,t,r)  = 0) = 0;

equation OC4_DiscountedOperatingCostsTotalAnnual(YEAR_FULL,TECHNOLOGY,REGION_FULL);
*OC4_DiscountedOperatingCostsTotalAnnual(y,t,r)$(OperatingCost.up(y,t,r) > 0).. OperatingCost(y,t,r)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedOperatingCost(y,t,r);
OC4_DiscountedOperatingCostsTotalAnnual(y,t,r)$(OperatingCost.up(y,t,r) > 0).. OperatingCost(y,t,r)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy)))) =e= DiscountedOperatingCost(y,t,r);
DiscountedOperatingCost.fx(y,t,r)$(OperatingCost.up(y,t,r) = 0) = 0;


*
* ############### Total Discounted Costs #############
*
equation TDC1_TotalDiscountedCostByTechnology(YEAR_FULL,TECHNOLOGY,REGION_FULL);
TDC1_TotalDiscountedCostByTechnology(y,t,r).. DiscountedOperatingCost(y,t,r)+DiscountedCapitalInvestment(y,t,r)+DiscountedTechnologyEmissionsPenalty(y,t,r)-DiscountedSalvageValue(y,t,r)
$ifthen %switch_ramping% == 1
+DiscountedAnnualProductionChangeCost(y,t,r)
$endif
=e= TotalDiscountedCostByTechnology(y,t,r);


equation TDC2_TotalDiscountedCost(YEAR_FULL,REGION_FULL);
TDC2_TotalDiscountedCost(y,r).. sum(t,TotalDiscountedCostByTechnology(y,t,r))+sum(s,TotalDiscountedStorageCost(s,y,r)) =e= TotalDiscountedCost(y,r);


*
* ############### Total Capacity Constraints ##############
*
equation TCC1_TotalAnnualMaxCapacityConstraint(YEAR_FULL,TECHNOLOGY,REGION_FULL);
TCC1_TotalAnnualMaxCapacityConstraint(y,t,r)$(TotalAnnualMaxCapacity(r,t,y) < 999999 and TotalAnnualMaxCapacity(r,t,y) > 0).. TotalCapacityAnnual(y,t,r) =l= TotalAnnualMaxCapacity(r,t,y);
TotalCapacityAnnual.fx(y,t,r)$(TotalAnnualMaxCapacity(r,t,y) = 0) = 0;

equation TCC2_TotalAnnualMinCapacityConstraint(YEAR_FULL,TECHNOLOGY,REGION_FULL);
TCC2_TotalAnnualMinCapacityConstraint(y,t,r)$(TotalAnnualMinCapacity(r,t,y)>0).. TotalCapacityAnnual(y,t,r) =g= TotalAnnualMinCapacity(r,t,y);


*
* ############### New Capacity Constraints ##############
*
equation NCC1_TotalAnnualMaxNewCapacityConstraint(YEAR_FULL,TECHNOLOGY,REGION_FULL);
NCC1_TotalAnnualMaxNewCapacityConstraint(y,t,r)$(TotalAnnualMaxCapacityInvestment(r,t,y) < 999999).. NewCapacity(y,t,r) =l= TotalAnnualMaxCapacityInvestment(r,t,y);
equation NCC2_TotalAnnualMinNewCapacityConstraint(YEAR_FULL,TECHNOLOGY,REGION_FULL);
NCC2_TotalAnnualMinNewCapacityConstraint(y,t,r)$(TotalAnnualMinCapacityInvestment(r,t,y) > 0).. NewCapacity(y,t,r) =g= TotalAnnualMinCapacityInvestment(r,t,y);

*
* ################ Annual Activity Constraints ##############
*

equation AAC1_TotalAnnualTechnologyActivity(YEAR_FULL,TECHNOLOGY,REGION_FULL);
AAC1_TotalAnnualTechnologyActivity(y,t,r).. sum(f,ProductionByTechnologyAnnual(y,t,f,r)) =e= TotalTechnologyAnnualActivity(y,t,r);
*TotalTechnologyAnnualActivity.fx(y,t,r)$(CanBuildTechnology(y,t,r) = 0 or sum(f,ProductionByTechnologyAnnual.up(y,t,f,r)) = 0) = 0;

equation AAC2_TotalAnnualTechnologyActivityUpperLimit(YEAR_FULL,TECHNOLOGY,REGION_FULL);
AAC2_TotalAnnualTechnologyActivityUpperLimit(y,t,r)$(TotalTechnologyAnnualActivityUpperLimit(r,t,y) < 999999).. TotalTechnologyAnnualActivity(y,t,r) =l= TotalTechnologyAnnualActivityUpperLimit(r,t,y);


equation AAC3_TotalAnnualTechnologyActivityLowerLimit(YEAR_FULL,TECHNOLOGY,REGION_FULL);
AAC3_TotalAnnualTechnologyActivityLowerLimit(y,t,r)$(TotalTechnologyAnnualActivityLowerLimit(r,t,y) > 0).. TotalTechnologyAnnualActivity(y,t,r) =g= TotalTechnologyAnnualActivityLowerLimit(r,t,y);
*$ontext
*
* ################ Total Activity Constraints ##############
*
equation TAC1_TotalModelHorizenTechnologyActivity(TECHNOLOGY,REGION_FULL);
TAC1_TotalModelHorizenTechnologyActivity(t,r)$(sum(y,CanBuildTechnology(y,t,r) > 0)).. sum(y, TotalTechnologyAnnualActivity(y,t,r)) =e= TotalTechnologyModelPeriodActivity(t,r);
TotalTechnologyModelPeriodActivity.fx(t,r)$(sum(y,CanBuildTechnology(y,t,r) = 0)) = 0;

equation TAC2_TotalModelHorizenTechnologyActivityUpperLimit(YEAR_FULL,TECHNOLOGY,REGION_FULL);
TAC2_TotalModelHorizenTechnologyActivityUpperLimit(y,t,r)$(TotalTechnologyModelPeriodActivityUpperLimit(r,t) < 999999).. TotalTechnologyModelPeriodActivity(t,r) =l= TotalTechnologyModelPeriodActivityUpperLimit(r,t);


equation TAC3_TotalModelHorizenTechnologyActivityLowerLimit(YEAR_FULL,TECHNOLOGY,REGION_FULL);
TAC3_TotalModelHorizenTechnologyActivityLowerLimit(y,t,r)$(TotalTechnologyModelPeriodActivityLowerLimit(r,t) > 0).. TotalTechnologyModelPeriodActivity(t,r) =g= TotalTechnologyModelPeriodActivityLowerLimit(r,t);

*
* ############### Reserve Margin Constraint #############* NTS: Should change demand for production
*
$ifthen %switch_dispatch% == 0

equation RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(YEAR_FULL,TIMESLICE_FULL,REGION_FULL);
RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(y,l,r).. sum ((t,f), (ProductionByTechnology(y,l,t,f,r) *ReserveMarginTagTechnology(r,t,y) * ReserveMarginTagFuel(r,f,y))) =e= TotalActivityInReserveMargin(r,y,l);
equation RM2_ReserveMargin_FuelsIncluded(YEAR_FULL,TIMESLICE_FULL,REGION_FULL);
RM2_ReserveMargin_FuelsIncluded(y,l,r).. sum (f, (RateOfProduction(y,l,f,r) * YearSplit(l,y) * ReserveMarginTagFuel(r,f,y))) =e= DemandNeedingReserveMargin(y,l,r);
equation RM3_ReserveMargin_Constraint(YEAR_FULL,TIMESLICE_FULL,REGION_FULL);
RM3_ReserveMargin_Constraint(y,l,r)$(ReserveMargin(r,y) > 0).. DemandNeedingReserveMargin(y,l,r) * ReserveMargin(r,y) =l= TotalActivityInReserveMargin(r,y,l);

$endif
*
* ############### RE Production Target #############* NTS: Should change demand for production
*

equation RE1_FuelProductionByTechnologyAnnual(YEAR_FULL,TECHNOLOGY,FUEL,REGION_FULL);
RE1_FuelProductionByTechnologyAnnual(y,t,f,r)$(sum(m, OutputActivityRatio(r,t,f,m,y)) > 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0 and TotalCapacityAnnual.up(y,t,r) > 0).. sum(l, ProductionByTechnology(y,l,t,f,r)) =e= ProductionByTechnologyAnnual(y,t,f,r);
ProductionByTechnologyAnnual.fx(y,t,f,r)$(sum(m, OutputActivityRatio(r,t,f,m,y)) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or TotalCapacityAnnual.up(y,t,r) = 0) = 0;


equation RE2_TechIncluded(YEAR_FULL,REGION_FULL,FUEL);
RE2_TechIncluded(y,r,f).. sum(t$(RETagTechnology(r,t,y) and not StorageDummies(t)),ProductionByTechnologyAnnual(y,t,f,r)) - CurtailmentAnnual(y,f,r) =e= TotalREProductionAnnual(y,r,f);

equation RE4_EnergyConstraint(YEAR_FULL,FUEL);
RE4_EnergyConstraint(y,f).. sum(r,REMinProductionTarget(r,f,y)*(ProductionAnnual(y,f,r)-sum(StorageDummies,ProductionByTechnologyAnnual(y,StorageDummies,f,r))-CurtailmentAnnual(y,f,r))*RETagFuel(r,f,y)) =l= sum(r,TotalREProductionAnnual(y,r,f));

equation RE5_FuelUseByTechnologyAnnual(YEAR_FULL,TECHNOLOGY,FUEL,REGION_FULL);
RE5_FuelUseByTechnologyAnnual(y,t,f,r)$(sum(m, InputActivityRatio(r,t,f,m,y)) > 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0 and TotalCapacityAnnual.up(y,t,r) > 0).. sum(l, (RateOfUseByTechnology(y,l,t,f,r)*YearSplit(l,y))) =e= UseByTechnologyAnnual(y,t,f,r);
UseByTechnologyAnnual.fx(y,t,f,r)$(sum(m, InputActivityRatio(r,t,f,m,y)) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or TotalCapacityAnnual.up(y,t,r) = 0) = 0;

*equation RE6_RETargetPath(YEAR_FULL,REGION_FULL,FUEL);
*RE6_RETargetPath(y,r,f)$(YearVal(y)>2020).. TotalREProductionAnnual(y,r,f) =g= TotalREProductionAnnual(y-1,r,f);




*
* ################ Emissions Accounting ##############
*
equation E1_AnnualEmissionProductionByMode(YEAR_FULL,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,REGION_FULL);
E1_AnnualEmissionProductionByMode(y,t,e,m,r)$(CanBuildTechnology(y,t,r) > 0).. EmissionActivityRatio(r,t,e,m,y)*sum(f,(TotalAnnualTechnologyActivityByMode(y,t,m,r)*EmissionContentPerFuel(f,e)*InputActivityRatio(r,t,f,m,y))) =e= AnnualTechnologyEmissionByMode(y,t,e,m,r);
AnnualTechnologyEmissionByMode.fx(y,t,e,m,r)$(CanBuildTechnology(y,t,r) = 0) = 0;

equation E2_AnnualEmissionProduction(YEAR_FULL,TECHNOLOGY,EMISSION,REGION_FULL);
E2_AnnualEmissionProduction(y,t,e,r).. sum(m, AnnualTechnologyEmissionByMode(y,t,e,m,r)) =e= AnnualTechnologyEmission(y,t,e,r);
*AnnualTechnologyEmission.fx(y,t,e,r)$(AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0 or TotalCapacityAnnual.up(y,t,r) = 0) = 0;

equation E3_EmissionsPenaltyByTechAndEmission(YEAR_FULL,TECHNOLOGY,EMISSION,REGION_FULL);
E3_EmissionsPenaltyByTechAndEmission(y,t,e,r).. AnnualTechnologyEmission(y,t,e,r)*EmissionsPenalty(r,e,y)*EmissionsPenaltyTagTechnology(r,t,e,y) =e= AnnualTechnologyEmissionPenaltyByEmission(y,t,e,r);
equation E4_EmissionsPenaltyByTechnology(YEAR_FULL,TECHNOLOGY,REGION_FULL);
E4_EmissionsPenaltyByTechnology(y,t,r).. sum(e, AnnualTechnologyEmissionPenaltyByEmission(y,t,e,r)) =e= AnnualTechnologyEmissionsPenalty(y,t,r);
equation E5_DiscountedEmissionsPenaltyByTechnology(YEAR_FULL,TECHNOLOGY,REGION_FULL);
E5_DiscountedEmissionsPenaltyByTechnology(y,t,r).. AnnualTechnologyEmissionsPenalty(y,t,r)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedTechnologyEmissionsPenalty(y,t,r);
equation E6_EmissionsAccounting1(YEAR_FULL,EMISSION,REGION_FULL);
E6_EmissionsAccounting1(y,e,r).. sum(t, AnnualTechnologyEmission(y,t,e,r)) =e= AnnualEmissions(y,e,r);
equation E7_EmissionsAccounting2(EMISSION,REGION_FULL);
E7_EmissionsAccounting2(e,r).. sum(y, AnnualEmissions(y,e,r)) =e= ModelPeriodEmissions(e,r)- ModelPeriodExogenousEmission(r,e);
equation E8_RegionalAnnualEmissionsLimit(YEAR_FULL,EMISSION,REGION_FULL);
E8_RegionalAnnualEmissionsLimit(y,e,r).. AnnualEmissions(y,e,r)+AnnualExogenousEmission(r,e,y) =l= RegionalAnnualEmissionLimit(r,e,y);
equation E9_AnnualEmissionsLimit(YEAR_FULL,EMISSION);
E9_AnnualEmissionsLimit(y,e).. sum(r,AnnualEmissions(y,e,r)+AnnualExogenousEmission(r,e,y)) =l= AnnualEmissionLimit(e,y);
equation E10_ModelPeriodEmissionsLimit(EMISSION);
E10_ModelPeriodEmissionsLimit(e).. sum(r,ModelPeriodEmissions(e,r)) =l= ModelPeriodEmissionLimit(e);
equation E11_RegionalModelPeriodEmissionsLimit(EMISSION,REGION_FULL);
E11_RegionalModelPeriodEmissionsLimit(e,r)$(RegionalModelPeriodEmissionLimit(e,r) < 999999).. ModelPeriodEmissions(e,r) =l= RegionalModelPeriodEmissionLimit(e,r);

positive variable  NumberOfStorageUnits(REGION_FULL,YEAR_FULL,STORAGE);


*
* ######### Short-Term Storage Constraints #############
*
$ifthen %switch_short_term_storage% == 1

equation S1_StorageLevelYearStart(REGION_FULL, STORAGE, YEAR_FULL);
S1_StorageLevelYearStart(r,s,y)$(ord(y) > 1)..  StorageLevelYearStart(s,y-1,r) +
sum(l, (sum((t,m)$(TechnologyToStorage(y,m,t,s)>0), RateOfActivity(y,l,t,m,r) * TechnologyToStorage(y,m,t,s))
      - sum((t,m)$(TechnologyFromStorage(y,m,t,s)>0), RateOfActivity(y,l,t,m,r) * TechnologyFromStorage(y,m,t,s))) * YearSplit(l,y))
=e= StorageLevelYearStart(s,y,r);
StorageLevelYearStart.fx(s,y,r)$(ord(y) = 1) = StorageLevelStart(r,s);
StorageLevelYearStart.fx(s,y,r)$(ord(y) > 1) = 0;

equation S2_StorageLevelTSStart(REGION_FULL, STORAGE, YEAR_FULL, TIMESLICE_FULL);
S2_StorageLevelTSStart(r,s,y, l)..  (StorageLevelTSStart(s,y,l-1,r) +
      (sum((t,m)$(TechnologyToStorage(y,m,t,s)>0), RateOfActivity(y,l-1,t,m,r) * TechnologyToStorage(y,m,t,s))
     - sum((t,m)$(TechnologyFromStorage(y,m,t,s)>0), RateOfActivity(y,l-1,t,m,r) / TechnologyFromStorage(y,m,t,s))) * YearSplit(l-1,y))$(ord(l) > 1)
     + (StorageLevelYearStart(s,y,r))$(ord(l) = 1)
=e= StorageLevelTSStart(s,y,l,r);

equation S3_StorageRefilling(REGION_FULL, STORAGE);
S3_StorageRefilling(r,s)..
sum((y,l), (sum((t,m)$(TechnologyToStorage(y,m,t,s)>0), RateOfActivity(y,l,t,m,r) * TechnologyToStorage(y,m,t,s))
          - sum((t,m)$(TechnologyFromStorage(y,m,t,s)>0), RateOfActivity(y,l,t,m,r) / TechnologyFromStorage(y,m,t,s)))) =e= 0;


equation SC1_LowerLimit(STORAGE,YEAR_FULL,TIMESLICE_FULL,REGION_FULL);
SC1_LowerLimit(s,y,l,r)$(MinStorageCharge(r,s,y) > 0)..
MinStorageCharge(r,s,y)*sum(yy$(yearval(y)-yearval(yy) < OperationalLifeStorage(r,s,yy) and yearval(y)-yearval(yy) >= 0), NewStorageCapacity(s,y,r) + ResidualStorageCapacity(r,s,y))
=l= StorageLevelTSStart(s,y,l,r);

equation SC2_UpperLimit(STORAGE,YEAR_FULL,TIMESLICE_FULL,REGION_FULL);
SC2_UpperLimit(s,y,l,r)..
sum(yy$(yearval(y)-yearval(yy) < OperationalLifeStorage(r,s,yy) and yearval(y)-yearval(yy) >= 0), NewStorageCapacity(s,y,r) + ResidualStorageCapacity(r,s,y))
=g= StorageLevelTSStart(s,y,l,r);

* ### currently no max limit
*equation SC7_StorageMaxUpperLimit(STORAGE,YEAR_FULL,TIMESLICE_FULL,REGION_FULL);
*SC7_StorageMaxUpperLimit(s,y,l,r)..
*sum(yy$(yearval(y)-yearval(yy) < OperationalLifeStorage(r,s,yy) and yearval(y)-yearval(yy) >= 0), NewStorageCapacity(s,y,r) + ResidualStorageCapacity(r,s,y))
*=l= StorageMaxCapacity(r,s,y);

equation SC9b_StorageChargeRateIn(STORAGE,YEAR_FULL,TIMESLICE_FULL,REGION_FULL,MODE_OF_OPERATION);
SC9b_StorageChargeRateIn(s,y,l,r,m)..
sum((t)$(TechnologyToStorage(y,m,t,s)>0), RateOfActivity(y,l,t,m,r) * TechnologyToStorage(y,m,t,s))
=l= StorageMaxChargeRate(r,s)*sum((t)$(TechnologyToStorage(y,m,t,s)>0),TotalCapacityAnnual(y,t,r)*CapacityToActivityUnit(r,t));

equation SC9c_StorageChargeRateOut(STORAGE,YEAR_FULL,TIMESLICE_FULL,REGION_FULL,MODE_OF_OPERATION);
SC9c_StorageChargeRateOut(s,y,l,r,m)..
sum((t)$(TechnologyFromStorage(y,m,t,s)>0), RateOfActivity(y,l,t,m,r) * TechnologyFromStorage(y,m,t,s))
=l= StorageMaxDischargeRate(r,s)*sum((t)$(TechnologyFromStorage(y,m,t,s)>0),TotalCapacityAnnual(y,t,r)*CapacityToActivityUnit(r,t));


equation SC9d_StorageActivityLimit(STORAGE,TECHNOLOGY,YEAR_FULL,TIMESLICE_FULL,REGION_FULL,MODE_OF_OPERATION);
SC9d_StorageActivityLimit(s,t,y,l,r,m)$(TechnologyFromStorage(y,m,t,s)>0)..
RateOfActivity(y,l,t,m,r)/TechnologyFromStorage(y,m,t,s)*YearSplit(l,y) =l= StorageLevelTSStart(s,y,l,r);


equation SI4_UndiscountedCapitalInvestmentStorage(STORAGE,YEAR_FULL,REGION_FULL);
SI4_UndiscountedCapitalInvestmentStorage(s,y,r).. CapitalCostStorage(r,s,y) * NewStorageCapacity(s,y,r) =e= CapitalInvestmentStorage(s,y,r);
equation SI5_DiscountingCapitalInvestmentStorage(STORAGE,YEAR_FULL,REGION_FULL);
SI5_DiscountingCapitalInvestmentStorage(s,y,r)..  CapitalInvestmentStorage(s,y,r)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedCapitalInvestmentStorage(s,y,r);
equation SI6_SalvageValueStorageAtEndOfPeriod1(STORAGE,YEAR_FULL,REGION_FULL);
SI6_SalvageValueStorageAtEndOfPeriod1(s,y,r)$((yearval(y)+OperationalLifeStorage(r,s,y)-1) le sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) )..    0 =e= SalvageValueStorage(s,y,r);
equation SI7_SalvageValueStorageAtEndOfPeriod2(STORAGE,YEAR_FULL,REGION_FULL);
SI7_SalvageValueStorageAtEndOfPeriod2(s,y,r)$((DepreciationMethod(r)=1 and (yearval(y)+OperationalLifeStorage(r,s,y)-1) > sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) and DiscountRate(r)=0) or (DepreciationMethod(r)=2 and (yearval(y)+OperationalLifeStorage(r,s,y)-1) > sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) and DiscountRate(r)=0)).. CapitalInvestmentStorage(s,y,r)*(1- sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full))  - yearval(y)+1)/OperationalLifeStorage(r,s,y) =e= SalvageValueStorage(s,y,r);
equation SI8_SalvageValueStorageAtEndOfPeriod3(STORAGE,YEAR_FULL,REGION_FULL);
SI8_SalvageValueStorageAtEndOfPeriod3(s,y,r)$(DepreciationMethod(r)=1 and ((yearval(y)+OperationalLifeStorage(r,s,y)-1) > sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) and DiscountRate(r)>0)).. CapitalInvestmentStorage(s,y,r)*(1-(((1+DiscountRate(r))**(sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) - yearval(y)+1)-1)/((1+DiscountRate(r))**OperationalLifeStorage(r,s,y)-1))) =e= SalvageValueStorage(s,y,r);
equation SI9_SalvageValueStorageDiscountedToStartYear(STORAGE,YEAR_FULL,REGION_FULL);
SI9_SalvageValueStorageDiscountedToStartYear(s,y,r).. SalvageValueStorage(s,y,r)/((1+DiscountRate(r))**(1+smax(yy, YearVal(yy)) - smin(yy, YearVal(yy)))) =e= DiscountedSalvageValueStorage(s,y,r);
equation SI10_TotalDiscountedCostByStorage(STORAGE,YEAR_FULL,REGION_FULL);
SI10_TotalDiscountedCostByStorage(s,y,r).. DiscountedCapitalInvestmentStorage(s,y,r)-DiscountedSalvageValueStorage(s,y,r) =e= TotalDiscountedStorageCost(s,y,r);

$else

*
* ######### Storage Constraints #############
*
equation SC1_LowerLimit(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC1_LowerLimit(s,y,ls,ld,lh,r).. 0 =l= (StorageLevelDayTypeStart(s,y,ls,ld,r)+sum(lhlh$(ord(lh)-ord(lhlh) > 0),NetChargeWithinDay(s,y,ls,ld,lhlh,r)))-StorageLowerLimit(s,y,r);
equation SC1_UpperLimit(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC1_UpperLimit(s,y,ls,ld,lh,r).. (StorageLevelDayTypeStart(s,y,ls,ld,r)+sum(lhlh$(ord(lh)-ord(lhlh) > 0),NetChargeWithinDay(s,y,ls,ld,lhlh,r)))-StorageUpperLimit(s,y,r) =l= 0;
equation SC2_LowerLimit(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC2_LowerLimit(s,y,ls,ld,lh,r).. 0 =l= (StorageLevelDayTypeStart(s,y,ls,ld,r)-sum(lhlh$(ord(lh)-ord(lhlh) < 0), NetChargeWithinDay(s,y,ls,ld-1,lhlh,r) ))$(ord(ld) > 1)-StorageLowerLimit(s,y,r);
equation SC2_UpperLimit(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC2_UpperLimit(s,y,ls,ld,lh,r).. (StorageLevelDayTypeStart(s,y,ls,ld,r)-sum(lhlh$(ord(lh)-ord(lhlh) < 0), NetChargeWithinDay(s,y,ls,ld-1,lhlh,r) ))$(ord(ld) > 1) -StorageUpperLimit(s,y,r) =l= 0;
equation SC3_LowerLimit(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC3_LowerLimit(s,y,ls,ld,lh,r)..  0 =l= (StorageLevelDayTypeFinish(s,y,ls,ld,r) - sum(lhlh$(ord(lh)-ord(lhlh) <0), NetChargeWithinDay(s,y,ls,ld,lhlh,r)))-StorageLowerLimit(s,y,r);
equation SC3_UpperLimit(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC3_UpperLimit(s,y,ls,ld,lh,r).. (StorageLevelDayTypeFinish(s,y,ls,ld,r) - sum(lhlh$(ord(lh)-ord(lhlh) <0), NetChargeWithinDay(s,y,ls,ld,lhlh,r)) )-StorageUpperLimit(s,y,r) =l= 0;
equation SC4_LowerLimit(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC4_LowerLimit(s,y,ls,ld,lh,r).. 0 =L= (StorageLevelDayTypeFinish(s,y,ls,ld-1,r)+sum(lhlh$(ord(lh)-ord(lhlh) >0), NetChargeWithinDay(s,y,ls,ld,lhlh,r) ))$(ord(ld) > 1) -StorageLowerLimit(s,y,r);
equation SC4_UpperLimit(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC4_UpperLimit(s,y,ls,ld,lh,r).. (StorageLevelDayTypeFinish(s,y,ls,ld-1,r)+sum(lhlh$(ord(lh)-ord(lhlh) >0), NetChargeWithinDay(s,y,ls,ld,lhlh,r) ))$(ord(ld) > 1) -StorageUpperLimit(s,y,r) =l= 0;
equation SC5_MaxChargeConstraint(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC5_MaxChargeConstraint(s,y,ls,ld,lh,r).. RateOfStorageCharge(s,y,ls,ld,lh,r) =l= StorageMaxChargeRate(r,s)*StorageUpperLimit(s,y,r);
equation SC6_MaxDischargeConstraint(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
SC6_MaxDischargeConstraint(s,y,ls,ld,lh,r).. RateOfStorageDischarge(s,y,ls,ld,lh,r) =l= StorageMaxDischargeRate(r,s)*StorageUpperLimit(s,y,r);

*
* ######### Storage Investments #############
*
equation SI1_StorageUpperLimit(STORAGE,YEAR_FULL,REGION_FULL);
SI1_StorageUpperLimit(s,y,r).. AccumulatedNewStorageCapacity(s,y,r)+ResidualStorageCapacity(r,s,y) =e= StorageUpperLimit(s,y,r);
equation SI2_StorageLowerLimit(STORAGE,YEAR_FULL,REGION_FULL);
SI2_StorageLowerLimit(s,y,r).. MinStorageCharge(r,s,y)*StorageUpperLimit(s,y,r) =e= StorageLowerLimit(s,y,r);
equation SI3_TotalNewStorage(STORAGE,YEAR_FULL,REGION_FULL);
SI3_TotalNewStorage(s,y,r)..  sum(yy$(yearval(y)-yearval(yy) < OperationalLifeStorage(r,s,yy) and yearval(y)-yearval(yy) >= 0), NewStorageCapacity(s,yy,r) ) =e= AccumulatedNewStorageCapacity(s,y,r);
equation SI4_UndiscountedCapitalInvestmentStorage(STORAGE,YEAR_FULL,REGION_FULL);
SI4_UndiscountedCapitalInvestmentStorage(s,y,r).. CapitalCostStorage(r,s,y) * NewStorageCapacity(s,y,r) =e= CapitalInvestmentStorage(s,y,r);
equation SI5_DiscountingCapitalInvestmentStorage(STORAGE,YEAR_FULL,REGION_FULL);
SI5_DiscountingCapitalInvestmentStorage(s,y,r)..  CapitalInvestmentStorage(s,y,r)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedCapitalInvestmentStorage(s,y,r);
equation SI6_SalvageValueStorageAtEndOfPeriod1(STORAGE,YEAR_FULL,REGION_FULL);
SI6_SalvageValueStorageAtEndOfPeriod1(s,y,r)$((yearval(y)+OperationalLifeStorage(r,s,y)-1) le sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) )..    0 =e= SalvageValueStorage(s,y,r);
equation SI7_SalvageValueStorageAtEndOfPeriod2(STORAGE,YEAR_FULL,REGION_FULL);
SI7_SalvageValueStorageAtEndOfPeriod2(s,y,r)$((DepreciationMethod(r)=1 and (yearval(y)+OperationalLifeStorage(r,s,y)-1) > sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) and DiscountRate(r)=0) or (DepreciationMethod(r)=2 and (yearval(y)+OperationalLifeStorage(r,s,y)-1) > sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) and DiscountRate(r)=0)).. CapitalInvestmentStorage(s,y,r)*(1- sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full))  - yearval(y)+1)/OperationalLifeStorage(r,s,y) =e= SalvageValueStorage(s,y,r);
equation SI8_SalvageValueStorageAtEndOfPeriod3(STORAGE,YEAR_FULL,REGION_FULL);
SI8_SalvageValueStorageAtEndOfPeriod3(s,y,r)$(DepreciationMethod(r)=1 and ((yearval(y)+OperationalLifeStorage(r,s,y)-1) > sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) and DiscountRate(r)>0)).. CapitalInvestmentStorage(s,y,r)*(1-(((1+DiscountRate(r))**(sum(yy_full$(ord(yy_full)=card(yy_full)),yearval(yy_full)) - yearval(y)+1)-1)/((1+DiscountRate(r))**OperationalLifeStorage(r,s,y)-1))) =e= SalvageValueStorage(s,y,r);
equation SI9_SalvageValueStorageDiscountedToStartYear(STORAGE,YEAR_FULL,REGION_FULL);
SI9_SalvageValueStorageDiscountedToStartYear(s,y,r).. SalvageValueStorage(s,y,r)/((1+DiscountRate(r))**(1+smax(yy, YearVal(yy)) - smin(yy, YearVal(yy)))) =e= DiscountedSalvageValueStorage(s,y,r);
equation SI10_TotalDiscountedCostByStorage(STORAGE,YEAR_FULL,REGION_FULL);
SI10_TotalDiscountedCostByStorage(s,y,r).. DiscountedCapitalInvestmentStorage(s,y,r)-DiscountedSalvageValueStorage(s,y,r) =e= TotalDiscountedStorageCost(s,y,r);

*
* ######### Storage Equations #############
*
StorageLevelYearStart.fx(s,y,r)$(ord(y) = 1) = StorageLevelStart(r,s);

equation S1_RateOfStorageCharge(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
S1_RateOfStorageCharge(s,y,ls,ld,lh,r)..  sum((t, m, l)$(TechnologyToStorage(y,m,t,s)>0), RateOfActivity(y,l,t,m,r) * TechnologyToStorage(y,m,t,s) * Conversionls(l,ls) * Conversionld(l,ld) * Conversionlh(l,lh)) =e= RateOfStorageCharge(s,y,ls,ld,lh,r);
equation S2_RateOfStorageDischarge(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
S2_RateOfStorageDischarge(s,y,ls,ld,lh,r)..  sum((t, m, l)$(TechnologyFromStorage(y,m,t,s)>0),RateOfActivity(y,l,t,m,r) * TechnologyFromStorage(y,m,t,s) * Conversionls(l,ls) * Conversionld(l,ld) * Conversionlh(l,lh)) =e= RateOfStorageDischarge(s,y,ls,ld,lh,r);
equation S3_NetChargeWithinYear(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
S3_NetChargeWithinYear(s,y,ls,ld,lh,r).. sum(l$(Conversionls(l,ls)>0 AND Conversionld(l,ld)>0 AND Conversionlh(l,lh)>0),  (RateOfStorageCharge(s,y,ls,ld,lh,r) - RateOfStorageDischarge(s,y,ls,ld,lh,r)) * YearSplit(l,y) * Conversionls(l,ls) * Conversionld(l,ld) * Conversionlh(l,lh)) =e= NetChargeWithinYear(s,y,ls,ld,lh,r);
equation S4_NetChargeWithinDay(STORAGE,YEAR_FULL,SEASON,DAYTYPE,DAILYTIMEBRACKET,REGION_FULL);
S4_NetChargeWithinDay(s,y,ls,ld,lh,r).. (RateOfStorageCharge(s,y,ls,ld,lh,r) - RateOfStorageDischarge(s,y,ls,ld,lh,r)) * sum(l, DaySplit(y,l) * Conversionls(l,ls) * Conversionld(l,ld) * Conversionlh(l,lh)) =e= NetChargeWithinDay(s,y,ls,ld,lh,r);
equation S5_StorageLeveYearStart(STORAGE,YEAR_FULL,REGION_FULL);
S5_StorageLeveYearStart(s,y,r)$(ord(y) > 1).. StorageLevelYearStart(s,y-1,r) + sum((ls,ld,lh), NetChargeWithinYear(s,y-1,ls,ld,lh,r)) =E= StorageLevelYearStart(s,y,r);
equation S7_StorageLevelYearFinish(STORAGE,YEAR_FULL,REGION_FULL);
S7_StorageLevelYearFinish(s,y,r)$(ord(y) < card(y)).. StorageLevelYearStart(s,y+1,r) =e=  StorageLevelYearFinish(s,y,r);
equation S8_StorageLevelYearFinish(STORAGE,YEAR_FULL,REGION_FULL);
S8_StorageLevelYearFinish(s,y,r)$(ord(y) = card(y)).. StorageLevelYearStart(s,y,r) + sum((ls , ld , lh), NetChargeWithinYear(s,y,ls,ld,lh,r)) =e= StorageLevelYearFinish(s,y,r);
equation S9_StorageLevelSeasonStart(STORAGE,YEAR_FULL,SEASON,REGION_FULL);
S9_StorageLevelSeasonStart(s,y,ls,r)$(ord(ls) = 1)..  StorageLevelSeasonStart(s,y,ls,r) =e= StorageLevelYearStart(s,y,r);
equation S10_StorageLevelSeasonStart(STORAGE,YEAR_FULL,SEASON,REGION_FULL);
S10_StorageLevelSeasonStart(s,y,ls,r)$(ord(ls) > 1)..  StorageLevelSeasonStart(s,y,ls,r) =e= StorageLevelSeasonStart(s,y,ls-1,r) + sum((ld,lh), NetChargeWithinYear(s,y,ls-1,ld,lh,r)) ;
equation S11_StorageLevelDayTypeStart(STORAGE,YEAR_FULL,SEASON,DAYTYPE,REGION_FULL);
S11_StorageLevelDayTypeStart(s,y,ls,ld,r)$(ord(ld) = 1).. StorageLevelSeasonStart(s,y,ls,r) =e=  StorageLevelDayTypeStart(s,y,ls,ld,r);
equation S12_StorageLevelDayTypeStart(STORAGE,YEAR_FULL,SEASON,DAYTYPE,REGION_FULL);
S12_StorageLevelDayTypeStart(s,y,ls,ld,r)$(ord(ld) > 1).. StorageLevelDayTypeStart(s,y,ls,ld-1,r) + sum(lh, NetChargeWithinDay(s,y,ls,ld-1,lh,r) * DaysInDayType(y,ls,ld-1) )  =e=  StorageLevelDayTypeStart(s,y,ls,ld,r);
equation S13_StorageLevelDayTypeFinish(STORAGE,YEAR_FULL,SEASON,DAYTYPE,REGION_FULL);
S13_StorageLevelDayTypeFinish(s,y,ls,ld,r)$(ord(ls)=card(ls) and ord(ld)=card(ld))..  StorageLevelYearFinish(s,y,r) =e= StorageLevelDayTypeFinish(s,y,ls,ld,r);
equation S14_StorageLevelDayTypeFinish(STORAGE,YEAR_FULL,SEASON,DAYTYPE,REGION_FULL);
S14_StorageLevelDayTypeFinish(s,y,ls,ld,r)$(ord(ld)=card(ld) and not ord(ls)=card(ls))..  StorageLevelSeasonStart(s,y,ls+1,r) =e= StorageLevelDayTypeFinish(s,y,ls,ld,r);
equation S15_StorageLevelDayTypeFinish(STORAGE,YEAR_FULL,SEASON,DAYTYPE,REGION_FULL);
S15_StorageLevelDayTypeFinish(s,y,ls,ld,r)$(not ord(ld)=card(ld) and not ord(ls)=card(ls)).. StorageLevelDayTypeFinish(s,y,ls,ld+1,r) - sum(lh,  NetChargeWithinDay(s,y,ls,ld+1,lh,r)  * DaysInDayType(y,ls,ld+1) ) =e= StorageLevelDayTypeFinish(s,y,ls,ld,r);

$endif
*
* ######### Transportation Equations #############
*
$ontext
equation T1a_SpecifiedAnnualDemandByModalSplit(MODALTYPE,REGION_FULL,FUEL,YEAR_FULL);
T1a_SpecifiedAnnualDemandByModalSplit(mt,r,TransportFuels,y)$(SpecifiedAnnualDemand(r,TransportFuels,y) <> 0)..  SpecifiedAnnualDemand(r,TransportFuels,y)*ModalSplitByFuelAndModalType(r,TransportFuels,y,mt) =e= DemandSplitByModalType(mt,r,TransportFuels,y);

equation T2_ProductionOfTechnologyByModalSplit(MODALTYPE,REGION_FULL,FUEL,YEAR_FULL);
T2_ProductionOfTechnologyByModalSplit(mt,r,TransportFuels,y)$(sum((t,m),TagTechnologyToModalType(t,m,mt)) <> 0)..  sum((t,m)$(OutputActivityRatio(r,t,TransportFuels,m,y) <> 0),TagTechnologyToModalType(t,m,mt)*sum(l,RateOfProductionByTechnologyByMode(y,l,t,m,TransportFuels,r)*YearSplit(l,y))) =e= ProductionSplitByModalType(mt,r,TransportFuels,y);

equation T3_ModalSplitBalance(MODALTYPE,REGION_FULL,FUEL,YEAR_FULL);
T3_ModalSplitBalance(mt,r,TransportFuels,y)$(sum((t,m),TagTechnologyToModalType(t,m,mt)) <> 0).. ProductionSplitByModalType(mt,r,TransportFuels,y) =g= DemandSplitByModalType(mt,r,TransportFuels,y);

equation T4_StableModalGroups(MODALTYPE,REGION_FULL,FUEL,YEAR_FULL);
T4_StableModalGroups(ModalGroups,r,TransportFuels,y)$(yearval(y) > 2016 and sum((t,m),TagTechnologyToModalType(t,m,ModalGroups)) <> 0).. ProductionSplitByModalType(ModalGroups,r,TransportFuels,y) =g= ProductionSplitByModalType(ModalGroups,r,TransportFuels,y-1)*0.75;

ProductionSplitByModalType.fx('MT_FRT_SHIP_RE',r,'Mobility_Passenger',y) = 0;
ProductionSplitByModalType.fx('MT_FRT_ROAD_RE',r,'Mobility_Passenger',y) = 0;
ProductionSplitByModalType.fx('MT_FRT_RAIL_RE',r,'Mobility_Passenger',y) = 0;
ProductionSplitByModalType.fx('MT_FRT_SHIP_CONV',r,'Mobility_Passenger',y) = 0;
ProductionSplitByModalType.fx('MT_FRT_ROAD_CONV',r,'Mobility_Passenger',y) = 0;
ProductionSplitByModalType.fx('MT_FRT_RAIL_CONV',r,'Mobility_Passenger',y) = 0;

ProductionSplitByModalType.fx('MT_PSNG_AIR_RE',r,'Mobility_Freight',y) = 0;
ProductionSplitByModalType.fx('MT_PSNG_ROAD_RE',r,'Mobility_Freight',y) = 0;
ProductionSplitByModalType.fx('MT_PSNG_RAIL_RE',r,'Mobility_Freight',y) = 0;
ProductionSplitByModalType.fx('MT_PSNG_AIR_CONV',r,'Mobility_Freight',y) = 0;
ProductionSplitByModalType.fx('MT_PSNG_ROAD_CONV',r,'Mobility_Freight',y) = 0;
ProductionSplitByModalType.fx('MT_PSNG_RAIL_CONV',r,'Mobility_Freight',y) = 0;
$offtext

$ontext

$ifthen %switch_ramping% == 1
*
* ##############* Ramping #############
*
equation R1_ProductionChange(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);
R1_ProductionChange(y,l,f,t,r)$(ord(l) > 1 and TagDispatchableTechnology(t)=1 and (RampingUpFactor(r,t,y) <> 0 or RampingDownFactor(r,t,y) <> 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0)).. ((RateOfProductionByTechnology(y,l,t,f,r)*YearSplit(l,y)) - (RateOfProductionByTechnology(y,l-1,t,f,r)*YearSplit(l-1,y))) =e= ProductionUpChangeInTimeslice(y,l,f,t,r) - ProductionDownChangeInTimeslice(y,l,f,t,r);
equation R2_RampingUpLimit(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);
R2_RampingUpLimit(y,l,f,t,r)$(ord(l) > 1 and TagDispatchableTechnology(t)=1 and RampingUpFactor(r,t,y) <> 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0).. ProductionUpChangeInTimeslice(y,l,f,t,r) =l= TotalCapacityAnnual(y,t,r)*AvailabilityFactor(r,t,y)*CapacityToActivityUnit(r,t)*RampingUpFactor(r,t,y)*YearSplit(l,y);
equation R3_RampingDownLimit(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);
R3_RampingDownLimit(y,l,f,t,r)$(ord(l) > 1 and TagDispatchableTechnology(t)=1 and RampingDownFactor(r,t,y) <> 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0).. ProductionDownChangeInTimeslice(y,l,f,t,r) =l= TotalCapacityAnnual(y,t,r)*AvailabilityFactor(r,t,y)*CapacityToActivityUnit(r,t)*RampingDownFactor(r,t,y)*YearSplit(l,y);

*
* ##############* Ramping Costs #############
*
equation RC1_AnnualProductionChangeCosts(YEAR_FULL,FUEL,TECHNOLOGY,REGION_FULL);
RC1_AnnualProductionChangeCosts(y,f,t,r)$(TagDispatchableTechnology(t)=1 and ProductionChangeCost(r,t,y) <> 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0).. sum(l,(ProductionUpChangeInTimeslice(y,l,f,t,r) + ProductionDownChangeInTimeslice(y,l,f,t,r))*ProductionChangeCost(r,t,y)) =e= AnnualProductionChangeCost(y,t,r);
equation RC2_DiscountedAnnualProductionChangeCost(YEAR_FULL,FUEL,TECHNOLOGY,REGION_FULL);
RC2_DiscountedAnnualProductionChangeCost(y,f,t,r)$(TagDispatchableTechnology(t)=1 and ProductionChangeCost(r,t,y) <> 0 and AvailabilityFactor(r,t,y) > 0 and TotalAnnualMaxCapacity(r,t,y) > 0 and TotalTechnologyModelPeriodActivityUpperLimit(r,t) > 0).. AnnualProductionChangeCost(y,t,r)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedAnnualProductionChangeCost(y,t,r);

DiscountedAnnualProductionChangeCost.fx(y,t,r)$(TagDispatchableTechnology(t) = 0 or sum((m,f), OutputActivityRatio(r,t,f,m,y)) = 0 or ProductionChangeCost(r,t,y) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0) = 0;
AnnualProductionChangeCost.fx(y,t,r)$(TagDispatchableTechnology(t) = 0 or sum((m,f), OutputActivityRatio(r,t,f,m,y)) = 0 or ProductionChangeCost(r,t,y) = 0 or AvailabilityFactor(r,t,y) = 0 or TotalAnnualMaxCapacity(r,t,y) = 0 or TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 0) = 0;

*
* ##############* Min Runing Constraint #############
*
equation MRC1_MinRunningConstraint(YEAR_FULL,TIMESLICE_FULL,FUEL,TECHNOLOGY,REGION_FULL);
MRC1_MinRunningConstraint(y,l,f,t,r)$(MinActiveProductionPerTimeslice(y,l,f,t,r) > 0).. RateOfProductionByTechnology(y,l,t,f,r) =g= TotalCapacityAnnual(y,t,r)*AvailabilityFactor(r,t,y)*CapacityToActivityUnit(r,t)*MinActiveProductionPerTimeslice(y,l,f,t,r);

$endif

*
* ##############* Curtailment Costs #############
*

equation CC1_AnnualCurtailmentCosts(YEAR_FULL,FUEL,REGION_FULL);
CC1_AnnualCurtailmentCosts(y,f,r).. sum((l),Curtailment(y,l,f,r)*CurtailmentCostFactor(r,f,y)) =e= AnnualCurtailmentCost(y,f,r);
equation CC2_DiscountedAnnualCurtailmentCosts(YEAR_FULL,FUEL,REGION_FULL);
CC2_DiscountedAnnualCurtailmentCosts(y,f,r).. AnnualCurtailmentCost(y,f,r)/((1+DiscountRate(r))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedAnnualCurtailmentCost(y,f,r);

$ifthen %switch_base_year_bounds% == 1
*
* ##############* General BaseYear Limits and trajectories #############
*
equation B1_BaseYearProductionLowerBound(t,f);
B1_BaseYearProductionLowerBound(t,f)$(BaseYearProduction(t,f) <> 0).. sum(r,ProductionByTechnologyAnnual('2016',t,f,r)) =g= BaseYearProduction(t,f)*0.98;

equation B2_BaseYearProductionUpperBound(t,f);
B2_BaseYearProductionUpperBound(t,f)$(BaseYearProduction(t,f) <> 0).. sum(r,ProductionByTechnologyAnnual('2016',t,f,r)) =l= BaseYearProduction(t,f)*1.02;

equation B3a_BaseYearHeat_Low_ResidualLimit;
B3a_BaseYearHeat_Low_ResidualLimit.. sum((t,r),Productionbytechnologyannual('2016',t,'Heat_Low_Residential',r)) =l= sum((r),SpecifiedAnnualDemand(r,'Heat_Low_Residential','2016'))*1.05;

equation B3b_BaseYearHeat_Low_IndustrialLimit;
B3b_BaseYearHeat_Low_IndustrialLimit.. sum((t,r),Productionbytechnologyannual('2016',t,'Heat_Low_Industrial',r)) =l= sum((r),SpecifiedAnnualDemand(r,'Heat_Low_Industrial','2016'))*1.05;

equation B3c_BaseYearHeat_Medium_IndustrialLimit;
B3c_BaseYearHeat_Medium_IndustrialLimit.. sum((t,r),Productionbytechnologyannual('2016',t,'Heat_Medium_Industrial',r)) =l= sum((r),SpecifiedAnnualDemand(r,'Heat_Medium_Industrial','2016'))*1.05;

equation B3d_BaseYearHeat_High_IndustrialLimit;
B3d_BaseYearHeat_High_IndustrialLimit.. sum((t,r),Productionbytechnologyannual('2016',t,'Heat_High_Industrial',r)) =l= sum((r),SpecifiedAnnualDemand(r,'Heat_High_Industrial','2016'))*1.05;

*
* ####### limiting 2020 trajectory #############
*

equation B8a_TrajectoryProductionLowerBound(YEAR_FULL,t,f);
B8a_TrajectoryProductionLowerBound(y,t,f)$(sum(r,ResidualCapacity(r,t,'2016')) > 0 and TrajectoryLowerLimit(y) <> 0 and YearVal(y) > 2016).. sum(r,ProductionByTechnologyAnnual(y,t,f,r)) =g= sum(r,ProductionByTechnologyAnnual(y-1,t,f,r))*TrajectoryLowerLimit(y);

equation B8b_TrajectoryProductionUpperBound(YEAR_FULL,t,f);
B8b_TrajectoryProductionUpperBound(y,t,f)$(sum(r,ResidualCapacity(r,t,'2016')) > 0 and TrajectoryUpperLimit(y) <> 0 and YearVal(y) > 2016).. sum(r,ProductionByTechnologyAnnual(y,t,f,r)) =l= sum(r,ProductionByTechnologyAnnual(y-1,t,f,r))*TrajectoryUpperLimit(y);

$endif



$offtext
