$ifthen %switch_only_write_results% == 0
Parameter Modex_AnnualEmissionsPerRegion;
Modex_AnnualEmissionsPerRegion('Annual CO2 Emissions',r,y,'Gt') = AnnualEmissions.l(y,'CO2',r)/1000;

Parameter Modex_AnnualRenewableProduction;
Modex_AnnualRenewableProduction('Annual Renewable Production',y,'GWh') = sum((t,r)$RETagTechnology(r,t,y), ProductionByTechnologyAnnual.l(y,t,'electricity',r));

Parameter Modex_AnnualTradeBetweenRegions;
Modex_AnnualTradeBetweenRegions('Annual Trade',r,rr,y,'GWh') =  sum(l, Export.l(y,l,'electricity',r,rr));

Parameter Modex_AnnualFixedCost;
Modex_AnnualFixedCost('Annual Fixed Cost',y,'€') = sum((t,r)$(not InfeasabilityTech(t)), AnnualFixedOperatingCost.l(y,t,r))*1000000;

Parameter Modex_AnnualInvestmentCost;
Modex_AnnualInvestmentCost('Annual Investment Cost',y,'€') = (sum((r,t)$(not InfeasabilityTech(t) and not R_Technologies(t)), CapitalInvestment.l(y,t,r) - DiscountedSalvageValue.l(y,t,r)) + sum((r,rr),NewTradeCapacityCosts.l(y,'electricity',r,rr)))*1000000

Parameter Modex_AnnualVariableCost;
Modex_AnnualVariableCost('Annual Variable Cost',y,'€') = (sum((t,r)$(not InfeasabilityTech(t)), AnnualVariableOperatingCost.l(y,t,r) + AnnualTechnologyEmissionsPenalty.l(y,t,r)))*1000000;

Parameter Modex_AnnualStorageCharge;
Modex_AnnualStorageCharge('Annual Storage Charge',r,y,s,'GWh') = sum((t,l)$TechnologyToStorage(y,'1',t,s), RateOfActivity.l(y,l,t,'1',r) * TechnologyToStorage(y,'1',t,s) * YearSplit(l,y));
Modex_AnnualStorageCharge('Annual Storage Charge',r,y,'S_storage_salt cavern_hydrogen','GWh')$(InputActivityRatio(r,'electrolyser_alkaline_electricity','electricity','1',y)) = Modex_AnnualStorageCharge('Annual Storage Charge',r,y,'S_storage_salt cavern_hydrogen','GWh')*InputActivityRatio(r,'electrolyser_alkaline_electricity','electricity','1',y);

Parameter Modex_AnnualStorageDischarge;
Modex_AnnualStorageDischarge('Annual Storage Discharge',r,y,s,'GWh') = sum((t,l)$TechnologyFromStorage(y,'2',t,s), RateOfActivity.l(y,l,t,'2',r) * TechnologyFromStorage(y,'2',t,s) * YearSplit(l,y));
Modex_AnnualStorageDischarge('Annual Storage Discharge',r,y,s,'GWh')$(InputActivityRatio(r,'generator_gas_hydrogen','hydrogen','1',y)) = sum((t,l)$TechnologyFromStorage(y,'2',t,s), RateOfActivity.l(y,l,t,'2',r) * TechnologyFromStorage(y,'2',t,s) * YearSplit(l,y))/(InputActivityRatio(r,'generator_gas_hydrogen','hydrogen','1',y));

Parameter Modex_AnnualStorageLosses;
Modex_AnnualStorageLosses('Annual Storage Losses',r,y,s,'GWh') = Modex_AnnualStorageCharge('Annual Storage Charge',r,y,s,'GWh') - Modex_AnnualStorageDischarge('Annual Storage Discharge',r,y,s,'GWh');

Parameter Modex_AnnualProduction;
Modex_AnnualProduction('Annual Electricity Production',t,r,y,'GWh')$(not StorageDummies(t) and not DummyTechnology(t)) = ProductionByTechnologyAnnual.l(y,t,'electricity',r);

Parameter Modex_Production;
Modex_Production('Electricity Production]',t,r,y,l,'MWh')$(not StorageDummies(t) and not DummyTechnology(t)) = ProductionByTechnology.l(y,l,t,'electricity',r)*1000;

Parameter Modex_TradeBetweenRegion;
Modex_TradeBetweenRegion('Trade',r,rr,y,l,'MWh') = Export.l(y,l,'electricity',r,rr)*1000;

Parameter Modex_StorageCharge;
Modex_StorageCharge('Storage Input',r,s,y,l,'MWh') = (sum(t$TechnologyToStorage(y,'1',t,s), RateOfActivity.l(y,l,t,'1',r) * TechnologyToStorage(y,'1',t,s) * YearSplit(l,y)))*1000;

Parameter Modex_StorageDischarge;
Modex_StorageDischarge('Storage Output',r,s,y,l,'MWh') = (sum(t$TechnologyFromStorage(y,'2',t,s), RateOfActivity.l(y,l,t,'2',r) * TechnologyFromStorage(y,'2',t,s) * YearSplit(l,y)))*1000;

Parameter Modex_StorageLevel;
Modex_StorageLevel('Storage Level',r,s,y,l,'MWh') = StorageLevelTSStart.l(s,y,l,r)*1000;

Parameter Modex_AnnualSlack;
Modex_AnnualSlack('Annual Slack',r,y,'GWh') = ProductionByTechnologyAnnual.l(y,'Infeasability_Power','electricity',r);

Parameter Modex_AnnualCurtailment;
Modex_AnnualCurtailment('Annual Curtailment',r,y,'GWh') = sum(l,Curtailment.l(y,l,'electricity',r));

Parameter Modex_SystemCosts;
Modex_SystemCosts('Total System Costs','€') = sum(y,Modex_AnnualVariableCost('Annual Variable Cost',y,'€') + Modex_AnnualFixedCost('Annual Fixed Cost',y,'€') + Modex_AnnualInvestmentCost('Annual Investment Cost',y,'€'));

Parameter Modex_Capacity;
Modex_Capacity('Capacity',t,r,y,'GW')$(not StorageDummies(t) and sum((m),OutputActivityRatio(r,t,'electricity',m,y))>0) = TotalCapacityAnnual.l(y,t,r);
Modex_Capacity('Capacity',t,r,y,'GWh')$(StorageDummies(t)) = TotalCapacityAnnual.l(y,t,r)*sum(s$(TechnologyToStorage(y,'1',t,s)),StorageMaxChargeRate(r,s));

Parameter Modex_AddedCapacity;
Modex_AddedCapacity('Added Capacity',t,r,y,'GW')$(not StorageDummies(t) and sum((m),OutputActivityRatio(r,t,'electricity',m,y))>0) = NewCapacity.l(y,t,r);
Modex_AddedCapacity('Added Capacity',t,r,y,'GWh')$(StorageDummies(t)) = NewCapacity.l(y,t,r)*sum(s$(TechnologyToStorage(y,'1',t,s)),StorageMaxChargeRate(r,s));

Parameter Modex_TotalTransmissionCapacity;
Modex_TotalTransmissionCapacity('Total Transmission Capacity',r,rr,y,'GW') = TotalTradeCapacity.l(y,'electricity',r,rr)/2;

Parameter Modex_AddedTransmissionCapacity;
Modex_AddedTransmissionCapacity('Added Transmission Capacity',r,rr,y,'GW') = NewTradeCapacity.l(y,'electricity',r,rr)/2;

Parameter Modex_TotalTransmissionCapacityTechnology;
Modex_TotalTransmissionCapacityTechnology('Capacity','transmission_DC_electricity',r,rr,y,'GW')$(TotalAnnualMaxDCTRadeCapacity('electricity',r,rr,y)>0) = TotalAnnualMaxDCTRadeCapacity('electricity',r,rr,y)/2;
Modex_TotalTransmissionCapacityTechnology('Capacity','transmission_hvac_electricity',r,rr,y,'GW') = TotalTradeCapacity.l(y,'electricity',r,rr)/2 - TotalAnnualMaxDCTRadeCapacity('electricity',r,rr,y)/2;

Parameter Modex_AddedTransmissionCapacityTechnology;
Modex_AddedTransmissionCapacityTechnology('Added Capacity','transmission_hvac_electricity',r,rr,y,'GW') = NewTradeCapacity.l(y,'electricity',r,rr)/2;




$ifthen set Info
execute_unload "%gdxdir%output2_%model_region%_%scenario%_%info%.gdx"
$else
execute_unload "%gdxdir%output2_%model_region%_%scenario%.gdx"
$endif
Modex_AnnualEmissionsPerRegion
Modex_AnnualRenewableProduction
Modex_AnnualTradeBetweenRegions
Modex_AnnualFixedCost
Modex_AnnualVariableCost
Modex_AnnualStorageCharge
Modex_AnnualStorageDischarge
Modex_AnnualStorageLosses
Modex_AnnualProduction
Modex_Production
Modex_TradeBetweenRegion
Modex_StorageCharge
Modex_StorageDischarge
Modex_StorageLevel
Modex_AnnualSlack
Modex_AnnualCurtailment
Modex_SystemCosts
Modex_Capacity
Modex_AddedCapacity
Modex_TotalTransmissionCapacityTechnology
Modex_AddedTransmissionCapacityTechnology
Modex_AnnualInvestmentCost
;
$endif

$ifthen set Info
execute "echo 'Parameter','Region','Year','Unit','Value' > %resultdir%Output_AnnualEmissions_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualEmissionsPerRegion format=csv noHeader >> %resultdir%Output_AnnualEmissions_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Year','Unit','Value' > %resultdir%Output_AnnualRenewableProduction_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualRenewableProduction  format=csv noHeader >> %resultdir%Output_AnnualRenewableProduction_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region 1','Region 2','Year','Unit','Value' > %resultdir%Output_AnnualTradeBetweenRegions_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualTradeBetweenRegions format=csv noHeader >> %resultdir%Output_AnnualTradeBetweenRegions_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Year','Unit','Value' > %resultdir%Output_AnnualFixedCost_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualFixedCost format=csv noHeader >> %resultdir%Output_AnnualFixedCost_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Year','Unit','Value' > %resultdir%Output_AnnualInvestmentCost_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualInvestmentCost format=csv noHeader >> %resultdir%Output_AnnualInvestmentCost_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Year','Unit','Value' > %resultdir%Output_AnnualVariableCost_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualVariableCost format=csv noHeader >> %resultdir%Output_AnnualVariableCost_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region','Year','Storage','Unit','Value' > %resultdir%Output_AnnualStorageCharge_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualStorageCharge format=csv noHeader >> %resultdir%Output_AnnualStorageCharge_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region','Year','Storage','Unit','Value' > %resultdir%Output_AnnualStorageDischarge_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualStorageDischarge format=csv noHeader >> %resultdir%Output_AnnualStorageDischarge_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region','Year','Storage','Unit','Value' > %resultdir%Output_AnnualStorageLosses_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualStorageLosses format=csv noHeader >> %resultdir%Output_AnnualStorageLosses_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Technology','Region','Year','Unit','Value' > %resultdir%Output_AnnualProduction_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualProduction format=csv noHeader >> %resultdir%Output_AnnualProduction_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Technology','Region','Year','Hour','Unit','Value' > %resultdir%Output_Production_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_Production format=csv noHeader >> %resultdir%Output_Production_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region 1','Region 2','Year','Hour','Unit','Value' > %resultdir%Output_TradeBetweenRegion_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_TradeBetweenRegion format=csv noHeader >> %resultdir%Output_TradeBetweenRegion_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region','Storage','Year','Hour','Unit','Value' > %resultdir%Output_StorageCharge_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_StorageCharge format=csv noHeader >> %resultdir%Output_StorageCharge_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region','Storage','Year','Hour','Unit','Value' > %resultdir%Output_StorageDischarge_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_StorageDischarge format=csv noHeader >> %resultdir%Output_StorageDischarge_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region','Storage','Year','Hour','Unit','Value' > %resultdir%Output_StorageLevel_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_StorageLevel format=csv noHeader >> %resultdir%Output_StorageLevel_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region','Year','Unit','Value' > %resultdir%Output_AnnualSlack_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualSlack format=csv noHeader >> %resultdir%Output_AnnualSlack_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Region','Year','Unit','Value' > %resultdir%Output_AnnualCurtailment_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AnnualCurtailment format=csv noHeader >> %resultdir%Output_AnnualCurtailment_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Unit','Value' > %resultdir%Output_SystemCosts_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_SystemCosts format=csv noHeader >> %resultdir%Output_SystemCosts_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Technology','Region','Year','Unit','Value' > %resultdir%Output_Capacity_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_Capacity format=csv noHeader >> %resultdir%Output_Capacity_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Technology','Region','Year','Unit','Value' > %resultdir%Output_AddedCapacity_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AddedCapacity format=csv noHeader >> %resultdir%Output_AddedCapacity_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Technology','Region 1','Region 2','Year','Unit','Value' > %resultdir%Output_TotalTransmissionCapacityTechnology_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_TotalTransmissionCapacityTechnology format=csv noHeader >> %resultdir%Output_TotalTransmissionCapacityTechnology_%model_region%_%scenario%_%info%.csv"

execute "echo 'Parameter','Technology','Region 1','Region 2','Year','Unit','Value' > %resultdir%Output_AddedTransmissionCapacityTechnology_%model_region%_%scenario%_%info%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%_%info%.gdx symb=Modex_AddedTransmissionCapacityTechnology format=csv noHeader >> %resultdir%Output_AddedTransmissionCapacityTechnology_%model_region%_%scenario%_%info%.csv"
$else

execute "echo 'Parameter','Region','Year','Unit','Value' > %resultdir%Output_AnnualEmissions_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualEmissionsPerRegion format=csv noHeader >> %resultdir%Output_AnnualEmissions_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Year','Unit','Value' > %resultdir%Output_AnnualRenewableProduction_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualRenewableProduction  format=csv noHeader >> %resultdir%Output_AnnualRenewableProduction_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region 1','Region 2','Year','Unit','Value' > %resultdir%Output_AnnualTradeBetweenRegions_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualTradeBetweenRegions format=csv noHeader >> %resultdir%Output_AnnualTradeBetweenRegions_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Year','Unit','Value' > %resultdir%Output_AnnualFixedCost_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualFixedCost format=csv noHeader >> %resultdir%Output_AnnualFixedCost_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Year','Unit','Value' > %resultdir%Output_AnnualInvestmentCost_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualInvestmentCost format=csv noHeader >> %resultdir%Output_AnnualInvestmentCost_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Year','Unit','Value' > %resultdir%Output_AnnualVariableCost_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualVariableCost format=csv noHeader >> %resultdir%Output_AnnualVariableCost_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region','Year','Storage','Unit','Value' > %resultdir%Output_AnnualStorageCharge_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualStorageCharge format=csv noHeader >> %resultdir%Output_AnnualStorageCharge_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region','Year','Storage','Unit','Value' > %resultdir%Output_AnnualStorageDischarge_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualStorageDischarge format=csv noHeader >> %resultdir%Output_AnnualStorageDischarge_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region','Year','Storage','Unit','Value' > %resultdir%Output_AnnualStorageLosses_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualStorageLosses format=csv noHeader >> %resultdir%Output_AnnualStorageLosses_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Technology','Region','Year','Unit','Value' > %resultdir%Output_AnnualProduction_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualProduction format=csv noHeader >> %resultdir%Output_AnnualProduction_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Technology','Region','Year','Hour','Unit','Value' > %resultdir%Output_Production_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_Production format=csv noHeader >> %resultdir%Output_Production_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region 1','Region 2','Year','Hour','Unit','Value' > %resultdir%Output_TradeBetweenRegion_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_TradeBetweenRegion format=csv noHeader >> %resultdir%Output_TradeBetweenRegion_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region','Storage','Year','Hour','Unit','Value' > %resultdir%Output_StorageCharge_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_StorageCharge format=csv noHeader >> %resultdir%Output_StorageCharge_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region','Storage','Year','Hour','Unit','Value' > %resultdir%Output_StorageDischarge_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_StorageDischarge format=csv noHeader >> %resultdir%Output_StorageDischarge_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region','Storage','Year','Hour','Unit','Value' > %resultdir%Output_StorageLevel_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_StorageLevel format=csv noHeader >> %resultdir%Output_StorageLevel_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region','Year','Unit','Value' > %resultdir%Output_AnnualSlack_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualSlack format=csv noHeader >> %resultdir%Output_AnnualSlack_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Region','Year','Unit','Value' > %resultdir%Output_AnnualCurtailment_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AnnualCurtailment format=csv noHeader >> %resultdir%Output_AnnualCurtailment_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Unit','Value' > %resultdir%Output_SystemCosts_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_SystemCosts format=csv noHeader >> %resultdir%Output_SystemCosts_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Technology','Region','Year','Unit','Value' > %resultdir%Output_Capacity_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_Capacity format=csv noHeader >> %resultdir%Output_Capacity_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Technology','Region','Year','Unit','Value' > %resultdir%Output_AddedCapacity_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AddedCapacity format=csv noHeader >> %resultdir%Output_AddedCapacity_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Technology','Region 1','Region 2','Year','Unit','Value' > %resultdir%Output_TotalTransmissionCapacityTechnology_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_TotalTransmissionCapacityTechnology format=csv noHeader >> %resultdir%Output_TotalTransmissionCapacityTechnology_%model_region%_%scenario%.csv"

execute "echo 'Parameter','Technology','Region 1','Region 2','Year','Unit','Value' > %resultdir%Output_AddedTransmissionCapacityTechnology_%model_region%_%scenario%.csv"
execute "gdxdump %gdxdir%output2_%model_region%_%scenario%.gdx symb=Modex_AddedTransmissionCapacityTechnology format=csv noHeader >> %resultdir%Output_AddedTransmissionCapacityTechnology_%model_region%_%scenario%.csv"
$endif
