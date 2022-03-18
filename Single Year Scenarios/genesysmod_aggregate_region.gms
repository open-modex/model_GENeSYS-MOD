* ############## genesysmod_aggregate_region.gms ##############
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
* ####### Aggregate Model Region Test #############
*
* Agreegates all regions into one


parameter regions_count;
regions_count = card(r);

SpecifiedAnnualDemand('%model_region%',f,y) = sum(r,SpecifiedAnnualDemand(r,f,y));
SpecifiedDemandProfile('%model_region%',f,l,y) = sum(r,SpecifiedDemandProfile(r,f,l,y))/regions_count;
DepreciationMethod('%model_region%') = DepreciationMethod('%data_base_region%');
CapacityToActivityUnit('%model_region%',t) = CapacityToActivityUnit('%data_base_region%',t);
CapacityFactor('%model_region%',t,l,y) = sum(r,CapacityFactor(r,t,l,y))/regions_count;
AvailabilityFactor('%model_region%',t,y) = AvailabilityFactor('%data_base_region%',t,y);
OperationalLife('%model_region%',t) = OperationalLife('%data_base_region%',t);
ResidualCapacity('%model_region%',t,y) = sum(r,ResidualCapacity(r,t,y));
InputActivityRatio('%model_region%',t,f,m,y) = InputActivityRatio('%data_base_region%',t,f,m,y);
OutputActivityRatio('%model_region%',t,f,m,y) = OutputActivityRatio('%data_base_region%',t,f,m,y);
CapitalCost('%model_region%',t,y) = CapitalCost('%data_base_region%',t,y);
VariableCost('%model_region%',t,m,y) = VariableCost('%data_base_region%',t,m,y);
FixedCost('%model_region%',t,y) = FixedCost('%data_base_region%',t,y);
StorageLevelStart('%model_region%',s) = StorageLevelStart('%data_base_region%',s);
StorageMaxChargeRate('%model_region%',s) = StorageMaxChargeRate('%data_base_region%',s);
StorageMaxDischargeRate('%model_region%',s) = StorageMaxDischargeRate('%data_base_region%',s);
MinStorageCharge('%model_region%',s,y) = MinStorageCharge('%data_base_region%',s,y);
OperationalLifeStorage('%model_region%',s,y) = OperationalLifeStorage('%data_base_region%',s,y);
CapitalCostStorage('%model_region%',s,y) = CapitalCostStorage('%data_base_region%',s,y);
ResidualStorageCapacity('%model_region%',s,y) = sum(r,ResidualStorageCapacity(r,s,y));
TotalAnnualMaxCapacity('%model_region%',t,y) = sum(r,TotalAnnualMaxCapacity(r,t,y));
TotalAnnualMinCapacity('%model_region%',t,y) = sum(r,TotalAnnualMinCapacity(r,t,y));
TotalTechnologyAnnualActivityUpperLimit('%model_region%',t,y) = sum(r,TotalTechnologyAnnualActivityUpperLimit(r,t,y));
TotalTechnologyAnnualActivityLowerLimit('%model_region%',t,y) = sum(r,TotalTechnologyAnnualActivityLowerLimit(r,t,y));
Readin_TotalTechnologyModelPeriodActivityUpperLimit('%model_region%',t) = sum(r,Readin_TotalTechnologyModelPeriodActivityUpperLimit(r,t));
ReserveMarginTagTechnology('%model_region%',t,y) = ReserveMarginTagTechnology('%data_base_region%',t,y);
ReserveMarginTagFuel('%model_region%',f,y) = ReserveMarginTagFuel('%data_base_region%',f,y);
ReserveMargin('%model_region%',y) = ReserveMargin('%data_base_region%',y);
EmissionActivityRatio('%model_region%',t,e,m,y) = EmissionActivityRatio('%data_base_region%',t,e,m,y);
EmissionsPenalty('%model_region%',e,y) = EmissionsPenalty('%data_base_region%',e,y);
EmissionsPenaltyTagTechnology('%model_region%',t,e,y) = EmissionsPenaltyTagTechnology('%data_base_region%',t,e,y);
AnnualExogenousEmission('%model_region%',e,y) = sum(r,AnnualExogenousEmission(r,e,y));
RegionalAnnualEmissionLimit('%model_region%',e,y) = sum(r,RegionalAnnualEmissionLimit(r,e,y));
RegionalModelPeriodEmissionLimit(e,'%model_region%') = sum(r,RegionalModelPeriodEmissionLimit(e,r));

DepreciationMethod('%model_region%') = DepreciationMethod('%data_base_region%');
DiscountRate('%model_region%') = DiscountRate('%data_base_region%');

ModalSplitByFuelAndModalType('%model_region%',f,y,mt) = ModalSplitByFuelAndModalType('%data_base_region%',f,y,mt);

SpecifiedDemandProfile(r,f,l,y)$(SpecifiedDemandProfile(r,f,l,y) > 0) = SpecifiedDemandProfile(r,f,l,y)/sum(ll,SpecifiedDemandProfile(r,f,ll,y));

REGION(REGION_FULL) = no;
REGION('%model_region%') = yes;
