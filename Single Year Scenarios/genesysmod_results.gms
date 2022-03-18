* ################## genesysmod_results.gms ###################
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


$if not set test $setglobal test 0
$if not setglobal ResultDefineSets $setglobal ResultDefineSets 1
$ifthen %ResultDefineSets% == 1

Set
Category / Transformation, Buildings, Industry, Storage, Resource, Power, Transportation, Area /
map_techToCategory(t,Category)
;
alias(Category, c);

set dummyProduction /Hardcoal,Lignite,Oil,Nuclear,Renewables,Power,Gas,Wind_Onshore,Wind_Offshore,Biomass,Solar,Hydro/;
alias (dummyProduction,dm);

Set TableauCountries /Ireland,Spain,Estonia,Latvia,Hungary,Romania,Croatia,Slovenia,Luxembourg,Sweden,Norway,Albania,Bulgaria,Montenegro,Kosovo,Macedonia,Bosnia/;

set dummyOutputFuel(f);
dummyOutputFuel(f) = no;
alias (dummyOutputFuel,of);

Parameter
z_Capacity
z_production
z_use
z_emission_tech
z_emission_year
z_emission_year_world
z_Trade_year
z_Storage_charge
z_ProductionAnnualWorld
z_CapitalInvestmentWorld
z_CapitalInvestmentRegion
z_CapitalInvestmentPercent
z_SpecifiedAnnualDemandWorld
z_AccumulatedAnnualDemandWorld
z_ProductionAnnualWorldByTechnology
z_UseByTechnologyAnnualWorld
z_ProductionAnnualWorld_pt
z_SpecifiedAnnualDemandWorld_pt
z_AccumulatedAnnualDemandWorld_pt
z_ProductionAnnualWorldByTechnology_pt
z_UseByTechnologyAnnualWorld_pt
z_EmissionsPerTechnologyAnnual
z_AmountOfEnergyStored
z_PercentStoredOfAnnualDemand
z_EmissionsPerTechnologyAnnual
z_AmountOfEnergyStored
z_PercentStoredOfAnnualDemand
z_EnergyProducedByCarrier
z_TotalEnergyProduced
z_ShareProducedPerCarrier
z_ShareProducedPerCarrierWorld
z_TotalEnergyDemand
z_EnergyConsumedPerOutputFuel
z_TransportEnergyDemand
z_TransportEnergyDemandPerFuel
z_TransportEnergyDemandPerTechnology
z_ProductionByTechnologyByModeAnnual
z_ProductionByTechnologyByMode
z_UseByTechnologyByMode
z_EmissionOutputPerFuel
z_UnusedCapacityPerRegion
z_UnusedCapacityShare
z_ModelPeriodEmissionPercent
z_UnusedCapacityPerRegionEachTS
z_CapacityUsedByTechnologyEachTS
z_PeakCapacityByTechnology
excel_capacity
excel_production
excel_emission
excel_costs
excel_trade
excel_share
excel_transport
;

scalar z_ValueToPT;
$endif

map_techToCategory(t,c) = NO;

map_techToCategory('X_Electrolysis','Transformation') = Yes;
map_techToCategory('X_Fuel_Cell','Transformation') = Yes;
map_techToCategory('X_Methanation','Transformation') = Yes;
map_techToCategory('X_SMR','Transformation') = Yes;
map_techToCategory('X_SMR_CCS','Transformation') = Yes;
map_techToCategory('X_DAC','Transformation') = Yes;

map_techToCategory('HLR_Gas_Boiler','Buildings') = Yes;
map_techToCategory('HLR_Gas_CHP','Buildings') = Yes;
map_techToCategory('HLR_Biomass','Buildings') = Yes;
map_techToCategory('HLR_Biomass_CHP','Buildings') = Yes;
map_techToCategory('HLR_Hardcoal','Buildings') = Yes;
map_techToCategory('HLR_Lignite','Buildings') = Yes;
map_techToCategory('HLR_Hardcoal_CHP','Buildings') = Yes;
map_techToCategory('HLR_Lignite_CHP','Buildings') = Yes;
map_techToCategory('HLR_Direct_Electric','Buildings') = Yes;
map_techToCategory('HLR_Solar_Thermal','Buildings') = Yes;
map_techToCategory('HLR_Heatpump_Aerial','Buildings') = Yes;
map_techToCategory('HLR_Heatpump_Ground','Buildings') = Yes;
map_techToCategory('HLR_Geothermal','Buildings') = Yes;
map_techToCategory('HLR_Oil_Boiler','Buildings') = Yes;
map_techToCategory('HLR_Biomass_CHP_CCS','Buildings') = Yes;
map_techToCategory('HLR_Hardcoal_CHP_CCS','Buildings') = Yes;
map_techToCategory('HLR_Lignite_CHP_CCS','Buildings') = Yes;
map_techToCategory('HLR_H2_Boiler','Industry') = Yes;

map_techToCategory('HLI_Gas_Boiler','Industry') = Yes;
map_techToCategory('HLI_Gas_CHP','Industry') = Yes;
map_techToCategory('HLI_Biomass','Industry') = Yes;
map_techToCategory('HLI_Biomass_CHP','Industry') = Yes;
map_techToCategory('HLI_Hardcoal','Industry') = Yes;
map_techToCategory('HLI_Lignite','Industry') = Yes;
map_techToCategory('HLI_Hardcoal_CHP','Industry') = Yes;
map_techToCategory('HLI_Lignite_CHP','Industry') = Yes;
map_techToCategory('HLI_Direct_Electric','Industry') = Yes;
map_techToCategory('HLI_Solar_Thermal','Industry') = Yes;
map_techToCategory('HLI_Fuelcell','Industry') = Yes;
map_techToCategory('HLI_Geothermal','Industry') = Yes;
map_techToCategory('HLI_Oil_Boiler','Industry') = Yes;
map_techToCategory('HLI_Oil_CHP','Industry') = Yes;
map_techToCategory('HLI_Biomass_CHP_CCS','Industry') = Yes;
map_techToCategory('HLI_Hardcoal_CHP_CCS','Industry') = Yes;
map_techToCategory('HLI_Lignite_CHP_CCS','Industry') = Yes;
map_techToCategory('HLI_H2_Boiler','Industry') = Yes;

map_techToCategory('HMI_Gas','Industry') = Yes;
map_techToCategory('HMI_Biomass','Industry') = Yes;
map_techToCategory('HMI_HardCoal','Industry') = Yes;
map_techToCategory('HMI_Steam_Electric','Industry') = Yes;
map_techToCategory('HMI_Oil','Industry') = Yes;
map_techToCategory('HMI_Gas_CCS','Industry') = Yes;
map_techToCategory('HMI_HardCoal_CCS','Industry') = Yes;

map_techToCategory('HHI_BF_BOF','Industry') = Yes;
map_techToCategory('HHI_DRI_EAF','Industry') = Yes;
map_techToCategory('HHI_Scrap_EAF','Industry') = Yes;
map_techToCategory('HHI_H2DRI_EAF','Industry') = Yes;
map_techToCategory('HHI_Molten_Electrolysis','Industry') = Yes;
map_techToCategory('HHI_Bio_BF_BOF','Industry') = Yes;
map_techToCategory('HHI_BF_BOF_CCS','Industry') = Yes;
map_techToCategory('HHI_DRI_EAF_CCS','Industry') = Yes;

map_techToCategory('D_Battery_Li-Ion','Storage') = Yes;
map_techToCategory('D_Battery_Redox','Storage') = Yes;
map_techToCategory('D_Gas_H2','Storage') = Yes;
map_techToCategory('D_Gas_Methane','Storage') = Yes;
map_techToCategory('D_Heat_HLR','Storage') = Yes;
map_techToCategory('D_Heat_HLI','Storage') = Yes;
map_techToCategory('D_PHS','Storage') = Yes;
map_techToCategory('D_CAES','Storage') = Yes;


$ontext
map_techToCategory('Area_Wind_offshore','Landuse') = Yes;
map_techToCategory('Area_Wind_onshore','Landuse') = Yes;
map_techToCategory('Area_Solar_roof','Landuse') = Yes;
map_techToCategory('Area_PV_Commercial','Landuse') = Yes;
map_techToCategory('Area_PV_Utility_opt','Landuse') = Yes;
map_techToCategory('Area_PV_Utility_avg','Landuse') = Yes;
map_techToCategory('Area_PV_Utility_inf','Landuse') = Yes;
map_techToCategory('Area_CSP_Storage','Landuse') = Yes;
map_techToCategory('Area_CSP','Landuse') = Yes;
map_techToCategory('Area_Thermal_GEO','Landuse') = Yes;
map_techToCategory('Area_Hydro_small','Landuse') = Yes;
map_techToCategory('Area_Hydro_large','Landuse') = Yes;
map_techToCategory('Area_wave','Landuse') = Yes;
map_techToCategory('Area_tidal','Landuse') = Yes;
map_techToCategory('Area_biofuels','Landuse') = Yes;
map_techToCategory('Area_DistrictHeating_avg','Landuse') = Yes;
map_techToCategory('Area_DistrictHeating_inf','Landuse') = Yes;
map_techToCategory('Area_DistrictHeating_opt','Landuse') = Yes;
$offtext

*-----------2015er Technologien-------------
map_techToCategory('R_Coal_Hardcoal','Resource') = Yes;
map_techToCategory('R_Coal_Lignite','Resource') = Yes;
map_techToCategory('R_Gas','Resource') = Yes;
map_techToCategory('R_Nuclear','Resource') = Yes;
map_techToCategory('R_Oil','Resource') = Yes;
map_techToCategory(ImportTechnology,'Resource') = Yes;

map_techToCategory('P_Biomass','Power') = Yes;
map_techToCategory('P_Biomass_CCS','Power') = Yes;
map_techToCategory('P_Coal_Hardcoal','Power') = Yes;
map_techToCategory('P_Coal_Lignite','Power') = Yes;
map_techToCategory('P_Gas','Power') = Yes;
map_techToCategory('P_Oil','Power') = Yes;
map_techToCategory('P_Nuclear','Power') = Yes;

map_techToCategory('P_Coal_Hardcoal_CCS','Power') = Yes;
map_techToCategory('P_Coal_Lignite_CCS','Power') = Yes;
map_techToCategory('P_Gas_CCS','Power') = Yes;
;
map_techToCategory('RES_Biomass','Power') = Yes;
map_techToCategory('RES_CSP','Power') = Yes;
map_techToCategory('RES_Geothermal','Power') = Yes;
map_techToCategory('RES_Hydro_Large','Power') = Yes;
map_techToCategory('RES_Hydro_Small','Power') = Yes;
map_techToCategory('RES_Ocean','Power') = Yes;
map_techToCategory('RES_PV_Rooftop_Commercial','Power') = Yes;
map_techToCategory('RES_PV_Rooftop_Residential','Power') = Yes;
map_techToCategory('RES_PV_Utility_Avg','Power') = Yes;
map_techToCategory('RES_PV_Utility_Inf','Power') = Yes;
map_techToCategory('RES_PV_Utility_Opt','Power') = Yes;
map_techToCategory('RES_Wind_Offshore_Transitional','Power') = Yes;
map_techToCategory('RES_Wind_Offshore_Shallow','Power') = Yes;
map_techToCategory('RES_Wind_Offshore_Deep','Power') = Yes;
map_techToCategory('RES_Wind_Onshore_Avg','Power') = Yes;
map_techToCategory('RES_Wind_Onshore_Inf','Power') = Yes;
map_techToCategory('RES_Wind_Onshore_Opt','Power') = Yes;

map_techToCategory('PSNG_Air_Bio','Transportation') = Yes;
map_techToCategory('PSNG_Air_Conv','Transportation') = Yes;
map_techToCategory('PSNG_Air_H2','Transportation') = Yes;
map_techToCategory('PSNG_Rail_Conv','Transportation') = Yes;
map_techToCategory('PSNG_Rail_Electric','Transportation') = Yes;
map_techToCategory('PSNG_Road_BEV','Transportation') = Yes;
map_techToCategory('PSNG_Road_H2','Transportation') = Yes;
map_techToCategory('PSNG_Road_ICE','Transportation') = Yes;
map_techToCategory('PSNG_Road_PHEV','Transportation') = Yes;
map_techToCategory('FRT_Rail_Conv','Transportation') = Yes;
map_techToCategory('FRT_Rail_Electric','Transportation') = Yes;
map_techToCategory('FRT_Road_BEV','Transportation') = Yes;
map_techToCategory('FRT_Road_H2','Transportation') = Yes;
map_techToCategory('FRT_Road_ICE','Transportation') = Yes;
map_techToCategory('FRT_Road_PHEV','Transportation') = Yes;
map_techToCategory('FRT_Road_OH','Transportation') = Yes;
map_techToCategory('FRT_Ship_Bio','Transportation') = Yes;
map_techToCategory('FRT_Ship_Conv','Transportation') = Yes;

map_techToCategory('A_CCS_Capacity','Area') = Yes;
*map_techToCategory('A_Air','Area') = Yes;

of('Power') = yes;
of('Mobility_Freight') = yes;
of('Mobility_Passenger') = yes;
of('Heat_Low_Residential') = yes;
of('Heat_Low_Industrial') = yes;
of('Heat_Medium_Industrial') = yes;
of('Heat_High_Industrial') = yes;

$ifthen %test% == 0

z_ProductionByTechnologyByModeAnnual(r,t,m,f,y) = sum(l,RateOfProductionByTechnologyByMode.l(y,l,t,m,f,r)*YearSplit(l,y));
z_ProductionByTechnologyByMode(r,l,t,m,f,y) = RateOfProductionByTechnologyByMode.l(y,l,t,m,f,r) * YearSplit(l,y);
z_UseByTechnologyByMode(r,l,t,m,f,y) = RateOfUseByTechnologyByMode.l(y,l,t,m,f,r) * YearSplit(l,y);

excel_transport(y,r,Transport,m,f,'%emissionPathway%_%emissionScenario%') =  z_ProductionByTechnologyByModeAnnual(r,Transport,m,f,y);

z_ValueToPT = 0.00043;
z_Capacity(t,y,r) = AccumulatedNewCapacity.l(y,t,r) ;
z_production(f,t,r) = sum((y,l),ProductionByTechnology.l(y,l,t,f,r)) ;
z_use(f,t,r)      = sum((y,l), UseByTechnology.l(y,l,t,f,r))  ;
z_emission_tech(e,t,r)  = sum((y),AnnualTechnologyEmission.l(y,t,e,r)) ;
z_emission_year(e,y,r)  = sum((t),AnnualTechnologyEmission.l(y,t,e,r)) ;
z_CapitalInvestmentWorld(y) = sum(t,sum(r,CapitalInvestment.l(y,t,r)));
z_CapitalInvestmentRegion(y,r) = sum(t,CapitalInvestment.l(y,t,r));
z_CapitalInvestmentPercent(y) = z_CapitalInvestmentWorld(y)/sum(yy,z_CapitalInvestmentWorld(yy))*100;
z_emission_year_world(e,y) = sum(r,Z_emission_year(e,y,r));
z_Trade_year(y,f,r)   = NetTradeAnnual.l(y,f,r) ;
*z_storage_charge(s,y,r,'Charge') =  sum((ls,ld,lh), RateOfStorageCharge.l(s,y,ls,ld,lh,r) ) ;
*z_storage_charge(s,y,r,'Discharge') =  - sum((ls,ld,lh), RateOfStorageDischarge.l(s,y,ls,ld,lh,r)) ;
z_ProductionAnnualWorld(y,f) = sum(r,ProductionAnnual.l(y,f,r));
z_ProductionAnnualWorldByTechnology(y,t,f) = sum(r,ProductionByTechnologyAnnual.l(y,t,f,r));
z_UseByTechnologyAnnualWorld(y,t,f) = sum(r,UseByTechnologyAnnual.l(y,t,f,r));
*z_AccumulatedAnnualDemandWorld(f,y) = sum(r,AccumulatedAnnualDemand(r,f,y));
z_SpecifiedAnnualDemandWorld(f,y) = sum(r,SpecifiedAnnualDemand(r,f,y));

z_ProductionAnnualWorld_pt(y,f) = z_ProductionAnnualWorld(y,f) * z_ValueToPT;
z_ProductionAnnualWorldByTechnology_pt(y,t,f) = z_ProductionAnnualWorldByTechnology(y,t,f) * z_ValueToPT;
z_UseByTechnologyAnnualWorld_pt(y,t,f) = z_UseByTechnologyAnnualWorld(y,t,f) * z_ValueToPT ;
*z_AccumulatedAnnualDemandWorld_pt(f,y) = z_AccumulatedAnnualDemandWorld(f,y)* z_ValueToPT;
z_SpecifiedAnnualDemandWorld_pt(f,y) = z_SpecifiedAnnualDemandWorld(f,y)* z_ValueToPT;

z_EmissionsPerTechnologyAnnual(e,y,t,'Hardcoal',r) = AnnualTechnologyEmission.l(y,'R_Coal_Hardcoal',e,r)+AnnualTechnologyEmission.l(y,'Z_Import_Hardcoal',e,r);
*UseByTechnologyAnnual.l(y,t,'Hardcoal',r)*sum(m,EmissionActivityRatio(r,'R_Coal_Hardcoal',e,m,y)+EmissionActivityRatio(r,'Z_Import_Hardcoal',e,m,y));
z_EmissionsPerTechnologyAnnual(e,y,t,'Lignite',r) = AnnualTechnologyEmission.l(y,'R_Coal_Lignite',e,r);
*UseByTechnologyAnnual.l(y,t,'Lignite',r)*sum(m,EmissionActivityRatio(r,'R_Coal_Lignite',e,m,y));
z_EmissionsPerTechnologyAnnual(e,y,t,'Oil',r) = AnnualTechnologyEmission.l(y,'R_Oil',e,r)+AnnualTechnologyEmission.l(y,'Z_Import_Oil',e,r);
*UseByTechnologyAnnual.l(y,t,'Oil',r)*sum(m,EmissionActivityRatio(r,'R_Oil',e,m,y)+EmissionActivityRatio(r,'Z_Import_Oil',e,m,y));
z_EmissionsPerTechnologyAnnual(e,y,t,'Methane',r) = AnnualTechnologyEmission.l(y,'R_Gas',e,r)+AnnualTechnologyEmission.l(y,'Z_Import_Gas',e,r);
*UseByTechnologyAnnual.l(y,t,'Methane',r)*sum(m,EmissionActivityRatio(r,'R_Gas',e,m,y)+EmissionActivityRatio(r,'Z_Import_Gas',e,m,y));
z_EmissionsPerTechnologyAnnual(e,y,t,'Nuclear',r) = AnnualTechnologyEmission.l(y,'R_Nuclear',e,r);
*UseByTechnologyAnnual.l(y,t,'Nuclear',r)*sum(m,EmissionActivityRatio(r,'R_Nuclear',e,m,y));

z_AmountOfEnergyStored(y,StorageDummies,f,r) = ProductionByTechnologyAnnual.l(y,StorageDummies,f,r);
z_PercentStoredOfAnnualDemand(y,StorageDummies,f,r)$(SpecifiedAnnualDemand(r,f,y) > 0) = ProductionByTechnologyAnnual.l(y,StorageDummies,f,r)/SpecifiedAnnualDemand(r,f,y)*100;

z_TransportEnergyDemandPerTechnology('Power',Transport,r,y) = UseByTechnologyAnnual.l(y,Transport,'Power',r)+UseByTechnologyAnnual.l(y,Transport,'H2',r)*1.75;
z_TransportEnergyDemandPerTechnology('Oil',Transport,r,y) = UseByTechnologyAnnual.l(y,Transport,'Oil',r);
z_TransportEnergyDemandPerTechnology('Biomass',Transport,r,y) = UseByTechnologyAnnual.l(y,Transport,'Biomass',r);
*
z_TransportEnergyDemandPerFuel(f,r,y) = sum(Transport,z_TransportEnergyDemandPerTechnology(f,Transport,r,y));

z_TransportEnergyDemand('Mobility_Passenger',r,y) = sum((Passenger,f),z_TransportEnergyDemandPerTechnology(f,Passenger,r,y));
z_TransportEnergyDemand('Mobility_Freight',r,y) = sum((Freight,f),z_TransportEnergyDemandPerTechnology(f,Freight,r,y));

z_EnergyProducedByCarrier(y,r,'Solar') = sum((Solar,f),ProductionByTechnologyAnnual.l(y,Solar,f,r));
z_EnergyProducedByCarrier(y,r,'Wind_Onshore') = sum((Onshore,f),ProductionByTechnologyAnnual.l(y,Onshore,f,r));
z_EnergyProducedByCarrier(y,r,'Wind_Offshore') = sum((Offshore,f),ProductionByTechnologyAnnual.l(y,Offshore,f,r));
z_EnergyProducedByCarrier(y,r,'Hydro') = sum((Hydro,f),ProductionByTechnologyAnnual.l(y,Hydro,f,r));
z_EnergyProducedByCarrier(y,r,'Biomass') = sum(f,ProductionByTechnologyAnnual.l(y,'Res_Biomass',f,r));
z_EnergyProducedByCarrier(y,r,'Lignite') = sum((Lignite,f),ProductionByTechnologyAnnual.l(y,Lignite,f,r));
z_EnergyProducedByCarrier(y,r,'HardCoal') = sum((HardCoal,f),ProductionByTechnologyAnnual.l(y,HardCoal,f,r));
z_EnergyProducedByCarrier(y,r,'Oil') = sum((Oil,f),ProductionByTechnologyAnnual.l(y,Oil,f,r))+z_TransportEnergyDemandPerFuel('Oil',r,y);
z_EnergyProducedByCarrier(y,r,'Nuclear') = sum(f,ProductionByTechnologyAnnual.l(y,'P_Nuclear',f,r));
z_EnergyProducedByCarrier(y,r,'Gas') = sum((Gas,f),z_ProductionByTechnologyByModeAnnual(r,Gas,'1',f,y));
*z_EnergyProducedByCarrier(y,r,'Power') = sum((Power,f),ProductionByTechnologyAnnual.l(y,Power,f,r));
z_TotalEnergyProduced(y,r) = sum(dm,z_EnergyProducedByCarrier(y,r,dm));
z_ShareProducedPerCarrier(y,r,'Solar') = z_EnergyProducedByCarrier(y,r,'Solar')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'Wind_Onshore') = z_EnergyProducedByCarrier(y,r,'Wind_Onshore')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'Wind_Offshore') = z_EnergyProducedByCarrier(y,r,'Wind_Offshore')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'Biomass') = z_EnergyProducedByCarrier(y,r,'Biomass')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'Hydro') = z_EnergyProducedByCarrier(y,r,'Hydro')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'HardCoal') = z_EnergyProducedByCarrier(y,r,'HardCoal')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'Lignite') = z_EnergyProducedByCarrier(y,r,'Lignite')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'Oil') = z_EnergyProducedByCarrier(y,r,'Oil')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'Nuclear') = z_EnergyProducedByCarrier(y,r,'Nuclear')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrier(y,r,'Gas') = z_EnergyProducedByCarrier(y,r,'Gas')/z_TotalEnergyProduced(y,r);
*z_ShareProducedPerCarrier(y,r,'Power') = z_EnergyProducedByCarrier(y,r,'Power')/z_TotalEnergyProduced(y,r);
z_ShareProducedPerCarrierWorld(y,dm) = sum(r,z_EnergyProducedByCarrier(y,r,dm))/sum(r,z_TotalEnergyProduced(y,r));
z_ShareProducedPerCarrier(y,'World',dm) = z_ShareProducedPerCarrierWorld(y,dm);

z_TotalEnergyDemand(y,r) = sum(f,SpecifiedAnnualDemand(r,f,y)) + sum(f,z_TransportEnergyDemand(f,r,y));
z_EnergyConsumedPerOutputFuel(y,r,of) =  (SpecifiedAnnualDemand(r,of,y) + z_TransportEnergyDemand(of,r,y)) / z_TotalEnergyDemand(y,r);
z_EnergyConsumedPerOutputFuel(y,'World',of) = sum(r,(SpecifiedAnnualDemand(r,of,y) + z_TransportEnergyDemand(of,r,y))) / sum(r,z_TotalEnergyDemand(y,r));
z_EnergyProducedByCarrier(y,'World',dm) = sum(r,z_EnergyProducedByCarrier(y,r,dm));
z_UnusedCapacityPerRegionEachTS(r,PowerSupply,y,l)$(AvailabilityFactor(r,PowerSupply,y) <> 0) = TotalActivityPerYear.l(r,l,PowerSupply,y)*AvailabilityFactor(r,PowerSupply,y)/CapacityToActivityUnit(r,PowerSupply) - (sum(f,ProductionByTechnology.l(y,l,PowerSupply,f,r))/(CapacityToActivityUnit(r,PowerSupply)*YearSplit(l,y)));
z_UnusedCapacityPerRegion(r,PowerSupply,y) =  sum(l,(z_UnusedCapacityPerRegionEachTS(r,PowerSupply,y,l)*YearSplit(l,y)));
z_UnusedCapacityShare(r,PowerSupply,y)$(TotalCapacityAnnual.l(y,PowerSupply,r) > 0) = z_UnusedCapacityPerRegion(r,PowerSupply,y) / TotalCapacityAnnual.l(y,PowerSupply,r);
z_ModelPeriodEmissionPercent(e) = sum(r,ModelPeriodEmissions.l(e,r))/ModelPeriodEmissionLimit(e)*100;

z_CapacityUsedByTechnologyEachTS(y,l,PowerSupply,r)$(AvailabilityFactor(r,PowerSupply,y) <> 0 and CapacityToActivityUnit(r,PowerSupply) <> 0 and CapacityFactor(r,PowerSupply,l,y) <> 0) = RateOfProductionByTechnology.l(y,l,PowerSupply,'Power',r)*YearSplit(l,y)/(AvailabilityFactor(r,PowerSupply,y)*CapacityToActivityUnit(r,PowerSupply)*CapacityFactor(r,PowerSupply,l,y));
z_PeakCapacityByTechnology(r,PowerSupply,y)$(sum(l,z_CapacityUsedByTechnologyEachTS(y,l,PowerSupply,r)) <> 0) = smax(l, z_CapacityUsedByTechnologyEachTS(y,l,PowerSupply,r));

excel_capacity(r,c,t,y,'PeakCapacity','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = z_PeakCapacityByTechnology(y,t,r) ;
excel_capacity(r,c,t,y,'NewCapacity','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = NewCapacity.l(y,t,r) ;
excel_capacity(r,c,t,y,'ResidualCapacity','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = ResidualCapacity(r,t,y) ;
excel_capacity(r,c,t,y,'TotalCapacity','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = TotalCapacityAnnual.l(y,t,r) ;
excel_capacity(r,c,t,y,'UnusedCapacity','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = z_UnusedCapacityPerRegion(r,t,y) ;
excel_capacity(r,c,t,y,'UnusedPeakCapacity','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = TotalCapacityAnnual.l(y,t,r) - z_PeakCapacityByTechnology(r,t,y);
excel_capacity(r,c,t,y,'UnusedCapacityShare','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = z_UnusedCapacityShare(r,t,y) ;
*excel_capacity(r,'Landuse',t,y,'RateLanduse')$(map_techToCategory(t,'Landuse')) = AccumulatedNewCapacity.l(y,t,r)/(TotalAnnualMaxCapacity(r,t,y) + 0.000000001) ;
*excel_capacity('Total',c,t,y,'RateLanduse') = sum(r,excel_capacity(r,c,t,y,'RateLanduse')) ;
excel_capacity('Total',c,t,y,'NewCapacity','%emissionPathway%_%emissionScenario%') = sum(r,excel_capacity(r,c,t,y,'NewCapacity','%emissionPathway%_%emissionScenario%')) ;
excel_capacity('Total',c,t,y,'ResidualCapacity','%emissionPathway%_%emissionScenario%') = sum(r,excel_capacity(r,c,t,y,'ResidualCapacity','%emissionPathway%_%emissionScenario%')) ;
excel_capacity('Total',c,t,y,'TotalCapacity','%emissionPathway%_%emissionScenario%') = sum(r,excel_capacity(r,c,t,y,'TotalCapacity','%emissionPathway%_%emissionScenario%')) ;
excel_capacity('Total',c,t,y,'UnusedCapacity','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = sum(r,z_UnusedCapacityPerRegion(r,t,y)) ;
excel_capacity('Total',c,t,y,'UnusedCapacityShare','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = sum(r,z_UnusedCapacityShare(r,t,y)) ;
excel_capacity(r,c,t,y,'PotentialUsed','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c) and (TotalAnnualMaxCapacity(r,t,y) > 0)) =  TotalCapacityAnnual.l(y,t,r)/TotalAnnualMaxCapacity(r,t,y);
excel_capacity(TableauCountries,'Tableau','Tableau',y,'Tableau','%emissionPathway%_%emissionScenario%') = 0.123;
excel_production(r,c,t,m,f,y,l,'Production','PJ','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = z_ProductionByTechnologyByMode(r,l,t,m,f,y) ;
excel_production(r,c,t,m,f,y,l,'Use','PJ','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = - z_UseByTechnologyByMode(r,l,t,m,f,y) ;
excel_production(r,'Consuming','Power_Demand','1','Power',y,l,'Use','PJ','%emissionPathway%_%emissionScenario%') = - Demand(y,l,'Power',r) ;
excel_production(r,'Consuming','Heat_Low_Residential_Demand','1','Heat_Low_Residential',y,l,'Use','PJ','%emissionPathway%_%emissionScenario%') = - Demand(y,l,'Heat_Low_Residential',r) ;
excel_production(r,'Consuming','Heat_Low_Industrial_Demand','1','Heat_Low_Industrial',y,l,'Use','PJ','%emissionPathway%_%emissionScenario%') = - Demand(y,l,'Heat_Low_Industrial',r) ;
excel_production(r,'Consuming','Heat_Medium_Industrial_Demand','1','Heat_Medium_Industrial',y,l,'Use','PJ','%emissionPathway%_%emissionScenario%') = - Demand(y,l,'Heat_Medium_Industrial',r) ;
excel_production(r,'Consuming','Heat_High_Industrial_Demand','1','Heat_High_Industrial',y,l,'Use','PJ','%emissionPathway%_%emissionScenario%') = - Demand(y,l,'Heat_High_Industrial',r) ;
excel_production(r,'Trade','Trade','1',f,y,l,'Import','PJ','%emissionPathway%_%emissionScenario%') = sum(rr, Import.l(y,l,f,r,rr)) ;
excel_production(r,'Trade','Trade','1',f,y,l,'Export','PJ','%emissionPathway%_%emissionScenario%') = sum(rr, Export.l(y,l,f,r,rr)) ;
*excel_production(r,c,t,m,f,y,l,'Use','TWh','%emissionPathway%_%emissionScenario%') = excel_production(r,c,t,m,f,y,l,'Use','PJ','%emissionPathway%_%emissionScenario%') * 0.2778;
*excel_production(r,c,t,m,f,y,l,'Production','TWh','%emissionPathway%_%emissionScenario%') = excel_production(r,c,t,m,f,y,l,'Production','PJ','%emissionPathway%_%emissionScenario%') * 0.2778;
*excel_production(TableauCountries,'Tableau','Tableau','1','Tableau','2015','Q1A','Production','PJ','%emissionPathway%_%emissionScenario%') = 0.123;
excel_emission(r,c,e,t,y,'Emissions','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c))  = AnnualTechnologyEmission.l(y,t,e,r)/5;
excel_emission(r,'ExogenousEmissions',e,'ExogenousEmissions',y,'Emissions','%emissionPathway%_%emissionScenario%')  = AnnualExogenousEmission(r,e,y)/5;
*excel_emission(r,c,e,t,y,'Emissions')$(map_techToCategory(t,c) and AnnualTechnologyEmission.l(y,t,e,r) = 0)  = sum(f,z_EmissionsPerTechnologyAnnual(e,y,t,f,r))/5;
excel_emission(r,'Landuse',e,'R_Coal_Hardcoal','2050','Emissions','%emissionPathway%_%emissionScenario%')$(excel_emission(r,'Landuse',e,'R_Coal_Hardcoal','2050','Emissions','%emissionPathway%_%emissionScenario%') = 0)  = 0.001;

excel_costs(r,c,t,y,'Operating Costs','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = DiscountedOperatingCost.l(y,t,r) ;
excel_costs(r,c,t,y,'Capital Investment','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = DiscountedCapitalInvestment.l(y,t,r) ;
excel_costs(r,c,t,y,'Emission Penalty','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = DiscountedTechnologyEmissionsPenalty.l(y,t,r) ;
excel_costs(r,c,t,y,'Salvage Value','%emissionPathway%_%emissionScenario%')$(map_techToCategory(t,c)) = - DiscountedSalvageValue.l(y,t,r) ;
excel_costs('Total','Other Costs','Objective Value',y,'Objective Value','%emissionPathway%_%emissionScenario%') = z.l;
excel_costs(r,'Total','Other Costs',y,'Trade Costs','%emissionPathway%_%emissionScenario%') = DiscountedAnnualTotalTradeCosts.l(y,r) ;
excel_costs(r,'Total','Other Costs',y,'Trade Capacity Expansion Costs','%emissionPathway%_%emissionScenario%') =  sum((f,rr),DiscountedNewTradeCapacityCosts.l(y,f,r,rr)) ;
excel_trade(y,l,f,r,rr,'Import','%emissionPathway%_%emissionScenario%') = Import.l(y,l,f,r,rr) ;
excel_trade(y,l,f,r,rr,'Export','%emissionPathway%_%emissionScenario%') = Export.l(y,l,f,r,rr) ;
excel_trade('2015','Q1A','Tableau',TableauCountries,'Tableau','Tableau','%emissionPathway%_%emissionScenario%') = 0.123;
excel_trade(y,l,f,r,rr,'RelativeImport','%emissionPathway%_%emissionScenario%')$(Production.l(y,l,f,r) > 0) = Import.l(y,l,f,r,rr) / Production.l(y,l,f,r) ;
excel_trade(y,l,f,r,rr,'RelativeExport','%emissionPathway%_%emissionScenario%')$(Production.l(y,l,f,r) > 0) = Export.l(y,l,f,r,rr) / Production.l(y,l,f,r) ;
excel_trade(y,'Annual',f,r,'N/A','NetTrade','%emissionPathway%_%emissionScenario%') = NetTradeAnnual.l(y,f,r) ;
excel_trade(y,'Annual',f,r,'N/A','RelativeNetTrade','%emissionPathway%_%emissionScenario%')$(ProductionAnnual.l(y,f,r) > 0) = NetTradeAnnual.l(y,f,r) / ProductionAnnual.l(y,f,r) ;
excel_share(y,r,dm,'Production','%emissionPathway%_%emissionScenario%') =  z_EnergyProducedByCarrier(y,r,dm);
excel_share(y,'World',dm,'Production','%emissionPathway%_%emissionScenario%') =  z_EnergyProducedByCarrier(y,'World',dm);
excel_share(y,r,of,'Consumption','%emissionPathway%_%emissionScenario%') = z_EnergyConsumedPerOutputFuel(y,r,of);
excel_share(y,'World',of,'Consumption','%emissionPathway%_%emissionScenario%') = z_EnergyConsumedPerOutputFuel(y,'World',of);


z_EmissionOutputPerFuel(r,f,e,y) = sum((t,m),(EmissionContentPerFuel(f,e)*sum(l,z_UseByTechnologyByMode(r,l,t,m,f,y))*EmissionActivityRatio(r,t,e,m,y)));

$include genesysmod_costs.gms
$endif

* Write gdxxrw option file
$onecho >%tempdir%temp_exceloutput.tmp
se=0
text="Region"                            Rng=Capacity!A1
text="Category"                          Rng=Capacity!B1
text="Technology"                        Rng=Capacity!C1
text="Year"                              Rng=Capacity!D1
text="Type"                              Rng=Capacity!E1
text="Scenario"                          Rng=Capacity!F1
text="Value"                             Rng=Capacity!G1
        par=excel_capacity               Rng=Capacity!A2                        rdim=6        cdim=0

text="Region"                            Rng=Production!A1
text="Category"                          Rng=Production!B1
text="Technology"                        Rng=Production!C1
text="Mode"                              Rng=Production!D1
text="Fuel"                              Rng=Production!E1
text="Year"                              Rng=Production!F1
text="Timeslice"                         Rng=Production!G1
text="Type"                              Rng=Production!H1
text="Unit"                              Rng=Production!I1
text="Scenario"                          Rng=Production!J1
text="Value"                             Rng=Production!K1
        par=excel_production             Rng=Production!A2                     rdim=10        cdim=0

text="Region"                            Rng=Emissions!A1
text="Category"                          Rng=Emissions!B1
text="Emission"                          Rng=Emissions!C1
text="Technology"                        Rng=Emissions!D1
text="Year"                              Rng=Emissions!E1
text="Timeslice"                         Rng=Emissions!F1
text="Scenario"                          Rng=Emissions!G1
text="Value"                             Rng=Emissions!H1
        par=excel_emission               Rng=Emissions!A2                      rdim=7        cdim=0

text="Region"                            Rng=Costs!A1
text="Category"                          Rng=Costs!B1
text="Technology"                        Rng=Costs!C1
text="Year"                              Rng=Costs!D1
text="Type"                              Rng=Costs!E1
text="Scenario"                          Rng=Costs!F1
text="Value"                             Rng=Costs!G1
        par=excel_costs                  Rng=Costs!A2                          rdim=6        cdim=0

text="Year"                              Rng=Trade!A1
text="Timeslice"                         Rng=Trade!B1
text="Fuel"                              Rng=Trade!C1
text="From"                              Rng=Trade!D1
text="To"                                Rng=Trade!E1
text="Type "                             Rng=Trade!F1
text="Scenario"                          Rng=Trade!G1
text="Value"                             Rng=Trade!H1
        par=excel_trade                  Rng=Trade!A2                          rdim=7        cdim=0

text="Year"                              Rng=Share!A1
text="Region"                              Rng=Share!B1
text="Carrier"                              Rng=Share!C1
text="Type"                                Rng=Share!D1
text="Scenario"                                Rng=Share!E1
text="Value"                             Rng=Share!F1
        par=excel_share                  Rng=Share!A2                          rdim=5        cdim=0

text="Year"                              Rng=Transport!A1
text="Region"                              Rng=Transport!B1
text="Technology"                              Rng=Transport!C1
text="Mode"                              Rng=Transport!D1
text="Fuel"                                Rng=Transport!E1
text="Scenario"                                Rng=Transport!F1
text="Value"                             Rng=Transport!G1
        par=excel_transport                  Rng=Transport!A2                          rdim=6        cdim=0

text="Region"                              Rng=Sectors!A1
text="Sector"                              Rng=Sectors!B1
text="Fuel"                              Rng=Sectors!C1
text="Year"                              Rng=Sectors!D1
text="Unit"                                Rng=Sectors!E1
text="Scenario"                                Rng=Sectors!F1
text="Value"                             Rng=Sectors!G1
        par=excel_sectors                  Rng=Sectors!A2                          rdim=6        cdim=0



text="Year"                              Rng=LvLCosts!A1
text="Region"                              Rng=LvLCosts!B1
text="Technology"                              Rng=LvLCosts!C1
text="Fuel"                              Rng=LvLCosts!D1
text="Mode of Operation"                                Rng=LvLCosts!E1
text="TimeSlice"                                Rng=LvLCosts!F1
text="Type"                             Rng=LvLCosts!G1
text="Utilization"                             Rng=LvLCosts!H1
text="Value"                             Rng=LvLCosts!I1
        par=excel_lvlcosts                  Rng=LvLCosts!A2                          rdim=8        cdim=0
$offecho

*________________________________________________________________________________________________________
*________Output für Kapazitätsausnutzung_________________________________________________________________

*Display TCC1_TotalAnnualMaxCapacityConstraint.m;
$ifthen %test% == 0

$ifthen set Info
execute_unload "%gdxdir%Output_%model_region%_%emissionPathway%_%emissionScenario%_%info%.gdx"
$else
execute_unload "%gdxdir%Output_%model_region%_%emissionPathway%_%emissionScenario%.gdx"
$endif

excel_capacity
excel_production
excel_emission
excel_costs
excel_trade
excel_share
excel_transport
excel_sectors
excel_lvlcosts
;

$endif

$ifthen %emissionScenario% == all
$call gdxmerge %gdxdir%Output_%model_region%_%emissionPathway%_GlobalLimit.gdx  %gdxdir%Output_%model_region%_%emissionPathway%_ShareByPopulation.gdx %gdxdir%Output_%model_region%_%emissionPathway%_ShareByGDP.gdx %gdxdir%Output_%model_region%_%emissionPathway%_ShareByCurrentEmissions.gdx output= %gdxdir%Output_%model_region%_%emissionPathway%_all.gdx
$onecho >%tempdir%temp_exceloutput.tmp
se=0
text="Merge"                            Rng=Capacity!A1
text="Region"                            Rng=Capacity!B1
text="Category"                          Rng=Capacity!C1
text="Technology"                        Rng=Capacity!D1
text="Year"                              Rng=Capacity!E1
text="Type"                              Rng=Capacity!F1
text="Scenario"                          Rng=Capacity!G1
text="Value"                             Rng=Capacity!H1
        par=excel_capacity               Rng=Capacity!A2                        rdim=7        cdim=0

text="Merge"                            Rng=Production!A1
text="Region"                            Rng=Production!B1
text="Category"                          Rng=Production!C1
text="Technology"                        Rng=Production!D1
text="Mode"                              Rng=Production!E1
text="Fuel"                              Rng=Production!F1
text="Year"                              Rng=Production!G1
text="Timeslice"                         Rng=Production!H1
text="Type"                              Rng=Production!I1
text="Unit"                              Rng=Production!J1
text="Scenario"                          Rng=Production!K1
text="Value"                             Rng=Production!L1
        par=excel_production             Rng=Production!A2                     rdim=11        cdim=0

text="Merge"                            Rng=Emissions!A1
text="Region"                            Rng=Emissions!B1
text="Category"                          Rng=Emissions!C1
text="Emission"                          Rng=Emissions!D1
text="Technology"                        Rng=Emissions!E1
text="Year"                              Rng=Emissions!F1
text="Timeslice"                         Rng=Emissions!G1
text="Scenario"                          Rng=Emissions!H1
text="Value"                             Rng=Emissions!I1
        par=excel_emission               Rng=Emissions!A2                      rdim=8        cdim=0

text="Merge"                            Rng=Costs!A1
text="Region"                            Rng=Costs!B1
text="Category"                          Rng=Costs!C1
text="Technology"                        Rng=Costs!D1
text="Year"                              Rng=Costs!E1
text="Type"                              Rng=Costs!F1
text="Scenario"                          Rng=Costs!G1
text="Value"                             Rng=Costs!H1
        par=excel_costs                  Rng=Costs!A2                          rdim=7        cdim=0

text="Merge"                              Rng=Trade!A1
text="Year"                              Rng=Trade!B1
text="Timeslice"                         Rng=Trade!C1
text="Fuel"                              Rng=Trade!D1
text="From"                              Rng=Trade!E1
text="To"                                Rng=Trade!F1
text="Type "                             Rng=Trade!G1
text="Scenario"                          Rng=Trade!H1
text="Value"                             Rng=Trade!I1
        par=excel_trade                  Rng=Trade!A2                          rdim=8        cdim=0

text="Merge"                              Rng=Share!A1
text="Year"                              Rng=Share!B1
text="Region"                              Rng=Share!C1
text="Carrier"                              Rng=Share!D1
text="Type"                                Rng=Share!E1
text="Scenario"                                Rng=Share!F1
text="Value"                             Rng=Share!G1
        par=excel_share                  Rng=Share!A2                          rdim=6        cdim=0

text="Merge"                             Rng=Transport!A1
text="Year"                              Rng=Transport!B1
text="Region"                              Rng=Transport!C1
text="Technology"                              Rng=Transport!D1
text="Mode"                              Rng=Transport!E1
text="Fuel"                                Rng=Transport!F1
text="Scenario"                                Rng=Transport!G1
text="Value"                             Rng=Transport!H1
        par=excel_transport                  Rng=Transport!A2                          rdim=7        cdim=0

text="Region"                              Rng=Sectors!A1
text="Sector"                              Rng=Sectors!B1
text="Fuel"                              Rng=Sectors!C1
text="Year"                              Rng=Sectors!D1
text="Unit"                                Rng=Sectors!E1
text="Scenario"                                Rng=Sectors!F1
text="Value"                             Rng=Sectors!G1
        par=excel_sectors                  Rng=Sectors!A2                          rdim=6        cdim=0

text="Year"                              Rng=Sectors!A1
text="Region"                              Rng=Sectors!B1
text="Technology"                              Rng=Sectors!C1
text="Fuel"                              Rng=Sectors!D1
text="Mode of Operation"                                Rng=Sectors!E1
text="TimeSlice"                                Rng=Sectors!F1
text="Type"                             Rng=Sectors!G1
text="Utilization"                             Rng=Sectors!H1
text="Value"                             Rng=Sectors!I1
        par=excel_sectors                  Rng=Sectors!A2                          rdim=7        cdim=0

$offecho

$endif

$ifthen %switch_write_output_excel% == 1
$ifthen set info
execute 'gdxxrw.exe i=%gdxdir%Output_%model_region%_%emissionPathway%_%emissionScenario%_%info%.gdx UpdLinks=3 o=%resultdir%Pivot_Output_%model_region%_%emissionPathway%_%emissionScenario%_%info%.xlsx @%tempdir%temp_exceloutput.tmp';
$else
execute 'gdxxrw.exe i=%gdxdir%Output_%model_region%_%emissionPathway%_%emissionScenario%.gdx UpdLinks=3 o=%resultdir%Pivot_Output_%model_region%_%emissionPathway%_%emissionScenario%.xlsx @%tempdir%temp_exceloutput.tmp';
$endif
$endif



