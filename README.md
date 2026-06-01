# California Futures - SDM and Ecoscape modelling workflows

Here we provide an integrated geospatial modeling framework that combines two complementary workflows: (1) climate-driven Species Distribution Modeling (SDM) and habitat suitability mapping, and (2) functional landscape connectivity modeling under present and future climate scenarios using Ecoscape connectivity model. Together, these workflows provide an end-to-end pipeline for predicting how climate change may alter species distributions, dispersal pathways, and ecological connectivity across landscapes.

The first workflow focuses on Species Distribution Modeling (SDM), where environmental and climatic predictors are used to generate habitat suitability surfaces for current and future climate conditions. These models produce spatially explicit habitat projections across multiple Shared Socioeconomic Pathways (SSP245, SSP370, and SSP585), enabling the identification of suitable habitat shifts under changing climate regimes. The SDM workflow supports automated raster processing, climate scenario handling, suitability map generation, and large-scale geospatial data preparation.

The second workflow uses the habitat suitability outputs from the SDM pipeline as ecological inputs for connectivity modeling. Habitat suitability rasters are combined with permeability or dispersal surfaces to simulate functional habitat connectivity, ecological flow, and dispersal dynamics across landscapes. Using raster-based connectivity algorithms, the framework evaluates how climate-driven habitat changes influence movement pathways, connectivity strength, and landscape fragmentation across multiple future scenarios and time periods.

Together, the SDM and connectivity workflows form a unified ecological forecasting system capable of linking species-climate relationships with landscape-scale dispersal processes. The framework enables users to move seamlessly from climate suitability projections to functional connectivity assessment, providing a robust platform for conservation planning, biodiversity monitoring, climate adaptation research, and ecological resilience analysis.

Key features include:

Integrated SDM and connectivity modeling workflows
Automated processing across SSP245, SSP370, and SSP585 climate scenarios
Habitat suitability modeling using environmental and climate predictors
Functional connectivity and ecological flow simulations
Raster-based landscape permeability and dispersal modeling
Batch processing for large geospatial datasets
GPU/HPC-compatible Python workflows
Support for GeoTIFF and other common raster formats
Reproducible large-scale ecological forecasting pipelines

The repository is designed for researchers, conservation practitioners, spatial ecologists, and climate scientists working on biodiversity conservation, species movement ecology, climate change impacts, and landscape connectivity modeling.
