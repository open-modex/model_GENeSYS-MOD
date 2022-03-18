* ################### genesysmod_costs.gms ####################
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
* ############################################################




set loadfactor /"0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0"/;
alias (loadfactor,amnt);

parameters
y_loadfactor(amnt) /
"0.1"            0.1
"0.2"            0.2
"0.3"            0.3
"0.4"            0.4
"0.5"            0.5
"0.6"            0.6
"0.7"            0.7
"0.8"            0.8
"0.9"            0.9
"1.0"              1/;

parameters
y_effectiveproductionfactorpertimeslice
y_totalcapacityfactor
y_effectiveproductionfactor
y_fixedcostperGW
y_variablecostperPJ
y_variablecostPOWER
y_realloadfactor
y_technologyshare
y_totalcostPOWER
y_costofpower
y_endogenousfuelcosts
y_levelizedtechnologycosts
y_endogenouslevelizedtechnologycosts
y_endogenousfuelcostspertimeslice
y_levelizedtechnologycostspertimeslice
y_endogenouslevelizedtechnologycostspertimeslice
y_maximaltechnologyproduction
y_fuelcosts
y_maximalyearlytechnologyproduction
z_FuelProducedByCarrier
z_residentialdemandshare
excel_sectors
excel_lvlcosts
z_sectorcouplingpertimeslice
z_sectorcouplingpertimeslice
z_productionprofile
z_sectorcouplingdifference;

** Calculations for levelized technology costs and fuel generation costs based on the actual use and production values of the model

y_endogenousfuelcosts('Hardcoal',y,r)$(ProductionAnnual.l(y,'Hardcoal',r) > 0) = (VariableCost(r,'R_Coal_Hardcoal','1',y)/5 * ProductionByTechnologyAnnual.l(y,'R_Coal_Hardcoal','Hardcoal',r)/ProductionAnnual.l(y,'Hardcoal',r)) + (VariableCost(r,'Z_Import_Hardcoal','1',y)/5 * ProductionByTechnologyAnnual.l(y,'Z_Import_Hardcoal','Hardcoal',r)/ProductionAnnual.l(y,'Hardcoal',r));
y_endogenousfuelcosts('Lignite',y,r) = VariableCost(r,'R_Coal_Lignite','1',y)/5 ;
y_endogenousfuelcosts('Nuclear',y,r) = VariableCost(r,'R_Nuclear','1',y)/5 ;
y_endogenousfuelcosts('Biomass',y,r) = VariableCost(r,'RES_Biomass','1',y)/5 ;
y_endogenousfuelcosts('Gas_Natural',y,r)$(ProductionAnnual.l(y,'Gas_Natural',r) > 0) = (VariableCost(r,'R_Gas','1',y)/5 * ProductionByTechnologyAnnual.l(y,'R_Gas','Gas_Natural',r)/ProductionAnnual.l(y,'Gas_Natural',r)) + (VariableCost(r,'Z_Import_Gas','1',y)/5 * ProductionByTechnologyAnnual.l(y,'Z_Import_Gas','Gas_Natural',r)/ProductionAnnual.l(y,'Gas_Natural',r));
y_fixedcostperGW(y,r,t)$(OperationalLife(r,t) > 1) = (CapitalCost(r,t,y)/(OperationalLife(r,t)-1) + FixedCost(r,t,y)/5);
y_endogenouslevelizedtechnologycosts('Power',m,y,t,r)$(OutputActivityRatio(r,t,'Power',m,y) > 0 AND z_ProductionByTechnologyByModeAnnual(r,t,m,'Power',y) > 0) =  (y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByModeAnnual(r,t,m,'Power',y))) / z_ProductionByTechnologyByModeAnnual(r,t,m,'Power',y);
y_endogenouslevelizedtechnologycosts('Power',m,y,t,r)$(sum(f,InputActivityRatio(r,t,f,m,y) > 0) AND OutputActivityRatio(r,t,'Power',m,y) > 0)  = y_endogenouslevelizedtechnologycosts('Power',m,y,t,r) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Power',m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenousfuelcosts('Power',y,r)$(ProductionAnnual.l(y,'Power',r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycosts('Power',m,y,t,r)*z_ProductionByTechnologyByModeAnnual(r,t,m,'Power',y)/ProductionAnnual.l(y,'Power',r));

y_endogenouslevelizedtechnologycosts('H2',m,y,t,r)$(OutputActivityRatio(r,t,'H2',m,y) > 0 AND z_ProductionByTechnologyByModeAnnual(r,t,m,'H2',y) > 0)  =  (y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByModeAnnual(r,t,m,'H2',y))) / z_ProductionByTechnologyByModeAnnual(r,t,m,'H2',y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'H2',m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenousfuelcosts('H2',y,r)$(ProductionAnnual.l(y,'H2',r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycosts('H2',m,y,t,r)*z_ProductionByTechnologyByModeAnnual(r,t,m,'H2',y)/ProductionAnnual.l(y,'H2',r));

y_endogenouslevelizedtechnologycosts('Gas_Bio',m,y,t,r)$(OutputActivityRatio(r,t,'Gas_Bio',m,y) > 0 AND z_ProductionByTechnologyByModeAnnual(r,t,m,'Gas_Bio',y) > 0)  =  (y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByModeAnnual(r,t,m,'Gas_Bio',y))) / z_ProductionByTechnologyByModeAnnual(r,t,m,'Gas_Bio',y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Gas_Bio',m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenousfuelcosts('Gas_Bio',y,r)$(ProductionAnnual.l(y,'Gas_Bio',r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycosts('Gas_Bio',m,y,t,r)*z_ProductionByTechnologyByModeAnnual(r,t,m,'Gas_Bio',y)/ProductionAnnual.l(y,'Gas_Bio',r));

y_endogenouslevelizedtechnologycosts('Gas_Synth',m,y,t,r)$(OutputActivityRatio(r,t,'Gas_Synth',m,y) > 0 AND z_ProductionByTechnologyByModeAnnual(r,t,m,'Gas_Synth',y) > 0)  =  (y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByModeAnnual(r,t,m,'Gas_Synth',y))) / z_ProductionByTechnologyByModeAnnual(r,t,m,'Gas_Synth',y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Gas_Synth',m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenousfuelcosts('Gas_Synth',y,r)$(ProductionAnnual.l(y,'Gas_Synth',r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycosts('Gas_Synth',m,y,t,r)*z_ProductionByTechnologyByModeAnnual(r,t,m,'Gas_Synth',y)/ProductionAnnual.l(y,'Gas_Synth',r));

y_endogenouslevelizedtechnologycosts(HeatFuels,m,y,t,r)$(OutputActivityRatio(r,t,HeatFuels,m,y) > 0 AND z_ProductionByTechnologyByModeAnnual(r,t,m,HeatFuels,y) > 0)  =  (y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByModeAnnual(r,t,m,HeatFuels,y))) / z_ProductionByTechnologyByModeAnnual(r,t,m,HeatFuels,y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,HeatFuels,m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenousfuelcosts(HeatFuels,y,r)$(ProductionAnnual.l(y,HeatFuels,r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycosts(HeatFuels,m,y,t,r)*z_ProductionByTechnologyByModeAnnual(r,t,m,HeatFuels,y)/ProductionAnnual.l(y,HeatFuels,r));

y_endogenouslevelizedtechnologycosts(TransportFuels,m,y,t,r)$(OutputActivityRatio(r,t,TransportFuels,m,y) > 0 AND z_ProductionByTechnologyByModeAnnual(r,t,m,TransportFuels,y) > 0)  =  (y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByModeAnnual(r,t,m,TransportFuels,y))) / z_ProductionByTechnologyByModeAnnual(r,t,m,TransportFuels,y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,TransportFuels,m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenousfuelcosts(TransportFuels,y,r)$(ProductionAnnual.l(y,TransportFuels,r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycosts(TransportFuels,m,y,t,r)*z_ProductionByTechnologyByModeAnnual(r,t,m,TransportFuels,y)/ProductionAnnual.l(y,TransportFuels,r));

y_endogenouslevelizedtechnologycosts('Power',m,y,CHPs,r)$(sum(f,InputActivityRatio(r,CHPs,'Gas_Synth',m,y) > 0) AND OutputActivityRatio(r,CHPs,'Power',m,y) > 0)  = y_endogenouslevelizedtechnologycosts('Power',m,y,CHPs,r) + sum(f,InputActivityRatio(r,CHPs,f,m,y)*OutputActivityRatio(r,CHPs,'Power',m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenouslevelizedtechnologycosts('Power',m,y,CHPs,r)$(sum(f,InputActivityRatio(r,CHPs,'Gas_Bio',m,y) > 0) AND OutputActivityRatio(r,CHPs,'Power',m,y) > 0)  = y_endogenouslevelizedtechnologycosts('Power',m,y,CHPs,r) + sum(f,InputActivityRatio(r,CHPs,f,m,y)*OutputActivityRatio(r,CHPs,'Power',m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenouslevelizedtechnologycosts('Power',m,y,'P_Gas',r)$(sum(f,InputActivityRatio(r,'P_Gas','Gas_Synth',m,y) > 0) AND OutputActivityRatio(r,'P_Gas','Power',m,y) > 0)  = y_endogenouslevelizedtechnologycosts('Power',m,y,'P_Gas',r) + sum(f,InputActivityRatio(r,'P_Gas',f,m,y)*OutputActivityRatio(r,'P_Gas','Power',m,y)*y_endogenousfuelcosts(f,y,r));
y_endogenouslevelizedtechnologycosts('Power',m,y,'P_Gas',r)$(sum(f,InputActivityRatio(r,'P_Gas','Gas_Bio',m,y) > 0) AND OutputActivityRatio(r,'P_Gas','Power',m,y) > 0)  = y_endogenouslevelizedtechnologycosts('Power',m,y,'P_Gas',r) + sum(f,InputActivityRatio(r,'P_Gas',f,m,y)*OutputActivityRatio(r,'P_Gas','Power',m,y)*y_endogenousfuelcosts(f,y,r));

y_endogenousfuelcosts('Power',y,r)$(ProductionAnnual.l(y,'Power',r) > 0) = y_endogenousfuelcosts('Power',y,r) + sum((CHPs,m),y_endogenouslevelizedtechnologycosts('Power',m,y,CHPs,r)*z_ProductionByTechnologyByModeAnnual(r,CHPs,m,'Power',y)/ProductionAnnual.l(y,'Power',r)) + sum((m),y_endogenouslevelizedtechnologycosts('Power',m,y,'P_Gas',r)*z_ProductionByTechnologyByModeAnnual(r,'P_Gas',m,'Power',y)/ProductionAnnual.l(y,'Power',r));


y_endogenousfuelcostspertimeslice('Hardcoal',y,l,r)$(ProductionAnnual.l(y,'Hardcoal',r) > 0) = (VariableCost(r,'R_Coal_Hardcoal','1',y)/5 * ProductionByTechnologyAnnual.l(y,'R_Coal_Hardcoal','Hardcoal',r)/ProductionAnnual.l(y,'Hardcoal',r)) + (VariableCost(r,'Z_Import_Hardcoal','1',y)/5 * ProductionByTechnologyAnnual.l(y,'Z_Import_Hardcoal','Hardcoal',r)/ProductionAnnual.l(y,'Hardcoal',r));
y_endogenousfuelcostspertimeslice('Lignite',y,l,r) = VariableCost(r,'R_Coal_Lignite','1',y)/5 ;
y_endogenousfuelcostspertimeslice('Nuclear',y,l,r) = VariableCost(r,'R_Nuclear','1',y)/5 ;
y_endogenousfuelcostspertimeslice('Biomass',y,l,r) = VariableCost(r,'RES_Biomass','1',y)/5 ;
y_endogenousfuelcostspertimeslice('Gas_Natural',y,l,r)$(ProductionAnnual.l(y,'Gas_Natural',r) > 0) = (VariableCost(r,'R_Gas','1',y)/5 * ProductionByTechnologyAnnual.l(y,'R_Gas','Gas_Natural',r)/ProductionAnnual.l(y,'Gas_Natural',r)) + (VariableCost(r,'Z_Import_Gas','1',y)/5 * ProductionByTechnologyAnnual.l(y,'Z_Import_Gas','Gas_Natural',r)/ProductionAnnual.l(y,'Gas_Natural',r));

*y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,t,r)$(OutputActivityRatio(r,t,'Power',m,y) > 0 AND z_ProductionByTechnologyByMode(r,l,t,m,'Power',y) > 0) =  ((y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r)*YearSplit(l,y)) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByMode(r,l,t,m,'Power',y))) / z_ProductionByTechnologyByMode(r,l,t,m,'Power',y);
*y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,t,r)$(InputActivityRatio(r,t,'Power',m,y) > 0 AND OutputActivityRatio(r,t,'Power',m,y) > 0)  = y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,t,r) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Power',m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
*y_endogenousfuelcostspertimeslice('Power',y,l,r) = sum((t,m),y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,t,r)*z_ProductionByTechnologyByMode(r,l,t,m,'Power',y)/Production.l(y,l,'Power',r));

y_endogenouslevelizedtechnologycostspertimeslice('H2',m,y,l,t,r)$(OutputActivityRatio(r,t,'H2',m,y) > 0 AND z_ProductionByTechnologyByMode(r,l,t,m,'H2',y) > 0) =  ((y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r)*YearSplit(l,y)) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByMode(r,l,t,m,'H2',y))) / z_ProductionByTechnologyByMode(r,l,t,m,'H2',y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'H2',m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenousfuelcostspertimeslice('H2',y,l,r)$(Production.l(y,l,'H2',r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycostspertimeslice('H2',m,y,l,t,r)*z_ProductionByTechnologyByMode(r,l,t,m,'H2',y)/Production.l(y,l,'H2',r));

y_endogenouslevelizedtechnologycostspertimeslice('Gas_Bio',m,y,l,t,r)$(OutputActivityRatio(r,t,'Gas_Bio',m,y) > 0 AND z_ProductionByTechnologyByMode(r,l,t,m,'Gas_Bio',y) > 0) =  ((y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r)*YearSplit(l,y)) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByMode(r,l,t,m,'Gas_Bio',y))) / z_ProductionByTechnologyByMode(r,l,t,m,'Gas_Bio',y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Gas_Bio',m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenousfuelcostspertimeslice('Gas_Bio',y,l,r)$(Production.l(y,l,'Gas_Bio',r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycostspertimeslice('Gas_Bio',m,y,l,t,r)*z_ProductionByTechnologyByMode(r,l,t,m,'Gas_Bio',y)/Production.l(y,l,'Gas_Bio',r));

y_endogenouslevelizedtechnologycostspertimeslice('Gas_Synth',m,y,l,t,r)$(OutputActivityRatio(r,t,'Gas_Synth',m,y) > 0 AND z_ProductionByTechnologyByMode(r,l,t,m,'Gas_Synth',y) > 0) =  ((y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r)*YearSplit(l,y)) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByMode(r,l,t,m,'Gas_Synth',y))) / z_ProductionByTechnologyByMode(r,l,t,m,'Gas_Synth',y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Gas_Synth',m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenousfuelcostspertimeslice('Gas_Synth',y,l,r)$(Production.l(y,l,'Gas_Synth',r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycostspertimeslice('Gas_Synth',m,y,l,t,r)*z_ProductionByTechnologyByMode(r,l,t,m,'Gas_Synth',y)/Production.l(y,l,'Gas_Synth',r));


y_endogenouslevelizedtechnologycostspertimeslice(HeatFuels,m,y,l,t,r)$(OutputActivityRatio(r,t,HeatFuels,m,y) > 0 AND z_ProductionByTechnologyByMode(r,l,t,m,HeatFuels,y) > 0) =  ((y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r)*YearSplit(l,y)) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByMode(r,l,t,m,HeatFuels,y))) / z_ProductionByTechnologyByMode(r,l,t,m,HeatFuels,y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,HeatFuels,m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenousfuelcostspertimeslice(HeatFuels,y,l,r)$(Production.l(y,l,HeatFuels,r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycostspertimeslice(HeatFuels,m,y,l,t,r)*z_ProductionByTechnologyByMode(r,l,t,m,HeatFuels,y)/Production.l(y,l,HeatFuels,r));

y_endogenouslevelizedtechnologycostspertimeslice(TransportFuels,m,y,l,t,r)$(OutputActivityRatio(r,t,TransportFuels,m,y) > 0 AND z_ProductionByTechnologyByMode(r,l,t,m,TransportFuels,y) > 0) =  ((y_fixedcostperGW(y,r,t)*TotalCapacityAnnual.l(y,t,r)*YearSplit(l,y)) + (VariableCost(r,t,m,y)/5 * z_ProductionByTechnologyByMode(r,l,t,m,TransportFuels,y))) / z_ProductionByTechnologyByMode(r,l,t,m,TransportFuels,y) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,TransportFuels,m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenousfuelcostspertimeslice(TransportFuels,y,l,r)$(Production.l(y,l,TransportFuels,r) > 0) = sum((t,m),y_endogenouslevelizedtechnologycostspertimeslice(TransportFuels,m,y,l,t,r)*z_ProductionByTechnologyByMode(r,l,t,m,TransportFuels,y)/Production.l(y,l,TransportFuels,r));

y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,CHPs,r)$(InputActivityRatio(r,CHPs,'Gas_Synth',m,y) > 0 AND OutputActivityRatio(r,CHPs,'Power',m,y) > 0)  = y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,CHPs,r) + sum(f,InputActivityRatio(r,CHPs,f,m,y)*OutputActivityRatio(r,CHPs,'Power',m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,CHPs,r)$(InputActivityRatio(r,CHPs,'Gas_Bio',m,y) > 0 AND OutputActivityRatio(r,CHPs,'Power',m,y) > 0)  = y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,CHPs,r) + sum(f,InputActivityRatio(r,CHPs,f,m,y)*OutputActivityRatio(r,CHPs,'Power',m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,'P_Gas',r)$(InputActivityRatio(r,'P_Gas','Gas_Synth',m,y) > 0 AND OutputActivityRatio(r,'P_Gas','Power',m,y) > 0)  = y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,'P_Gas',r) + sum(f,InputActivityRatio(r,'P_Gas',f,m,y)*OutputActivityRatio(r,'P_Gas','Power',m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,'P_Gas',r)$(InputActivityRatio(r,'P_Gas','Gas_Bio',m,y) > 0 AND OutputActivityRatio(r,'P_Gas','Power',m,y) > 0)  = y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,'P_Gas',r) + sum(f,InputActivityRatio(r,'P_Gas',f,m,y)*OutputActivityRatio(r,'P_Gas','Power',m,y)*y_endogenousfuelcostspertimeslice(f,y,l,r));
y_endogenousfuelcostspertimeslice('Power',y,l,r)$(Production.l(y,l,'Power',r) > 0) = y_endogenousfuelcostspertimeslice('Power',y,l,r)+sum((CHPs,m),y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,CHPs,r)*z_ProductionByTechnologyByMode(r,l,CHPs,m,'Power',y)/Production.l(y,l,'Power',r))+sum((m),y_endogenouslevelizedtechnologycostspertimeslice('Power',m,y,l,'P_Gas',r)*z_ProductionByTechnologyByMode(r,l,'P_Gas',m,'Power',y)/Production.l(y,l,'Power',r));


** Calculations for theoretical levelized costs, based on different load levels

y_effectiveproductionfactorpertimeslice(r,t,y,l) = CapacityFactor(r,t,l,y)*AvailabilityFactor(r,t,y);
y_totalcapacityfactor(r,t,y) = sum(l,(CapacityFactor(r,t,l,y)*YearSplit(l,y)));
y_effectiveproductionfactor(r,t,y) = y_totalcapacityfactor(r,t,y)*AvailabilityFactor(r,t,y);
y_maximaltechnologyproduction(r,t,y,m,f,l) =  y_effectiveproductionfactorpertimeslice(r,t,y,l)*CapacityToActivityUnit(r,t)*OutputActivityRatio(r,t,f,m,y);
y_maximalyearlytechnologyproduction(r,t,y,m,f) = sum(l,y_maximaltechnologyproduction(r,t,y,m,f,l)*YearSplit(l,y));

y_realloadfactor(r,t,y) = 1-z_UnusedCapacityShare(r,t,y);
y_technologyshare(r,t,f,y)$(ProductionAnnual.l(y,f,r) > 0) = ProductionByTechnologyAnnual.l(y,t,f,r) / ProductionAnnual.l(y,f,r);
y_technologyshare(r,t,f,y)$(ProductionAnnual.l(y,f,r) = 0) = 1;


y_fuelcosts('Hardcoal',y,r,amnt)$(ProductionAnnual.l(y,'Hardcoal',r) > 0) = (VariableCost(r,'R_Coal_Hardcoal','1',y)/5 * ProductionByTechnologyAnnual.l(y,'R_Coal_Hardcoal','Hardcoal',r)/ProductionAnnual.l(y,'Hardcoal',r)) + (VariableCost(r,'Z_Import_Hardcoal','1',y)/5 * ProductionByTechnologyAnnual.l(y,'Z_Import_Hardcoal','Hardcoal',r)/ProductionAnnual.l(y,'Hardcoal',r));
y_fuelcosts('Lignite',y,r,amnt) = VariableCost(r,'R_Coal_Lignite','1',y)/5 ;
y_fuelcosts('Nuclear',y,r,amnt) = VariableCost(r,'R_Nuclear','1',y)/5 ;
y_fuelcosts('Biomass',y,r,amnt) = VariableCost(r,'RES_Biomass','1',y)/5 ;
y_fuelcosts('Gas_Natural',y,r,amnt)$(ProductionAnnual.l(y,'Gas_Natural',r) > 0) = (VariableCost(r,'R_Gas','1',y)/5 * ProductionByTechnologyAnnual.l(y,'R_Gas','Gas_Natural',r)/ProductionAnnual.l(y,'Gas_Natural',r)) + (VariableCost(r,'Z_Import_Gas','1',y)/5 * ProductionByTechnologyAnnual.l(y,'Z_Import_Gas','Gas_Natural',r)/ProductionAnnual.l(y,'Gas_Natural',r));


y_levelizedtechnologycosts('Power',m,y,t,r,amnt)$(OutputActivityRatio(r,t,'Power',m,y) > 0 AND y_maximalyearlytechnologyproduction(r,t,y,m,"Power") > 0) =  (y_fixedcostperGW(y,r,t) + (VariableCost(r,t,m,y)/5 * y_maximalyearlytechnologyproduction(r,t,y,m,'Power') * y_loadfactor(amnt))) / (y_maximalyearlytechnologyproduction(r,t,y,m,'Power') * y_loadfactor(amnt));
y_levelizedtechnologycosts('Power',m,y,t,r,amnt)$(sum(f,InputActivityRatio(r,t,f,m,y) > 0) AND OutputActivityRatio(r,t,'Power',m,y) > 0)  = y_levelizedtechnologycosts('Power',m,y,t,r,amnt) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Power',m,y)*y_fuelcosts(f,y,r,amnt));
y_fuelcosts('Power',y,r,amnt) = sum((t,m),y_technologyshare(r,t,'Power',y)*y_levelizedtechnologycosts('Power',m,y,t,r,amnt));

y_levelizedtechnologycosts('H2',m,y,t,r,amnt)$(OutputActivityRatio(r,t,'H2',m,y) > 0 AND y_maximalyearlytechnologyproduction(r,t,y,m,"H2") > 0)  =  (y_fixedcostperGW(y,r,t) + (VariableCost(r,t,m,y)/5 * y_maximalyearlytechnologyproduction(r,t,y,m,'H2') * y_loadfactor(amnt))) / (y_maximalyearlytechnologyproduction(r,t,y,m,'H2') * y_loadfactor(amnt)) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'H2',m,y)*y_endogenousfuelcosts(f,y,r));
y_fuelcosts('H2',y,r,amnt) = sum((t,m),y_levelizedtechnologycosts('H2',m,y,t,r,amnt)*y_technologyshare(r,t,'H2',y));

y_levelizedtechnologycosts('Gas_Bio',m,y,t,r,amnt)$(OutputActivityRatio(r,t,'Gas_Bio',m,y) > 0 AND y_maximalyearlytechnologyproduction(r,t,y,m,"Gas_Bio") > 0)  =  (y_fixedcostperGW(y,r,t) + (VariableCost(r,t,m,y)/5 * y_maximalyearlytechnologyproduction(r,t,y,m,'Gas_Bio') * y_loadfactor(amnt))) / (y_maximalyearlytechnologyproduction(r,t,y,m,'Gas_Bio') * y_loadfactor(amnt)) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Gas_Bio',m,y)*y_fuelcosts(f,y,r,amnt));
y_fuelcosts('Gas_Bio',y,r,amnt) = sum((t,m),y_levelizedtechnologycosts('Gas_Bio',m,y,t,r,amnt)*y_technologyshare(r,t,'Gas_Bio',y));

y_levelizedtechnologycosts('Gas_Synth',m,y,t,r,amnt)$(OutputActivityRatio(r,t,'Gas_Synth',m,y) > 0 AND y_maximalyearlytechnologyproduction(r,t,y,m,"Gas_Synth") > 0)  =  (y_fixedcostperGW(y,r,t) + (VariableCost(r,t,m,y)/5 * y_maximalyearlytechnologyproduction(r,t,y,m,'Gas_Synth') * y_loadfactor(amnt))) / (y_maximalyearlytechnologyproduction(r,t,y,m,'Gas_Synth') * y_loadfactor(amnt)) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,'Gas_Synth',m,y)*y_fuelcosts(f,y,r,amnt));
y_fuelcosts('Gas_Synth',y,r,amnt) = sum((t,m),y_levelizedtechnologycosts('Gas_Synth',m,y,t,r,amnt)*y_technologyshare(r,t,'Gas_Synth',y));

y_levelizedtechnologycosts(HeatFuels,m,y,t,r,amnt)$(OutputActivityRatio(r,t,HeatFuels,m,y) > 0 AND y_maximalyearlytechnologyproduction(r,t,y,m,HeatFuels) > 0)  =  (y_fixedcostperGW(y,r,t) + (VariableCost(r,t,m,y)/5 * y_maximalyearlytechnologyproduction(r,t,y,m,HeatFuels) * y_loadfactor(amnt))) / (y_maximalyearlytechnologyproduction(r,t,y,m,HeatFuels) * y_loadfactor(amnt)) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,HeatFuels,m,y)*y_fuelcosts(f,y,r,amnt));
y_fuelcosts(HeatFuels,y,r,amnt) = sum((t,m),y_levelizedtechnologycosts(HeatFuels,m,y,t,r,amnt)*y_technologyshare(r,t,HeatFuels,y));

y_levelizedtechnologycosts(TransportFuels,m,y,t,r,amnt)$(OutputActivityRatio(r,t,TransportFuels,m,y) > 0 AND y_maximalyearlytechnologyproduction(r,t,y,m,TransportFuels) > 0)  =  (y_fixedcostperGW(y,r,t) + (VariableCost(r,t,m,y)/5 * y_maximalyearlytechnologyproduction(r,t,y,m,TransportFuels) * y_loadfactor(amnt))) / (y_maximalyearlytechnologyproduction(r,t,y,m,TransportFuels) * y_loadfactor(amnt)) + sum(f,InputActivityRatio(r,t,f,m,y)*OutputActivityRatio(r,t,TransportFuels,m,y)*y_fuelcosts(f,y,r,amnt));
y_fuelcosts(TransportFuels,y,r,amnt) = sum((t,m),y_levelizedtechnologycosts(TransportFuels,m,y,t,r,amnt)*y_technologyshare(r,t,TransportFuels,y));

y_levelizedtechnologycosts('Power',m,y,CHPs,r,amnt)$(sum(f,InputActivityRatio(r,CHPs,'Gas_Synth',m,y) > 0) AND OutputActivityRatio(r,CHPs,'Power',m,y) > 0)  = y_levelizedtechnologycosts('Power',m,y,CHPs,r,amnt) + sum(f,InputActivityRatio(r,CHPs,f,m,y)*OutputActivityRatio(r,CHPs,'Power',m,y)*y_fuelcosts(f,y,r,amnt));
y_levelizedtechnologycosts('Power',m,y,CHPs,r,amnt)$(sum(f,InputActivityRatio(r,CHPs,'Gas_Bio',m,y) > 0) AND OutputActivityRatio(r,CHPs,'Power',m,y) > 0)  = y_levelizedtechnologycosts('Power',m,y,CHPs,r,amnt) + sum(f,InputActivityRatio(r,CHPs,f,m,y)*OutputActivityRatio(r,CHPs,'Power',m,y)*y_fuelcosts(f,y,r,amnt));
y_levelizedtechnologycosts('Power',m,y,'P_Gas',r,amnt)$(sum(f,InputActivityRatio(r,'P_Gas','Gas_Bio',m,y) > 0) AND OutputActivityRatio(r,'P_Gas','Power',m,y) > 0)  = y_levelizedtechnologycosts('Power',m,y,'P_Gas',r,amnt) + sum(f,InputActivityRatio(r,'P_Gas',f,m,y)*OutputActivityRatio(r,'P_Gas','Power',m,y)*y_fuelcosts(f,y,r,amnt));
y_levelizedtechnologycosts('Power',m,y,'P_Gas',r,amnt)$(sum(f,InputActivityRatio(r,'P_Gas','Gas_Synth',m,y) > 0) AND OutputActivityRatio(r,'P_Gas','Power',m,y) > 0)  = y_levelizedtechnologycosts('Power',m,y,'P_Gas',r,amnt) + sum(f,InputActivityRatio(r,'P_Gas',f,m,y)*OutputActivityRatio(r,'P_Gas','Power',m,y)*y_fuelcosts(f,y,r,amnt));
y_fuelcosts('Power',y,r,amnt) = y_fuelcosts('Power',y,r,amnt) + sum((CHPs,m),y_technologyshare(r,CHPs,'Power',y)*y_levelizedtechnologycosts('Power',m,y,CHPs,r,amnt))+ sum((m),y_technologyshare(r,'P_Gas','Power',y)*y_levelizedtechnologycosts('Power',m,y,'P_Gas',r,amnt)) ;


z_FuelProducedByCarrier(y,r,'Solar',f) = sum((Solar),ProductionByTechnologyAnnual.l(y,Solar,f,r));
z_FuelProducedByCarrier(y,r,'Wind_Onshore',f) = sum((Onshore),ProductionByTechnologyAnnual.l(y,Onshore,f,r));
z_FuelProducedByCarrier(y,r,'Wind_Offshore',f) = sum((Offshore),ProductionByTechnologyAnnual.l(y,Offshore,f,r));
z_FuelProducedByCarrier(y,r,'Hydro',f) = sum((Hydro),ProductionByTechnologyAnnual.l(y,Hydro,f,r));
z_FuelProducedByCarrier(y,r,'Biomass',f) = ProductionByTechnologyAnnual.l(y,'Res_Biomass',f,r);
z_FuelProducedByCarrier(y,r,'Lignite',f) = sum((Lignite),ProductionByTechnologyAnnual.l(y,Lignite,f,r));
z_FuelProducedByCarrier(y,r,'HardCoal',f) = sum((HardCoal),ProductionByTechnologyAnnual.l(y,HardCoal,f,r));
z_FuelProducedByCarrier(y,r,'Oil',f) = sum((Oil),ProductionByTechnologyAnnual.l(y,Oil,f,r));
z_FuelProducedByCarrier(y,r,'Nuclear',f) = ProductionByTechnologyAnnual.l(y,'P_Nuclear',f,r);
z_FuelProducedByCarrier(y,r,'Gas',f) = sum((Gas),z_ProductionByTechnologyByModeAnnual(r,Gas,'1',f,y));

z_residentialdemandshare(r) = 0.35;

excel_sectors(r,'PowerProd',dm,y,'PJ','%emissionPathway%_%emissionScenario%') =  z_FuelProducedByCarrier(y,r,dm,'Power');
excel_sectors(r,'PowerUse','Residential',y,'PJ','%emissionPathway%_%emissionScenario%') = SpecifiedAnnualDemand(r,'Power',y)* z_residentialdemandshare(r);
excel_sectors(r,'PowerUse','Industrial',y,'PJ','%emissionPathway%_%emissionScenario%') = SpecifiedAnnualDemand(r,'Power',y)* (1- z_residentialdemandshare(r));
excel_sectors(r,'PowerUse','Sector-Coupling',y,'PJ','%emissionPathway%_%emissionScenario%') = ProductionAnnual.l(y,'Power',r)-SpecifiedAnnualDemand(r,'Power',y)-sum(StorageDummies,ProductionByTechnologyAnnual.l(y,StorageDummies,'Power',r));


excel_sectors(r,'HeatLowBuildings',f,y,'PJ','%emissionPathway%_%emissionScenario%') = sum(HeatLowRes,UseByTechnologyAnnual.l(y,HeatLowRes,f,r));
excel_sectors(r,'HeatLowIndustry',f,y,'PJ','%emissionPathway%_%emissionScenario%') = sum(HeatLowInd,UseByTechnologyAnnual.l(y,HeatLowInd,f,r));
excel_sectors(r,'HeatMediumIndustry',f,y,'PJ','%emissionPathway%_%emissionScenario%') = sum(HeatMedInd,UseByTechnologyAnnual.l(y,HeatMedInd,f,r));
excel_sectors(r,'HeatHighIndustry',f,y,'PJ','%emissionPathway%_%emissionScenario%') = sum(HeatHighInd,UseByTechnologyAnnual.l(y,HeatHighInd,f,r));

excel_sectors(r,'PassengerTransport',f,y,'PJ','%emissionPathway%_%emissionScenario%') = sum(Passenger,UseByTechnologyAnnual.l(y,Passenger,f,r));
excel_sectors(r,'FreightTransport',f,y,'PJ','%emissionPathway%_%emissionScenario%') = sum(Freight,UseByTechnologyAnnual.l(y,Freight,f,r));

excel_lvlcosts(y,r,t,f,m,l,'LevelizedTechnologyCostsPerTimeslice','Endogenous') =  y_endogenouslevelizedtechnologycostspertimeslice(f,m,y,l,t,r);
excel_lvlcosts(y,r,t,f,m,'N/A','LevelizedTechnologyCosts','Endogenous') = y_endogenouslevelizedtechnologycosts(f,m,y,t,r);
excel_lvlcosts(y,r,t,f,m,'N/A','LevelizedTechnologyCosts',amnt) = y_levelizedtechnologycosts(f,m,y,t,r,amnt);


excel_lvlcosts(y,r,'N/A',f,'N/A',l,'FuelCostsPerTimeSlice','Endogenous') = y_endogenousfuelcostspertimeslice(f,y,l,r);
excel_lvlcosts(y,r,'N/A',f,'N/A','N/A','FuelCosts','Endogenous') =  y_endogenousfuelcosts(f,y,r);
excel_lvlcosts(y,r,'N/A',f,'N/A','N/A','FuelCosts',amnt) =  y_fuelcosts(f,y,r,amnt);


z_sectorcouplingpertimeslice(y,l,'Power',r) = Production.l(y,l,'Power',r)-Demand(y,l,'Power',r);
z_productionprofile(y,l,'Power',r)$(ProductionAnnual.l(y,'Power',r) > 0) = Production.l(y,l,'Power',r)/ProductionAnnual.l(y,'Power',r);
z_sectorcouplingdifference(y,l,'Power',r) =  z_productionprofile(y,l,'Power',r)-SpecifiedDemandProfile(r,'Power',l,y);



