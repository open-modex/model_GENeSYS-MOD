* ################## genesysmod_subsets.gms ###################
*
* GENeSYS-MOD v2.3 [Global Energy System Model]  ~ June 2019
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* Updated to newest OSeMOSYS-Version (2016.08) and further improved with additional equations 2016 - 2019
* by Konstantin L�ffler, Thorsten Burandt, Karlo Hainsch
*
* #############################################################
*
* Copyright 2019 Technische Universit�t Berlin and DIW Berlin
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



set StorageDummies(t);
StorageDummies(t) = no;
StorageDummies('storage_pumped_electricity') = yes;
StorageDummies('storage_battery_electricity') = yes;
StorageDummies('storage_salt cavern_hydrogen') = yes;


set InfeasabilityTech(t);
InfeasabilityTech(t) = no;
InfeasabilityTech('Infeasability_Power') = yes;

set R_Technologies(t);
R_Technologies(t) = no;
R_Technologies('R_air') = yes;
R_Technologies('R_biogas') = yes;
R_Technologies('R_biomass') = yes;
R_Technologies('R_hard coal') = yes;
R_Technologies('R_heat') = yes;
R_Technologies('R_light oil') = yes;
R_Technologies('R_lignite') = yes;
R_Technologies('R_natural gas') = yes;
R_Technologies('R_solar radiation') = yes;
R_Technologies('R_uranium') = yes;
R_Technologies('R_waste') = yes;
R_Technologies('R_water') = yes;
