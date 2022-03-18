* ############# genesysmod_scenariodata_china.gms ##############
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

$ifthen %scenario% == Base
$endif 

$ifthen %scenario% == RETarget
REMinProductionTarget(r_full,'electricity','2030') = 0.8;
$endif


$ifthen %scenario% == HighDemand
SpecifiedAnnualDemand(r_full,'electricity','2030')$(SpecifiedAnnualDemand(r_full,'electricity','2030')) = SpecifiedAnnualDemand(r_full,'electricity','2030')*1.125;
$endif

$ifthen %scenario% == NoCoal
AvailabilityFactor(r_full,'R_lignite','2030') = 0;
AvailabilityFactor(r_full,'R_hard coal','2030') = 0;
$endif

$ifthen %scenario% == All3
REMinProductionTarget(r_full,'electricity','2030') = 0.8;
SpecifiedAnnualDemand(r_full,'electricity','2030')$(SpecifiedAnnualDemand(r_full,'electricity','2030')) = SpecifiedAnnualDemand(r_full,'electricity','2030')*1.125;
AvailabilityFactor(r_full,'R_lignite','2030') = 0;
AvailabilityFactor(r_full,'R_hard coal','2030') = 0;
$endif

$ifthen %scenario% == LowEmissions
AnnualEmissionLimit('CO2','2030')=73;
$endif

$ifthen %scenario% == HighEmissions
AnnualEmissionLimit('CO2','2030')=123;
$endif
