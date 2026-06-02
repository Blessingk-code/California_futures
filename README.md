# California Futures project – Supporting repository

**Overview**

This repository contains the supporting scripts, environmental predictor variables, species occurrence data, and connectivity modelling workflows used in the California Futures Project. The repository accompanies a manuscript currently under peer review and is intended to support transparency, reproducibility, and reuse of the analytical workflow developed in this study.

The project investigates future changes in species distributions and functional habitat connectivity under multiple climate change scenarios across California using Species Distribution Modelling (SDM) and EcoScape-based connectivity modelling approaches. The repository includes current and future climate predictor variables, species presence records, SDM scripts, connectivity modelling scripts, and supporting workflows required to reproduce the analyses presented in the manuscript.

**Overview**

This repository contains the supporting scripts, environmental predictor variables, species occurrence data, and connectivity modelling workflows used in the California Futures Project. The repository accompanies a manuscript currently under peer review and is intended to support transparency, reproducibility, and reuse of the analytical workflow developed in this study.

The project investigates future changes in species distributions and functional habitat connectivity under multiple climate change scenarios across California using Species Distribution Modelling (SDM) and EcoScape-based connectivity modelling approaches. The repository includes current and future climate predictor variables, species presence records, SDM scripts, connectivity modelling scripts, and supporting workflows required to reproduce the analyses presented in the manuscript.

**Climate data**

The _climate_varibales directories contains environmental predictor variables used for species distribution modelling, both Current and Future.

The Current folder stores baseline environmental variables used for model calibration. These variables include climatic, environmental, and topographic predictors such as annual mean temperature, precipitation variables, climatic water deficit, solar radiation, heat moisture indices, and terrain-related variables. All raster layers share the same spatial extent, coordinate reference system, and spatial resolution to ensure compatibility during model fitting.

The Future folder contains projected climate variables used to forecast species distributions under future climate scenarios. Future layers are according to Shared Socioeconomic Pathways (SSPs), General Circulation Models (GCMs), and time periods. All future predictor variables should maintain identical naming conventions, spatial resolutions, coordinate systems, and extents relative to the baseline variables to ensure consistency during SDM projection.

Raster formats: .asc.

**Presence data**

The Presence_Data directory contains species occurrence records used for model calibration and evaluation. These datasets are stored as .csv, and sh contain species identifiers and geographic coordinates. Fields include species name, longitude, and latitude. 

**Species distribution modelling scripts**

The SDM script is used to generate species distribution models. The SDM workflow includes environmental variable loading, covariate preprocessing, multicollinearity reduction, recursive feature elimination (RFE), pseudoabsence generation, model calibration, ensemble modelling, model evaluation, future projection, and raster export.

The workflow primarily uses the R packages biomod2, terra, sf, usdm, and randomForest. Current and future habitat suitability maps generated through this workflow form the basis for subsequent connectivity analyses.

Outputs generated from the SDM workflow include habitat suitability maps, ensemble projections, binary suitability rasters, variable importance estimates, and model evaluation statistics.

**Connectivity modelling scripts**

The Connectivity script contains the EcoScape-based connectivity modelling workflow used to evaluate functional habitat connectivity under current and future environmental conditions. The workflow uses habitat suitability outputs generated from the SDM analyses as inputs for connectivity modelling.

The connectivity workflow includes habitat raster loading, resistance or permeability surface generation, seed dispersal simulation, random propagation modelling, and connectivity computation. The workflow is implemented primarily in Python and uses libraries such as torch, numpy, rasterio, geopandas, and pandas. GPU acceleration is optionally supported for large-scale raster processing.

Connectivity outputs include functional connectivity surfaces, corridor maps, dispersal probability rasters, and resistance-weighted movement layers.

**Coordinate reference systems**

All raster and vector datasets used within the workflow should use consistent coordinate reference systems to avoid spatial misalignment and analytical inconsistencies: EPSG:3310 (California Albers). Maintaining consistent projections is particularly important for raster alignment, distance calculations, and connectivity modelling.

**Software requirements**
The SDM workflow was developed using R version 4.2 or higher. Required R packages include:

- biomod2
- terra
- sf
- usdm
- randomForest
- dplyr
- tidyr

The connectivity workflow was developed using Python version 3.10 or higher. Required Python libraries include:

- torch
- numpy
- rasterio
- geopandas
- pandas
- Ecoscape
- scipy


The workflow generates two primary categories of outputs. The first includes SDM outputs such as current suitability maps, future suitability projections, ensemble predictions, binary habitat maps, and model evaluation metrics. The second includes connectivity outputs such as functional connectivity rasters, and corridor surfaces(Flow).

**Reproducibility notes**

To ensure reproducibility, users should maintain identical raster resolutions, coordinate reference systems, and spatial extents across all environmental predictor variables. Variable naming conventions between current and future predictors should remain consistent throughout the workflow. Users are additionally encouraged to preserve the repository folder structure and avoid modifying script dependencies without appropriate documentation.

**Intended use**

This repository is intended to support reproducibility of the California Futures Project and provide supplementary analytical material accompanying the associated manuscript. The repository is also intended to facilitate methodological reuse and adaptation within broader species distribution modelling and functional connectivity research.

**Citation**

If using this repository, please cite the associated manuscript once published. Citation details will be updated following publication.

**Contact**

For questions regarding the workflow, scripts, or repository structure, please contact the repository maintainers through the associated publication or project communication channels.

