library(biomod2)
library(terra)
library(sf)
library(usdm)

# Set working directory
setwd("C:/Users/bkavhu/Desktop/Normal")

# Define environmental variables
env_vars <- c(
  "annual_heat_moisture_index.asc",
  "available_water.asc",
  "clay_content.asc",
  "extreme_max_temp.asc",
  "LULC.asc",
  "mean_temp_coldest.asc",
  "relative_humidity.asc",
  "slope.asc",
  "soil_depth.asc",
  "soil_ph.asc",
  "summer_heat_moisture_index.asc",
  "summer_precipitation.asc",
  "winter_precipitation.asc",
  "hargreaves_climate_moisture_index.asc",
  "hargreaves_ref_evapouration.asc",
  "winter_mean_temp.asc",
  "mean_annual_prec.asc",
  "mean_annual_temp.asc"
)

# Load current environmental layers
current_env <- rast(env_vars)

# Define future climate scenarios
future_scenarios <- c(
  "future_SSP245_2041_2060",
  "future_SSP245_2081_2100",
  "future_SSP370_2041_2060",
  "future_SSP370_2081_2100",
  "future_SSP585_2041_2060",
  "future_SSP585_2081_2100"
)

# Define species CSV files
species_files <- c(
  "blueoak_latest_pres_abs3.csv",
  "blackoak_latest_pres_abs3.csv",
  "graypine_latest_pres_abs3.csv",
  "jeffreypine_latest_pres_abs3.csv"
)

# Create output directory
dir.create("Model_Outputs", showWarnings = FALSE)

# Start species loop
for(species_file in species_files){
  
  # Read species data
  d <- read.csv(species_file)
  
  # Derive species name from file name
  species_name <- tools::file_path_sans_ext(basename(species_file))
  species_name <- gsub("_presence_data", "", species_name)
  
  # Create species output folder
  species_dir <- file.path("Model_Outputs", species_name)
  dir.create(species_dir, showWarnings = FALSE)
  
  # Prepare response variables
  myResp <- as.numeric(d$presence)
  myRespXY <- d[, c("X", "Y")]
  
  # Format biomod data
  biomod_data <- BIOMOD_FormatingData(
    resp.var = myResp,
    expl.var = current_env,
    resp.xy = myRespXY,
    resp.name = species_name,
    filter.raster = FALSE
  )
  
  # Define modeling options
  biomod_options <- BIOMOD_ModelingOptions()
  
  # Run models
  biomod_model <- BIOMOD_Modeling(
    biomod_data,
    modeling.id = species_name,
    models = c("RF", "MAXNET", "XGBOOST"),
    bm.options = biomod_options,
    CV.strategy = "random",
    CV.nb.rep = 1,
    CV.perc = 0.7,
    metric.eval = c("TSS", "ROC"),
    prevalence = 0.3,
    var.import = 1,
    seed.val = 100
  )
  
  # Run ensemble models
  biomod_ensemble <- BIOMOD_EnsembleModeling(
    bm.mod = biomod_model,
    models.chosen = "all",
    em.by = "PA+run",
    em.algo = c("EMwmean"),
    metric.select = c("ROC"),
    metric.select.thresh = c(0.8),
    metric.eval = c("TSS", "ROC"),
    var.import = 3
  )
  
  # Current projection
  current_projection <- BIOMOD_Projection(
    bm.mod = biomod_model,
    new.env = current_env,
    proj.name = "current",
    selected.models = "all",
    binary.meth = "ROC",
    output.format = ".img"
  )
  
  # Current ensemble forecast
  current_ensemble <- BIOMOD_EnsembleForecasting(
    bm.em = biomod_ensemble,
    bm.proj = current_projection,
    metric.binary = "all",
    output.format = ".img"
  )
  
  # Save evaluation tables
  eval_table <- get_evaluations(biomod_model)
  saveRDS(eval_table, file.path(species_dir, "model_evaluations.rds"))
  
  # Save variable importance
  var_imp <- get_variables_importance(biomod_model)
  saveRDS(var_imp, file.path(species_dir, "variable_importance.rds"))
  
  # Start future scenario loop
  for(scenario in future_scenarios){
    
    # Load future rasters
    future_files <- file.path(scenario, basename(env_vars))
    future_env <- rast(future_files)
    
    # Future projection
    future_projection <- BIOMOD_Projection(
      bm.mod = biomod_model,
      proj.name = scenario,
      new.env = future_env,
      models.chosen = "all",
      metric.binary = "TSS"
    )
    
    # Ensemble forecast
    future_ensemble <- BIOMOD_EnsembleForecasting(
      bm.em = biomod_ensemble,
      bm.proj = future_projection,
      metric.binary = "all",
      metric.filter = "all",
      output.format = ".img"
    )
    
    # Extract binary predictions
    current_pred <- get_predictions(
      current_ensemble,
      metric.binary = "TSS",
      model.as.col = TRUE
    )
    
    future_pred <- get_predictions(
      future_ensemble,
      metric.binary = "TSS",
      model.as.col = TRUE
    )
    
    # Compute range size changes
    range_change <- BIOMOD_RangeSize(
      proj.current = current_pred,
      proj.future = future_pred
    )
    
    # Save range change object
    saveRDS(
      range_change,
      file.path(species_dir, paste0(scenario, "_range_change.rds"))
    )
    
    # Save raster outputs
    writeRaster(
      range_change$Diff.By.Pixel,
      filename = file.path(species_dir, paste0(scenario, "_range_shift.tif")),
      overwrite = TRUE
    )
    
    print(paste("Completed:", species_name, "-", scenario))
  }
  
  print(paste("Finished species:", species_name))
}

print("All species modeling completed")