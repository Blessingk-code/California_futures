import os
from pathlib import Path

import ecoscape_connectivity
from ecoscape_connectivity import compute_connectivity


# Define root project directory
PROJECT_DIR = Path("C:/Users/bkavhu/Desktop/EcoScape_Project")


# Define habitat species rasters
species_rasters = {
    "blueoak": "species/blueoak/current_habitat.tif",
    "blackoak": "species/blackoak/current_habitat.tif",
    "graypine": "species/graypine/current_habitat.tif",
    "jeffreypine": "species/jeffreypine/current_habitat.tif"
}


# Define permeability rasters
permeability_rasters = {
    "blueoak": "permeability/blueoak/current_permeability.tif",
    "blackoak": "permeability/blackoak/current_permeability.tif",
    "graypine": "permeability/graypine/current_permeability.tif",
    "jeffreypine": "permeability/jeffreypine/current_permeability.tif"
}


# Define future climate scenarios
future_scenarios = [
    "current",
    "SSP245_2041_2060",
    "SSP245_2081_2100",
    "SSP370_2041_2060",
    "SSP370_2081_2100",
    "SSP585_2041_2060",
    "SSP585_2081_2100"
]


# Connectivity settings
DISPERSAL_DISTANCE = ####
NUM_SIMULATIONS = 1000
SEED_DENSITY = 2####
TILE_SIZE = 1000
BORDER_SIZE = ####


# Create output directory
OUTPUT_DIR = PROJECT_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def run_connectivity(
    habitat_raster,
    permeability_raster,
    connectivity_output,
    flow_output
):

    compute_connectivity(
        habitat_fn=str(habitat_raster),
        connectivity_fn=str(connectivity_output),
        flow_fn=str(flow_output),
        permeability_fn=str(permeability_raster),
        dispersal=ecoscape_connectivity.half_cauchy(
            DISPERSAL_DISTANCE,
            DISPERSAL_DISTANCE * 5
        ),
        num_simulations=NUM_SIMULATIONS,
        seed_density=SEED_DENSITY,
        tile_size=TILE_SIZE,
        border_size=BORDER_SIZE
    )


# Start species loop
for species_name in species_rasters.keys():

    print(f"\nRunning species: {species_name}")

    species_output_dir = OUTPUT_DIR / species_name
    species_output_dir.mkdir(exist_ok=True)

    # Start scenario loop
    for scenario in future_scenarios:

        print(f"Processing scenario: {scenario}")

        # Current scenario
        if scenario == "current":

            habitat_raster = PROJECT_DIR / species_rasters[species_name]

            permeability_raster = (
                PROJECT_DIR /
                permeability_rasters[species_name]
            )

        # Future scenarios
        else:

            habitat_raster = (
                PROJECT_DIR /
                f"species/{species_name}/{scenario}_habitat.tif"
            )

            permeability_raster = (
                PROJECT_DIR /
                f"permeability/{species_name}/{scenario}_permeability.tif"
            )

        # Define outputs
        connectivity_output = (
            species_output_dir /
            f"{species_name}_{scenario}_connectivity.tif"
        )

        flow_output = (
            species_output_dir /
            f"{species_name}_{scenario}_flow.tif"
        )

        # Skip missing files
        if not habitat_raster.exists():

            print(f"Missing habitat raster: {habitat_raster}")
            continue

        if not permeability_raster.exists():

            print(f"Missing permeability raster: {permeability_raster}")
            continue

        # Run connectivity
        try:

            run_connectivity(
                habitat_raster,
                permeability_raster,
                connectivity_output,
                flow_output
            )

            print(
                f"Completed: "
                f"{species_name} | {scenario}"
            )

        except Exception as e:

            print(
                f"Failed: "
                f"{species_name} | {scenario}"
            )

            print(str(e))


print("\nAll connectivity analyses completed.")