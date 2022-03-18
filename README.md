# model_GENESYS_MOD
This repository contains all model development using GENESYS_MOD within the open_MODEX project.

## What is GENeSYS-MOD?


##How to run GENeSYS-MOD

### Install GAMS

1. Choose the GAMS version depending on your system: https://www.gams.com/download/
2. Follow the steps of installation wizard.

*Note: A GAMS licens is required.*

### Set up a framework environment

1. Create a directory with the __project name__ in any convenient location.
2. Download the model from [GitHub](https://github.com/open-modex/model_GENeSYS-MOD) by either:
	- cloning the GENeSYS-MOD GitHub repository, or
	- downloading the zip file and extracting all to the previously created project directory.
	
### Open a model in GAMS

1. Open the main folder (either for single year scenarios or pathway) and create a new text file:
	- name it e.g. as the scenario and
	- change the __file extension__ from __txt__ to __gpr__ (GAMS project file).
2. Open the .gpr file: This will start the GAMS IDE.
3. After the GAMS startup open the genesysmod.gms file.

### Run the model

Run the model by simply pressing __F9__.

### Access results

There are many options, here are two:
1. The open_MODEX result files are placed in the model folder under:
	- __/results/MODEX/__.

### Scenario data

1. Depending on which scenario should be calculated, either the folder __Single Year Scenarios__ or __Scenario Variation Pathways__ needs to be used.
2. If __Single Year Scenarios__ is chosen, the user has the possibility to chose between 9 different scenarios. To do so, two options need to be set depending on the scenario:
	- The __year__ needs to be set to the year of interest at the top of the __genesysmod.gms__ file.
	- Also in the __genesysmod.gms__ file, the scenario needs to be set to the desired one.
3. The different scenarios and specifications for the two options are as following:
	- Baseyear 2016 (year: 2016, Scenario: Base)
	- Baseyear 2030 (year: 2030, Scenario: Base)
	- Baseyear 2050 (year: 2050, Scenario: Base)
	- Scenario Variation Renewable Target (year: 2030, Scenario: RETarget)
	- Scenario Variation Increased Demand (year: 2030, Scenario: HighDemand)
	- Scenario Variation Early Coal Phase-out (year: 2030, Scenario: NoCoal)
	- Scenario Variation Combination of previous three (year: 2030, Scenario: All3)
	- Scenario Variation Reduced Emission Budget (year: 2030, Scenario: LowEmissions)
	- Scenario Variation Increased Emission Budged (year: 2030, Scenario: HighEmissions)