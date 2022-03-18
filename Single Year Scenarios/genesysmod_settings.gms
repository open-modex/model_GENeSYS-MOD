* ################## genesysmod_settings.gms ##################
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



* ################### CHOOSE CALCULATED YEARS ###################
***  TO LEAVE OUT A CERTAIN YEAR, REMOVE COMMENT OF RESPECTIVE LINE ***
$ifthen %year%==2016
*y('2015') = no;
*y('2016') = no;
*y('2020') = no;
*y('2025') = no;
y('2030') = no;
*y('2035') = no;
*y('2040') = no;
*y('2045') = no;
y('2050') = no;
$elseif %year%==2030
*y('2015') = no;
y('2016') = no;
*y('2020') = no;
*y('2025') = no;
*y('2030') = no;
*y('2035') = no;
*y('2040') = no;
*y('2045') = no;
y('2050') = no;
$elseif %year%==2050
*y('2015') = no;
y('2016') = no;
*y('2020') = no;
*y('2025') = no;
y('2030') = no;
*y('2035') = no;
*y('2040') = no;
*y('2045') = no;
*y('2050') = no;
$endif


* ################### OTHER GENERAL INPUTS ###################

DepreciationMethod(r) = 1;
DiscountRate(r) = 0.07;
*DaysInDayType(y,ls,ld) = 7;

scalar InvestmentLimit /0.35/;
scalar PowerStability /0.25/;
scalar NewRESCapacity /0.33/;

