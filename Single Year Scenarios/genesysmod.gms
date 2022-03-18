* ###################### genesysmod.gms #######################
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



$onuelxref
scalar starttime;
starttime = jnow;

$if not set year                         $setglobal year 2050
$if not set switch_unixPath              $setglobal switch_unixPath 0
$if not set switch_investLimit           $setglobal switch_investLimit 0
$if not set switch_ccs                   $setglobal switch_ccs 0
$if not set switch_ramping               $setglobal switch_ramping 0
$if not set switch_short_term_storage    $setglobal switch_short_term_storage 1
$if not set switch_all_regions           $setglobal switch_all_regions 1
$if not set switch_infeasibility_tech    $setglobal switch_infeasibility_tech 1
$if not set switch_base_year_bounds      $setglobal switch_base_year_bounds 0
$if not set switch_only_load_gdx         $setglobal switch_only_load_gdx 0
$if not set switch_write_output_excel    $setglobal switch_write_output_excel 0
$if not set switch_aggregate_region      $setglobal switch_aggregate_region 0
$if not set switch_test_data_load        $setglobal switch_test_data_load 0
$if not set switch_only_write_results    $setglobal switch_only_write_results 0


$if not set solver                       $setglobal solver gurobi
$if not set model_region                 $setglobal model_region modex
$if not set data_base_region             $setglobal data_base_region DE
$if not set data_file                    $setglobal data_file Data_Modex_ID58
$if not set hourly_data_file             $setglobal hourly_data_file Data_Modex_ID58_hourly
$if not set threads                      $setglobal threads 3
$if not set timeseries                   $setglobal timeseries elmod
$if not set elmod_nthhour                $setglobal elmod_nthhour 49
$if not set elmod_starthour              $setglobal elmod_starthour 1
$if not set elmod_dunkelflaute           $setglobal elmod_dunkelflaute 0

$if not set emissionPathway              $setglobal emissionPathway 2degree
$if not set emissionScenario             $setglobal emissionScenario aggr_e25_n
$if not set scenario                     $setglobal scenario Base

$ifthen %switch_unixPath% == 1
$if not set inputdir                     $setglobal inputdir Inputdata/
$if not set gdxdir                       $setglobal gdxdir GdxFiles/
$if not set tempdir                      $setglobal tempdir TempFiles/
$if not set resultdir                    $setglobal resultdir Results/MODEX/
$else
$if not set inputdir                     $setglobal inputdir Inputdata\
$if not set gdxdir                       $setglobal gdxdir GdxFiles\
$if not set tempdir                      $setglobal tempdir TempFiles\
$if not set resultdir                    $setglobal resultdir Results\MODEX\
$endif

*
* ####### Declarations #############
*

$offlisting
$include genesysmod_dec.gms

*
* ####### Load data from provided excel files #############
*
$offlisting
$include genesysmod_dataload.gms


*
* ####### Settings for model run (Years, Regions, etc) #############
*
$offlisting
$include genesysmod_settings.gms

$ifthen %switch_aggregate_region% == 1
$include genesysmod_aggregate_region.gms
$endif
*
* ####### apply general model bounds #############
*
$offlisting
$include genesysmod_bounds.gms


*
* ####### load additional bounds and data for certain scenarios #############
*
$ifthen exist genesysmod_scenariodata_%model_region%.gms
$include genesysmod_scenariodata_%model_region%.gms
$else
display "HINT: No scenario data for region %model_region% found!";
$endif

TotalAnnualMaxCapacityInvestment(REGION,TECHNOLOGY,y) = 999999999;
TotalAnnualMinCapacityInvestment(REGION,TECHNOLOGY,y) = 0 ;
TotalTechnologyModelPeriodActivityUpperLimit(REGION,TECHNOLOGY) = 999999;
TotalTechnologyModelPeriodActivityLowerLimit(REGION,TECHNOLOGY) = 0;
TotalTechnologyAnnualActivityLowerLimit(REGION,TECHNOLOGY,y) = 0;

$ifthen %switch_test_data_load% == 0
$ifthen %switch_only_write_results% == 0


*
* ####### Including Equations #############
*
$offlisting

$include genesysmod_equ.gms

NewCapacity.fx('2016','geothermal_unknown_heat',r_full)=0;
*ProductionByTechnologyAnnual.fx('2050','generator_gas_hydrogen','electricity','BB')=5;
*
* ####### CPLEX Options #############
*
option
lp = %solver%
limrow = 0
limcol = 0
solprint = off
sysout = off
profile=2
;

$onecho > cplex.opt
threads %threads%
parallelmode -1
lpmethod 4
*names no
*solutiontype 2
quality yes
barobjrng 1e+075
tilim 1000000
$offecho

$onecho > gurobi.opt
threads %threads%
method 2
names no
barhomogeneous 1
timelimit 1000000
numericfocus 3
$offecho

display "switch_investLimit   = %switch_investLimit%";
display "switch_ccs           = %switch_ccs%";
display "switch_ramping       = %switch_ramping%";
display "switch_short_term_storage = %switch_short_term_storage%";
display "switch_all_regions = %switch_all_regions%";
display "switch_infeasibility_tech = %switch_infeasibility_tech%";
display "switch_base_year_bounds = %switch_base_year_bounds%";
display "switch_only_load_gdx = %switch_only_load_gdx%";

display "model_region = %model_region%";
display "data_base_region = %data_base_region%";
display "data_file = %data_file%";
display "hourly_data_file = %hourly_data_file%";
display "solver = %solver%";
display "timeseries = %timeseries%";

display "emissionScenario = %emissionScenario%";
display "emissionPathway = %emissionPathway%";

display "info = %info%";

*
* ####### Model and Solve statements #############
*
model genesys /all
$ifthen %switch_dispatch% == 1
$elseIf %timeseries% == elmod
$ifthen %elmod_nthhour% == 1
$else
-def_scaling_objective
-def_scaling_dummy
-def_scaling_flh
-def_scaling_min
-def_scaling_max
$endif
$else
$endif
/;

genesys.holdfixed = 1;
genesys.optfile = 1;

scalar heapSizeBeforSolve;
heapSizeBeforSolve = heapSize;


solve genesys minimizing z using lp;

scalar heapSizeAfterSolve;
heapSizeAfterSolve = heapSize;

scalar elapsed;
elapsed = (jnow - starttime)*24*3600;

display elapsed,  heapSizeBeforSolve, heapSizeAfterSolve;
$endif
*
* ####### Creating Result Files #############
*
*$include genesysmod_results.gms
$include genesysmod_results_modex.gms

$endif


