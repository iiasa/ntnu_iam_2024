# %%
import gdxpds
from pathlib import Path
import matplotlib.pyplot as plt

root_dir = Path(__file__).parents[2]

Al_model_version = "Al_end"
base_model_version = "Al_ex"
# %%
# Load the GDX file
Al_gdx_file = root_dir / "model/" / f"energy_climate_results_{Al_model_version}.gdx"
Al_gdx_data = gdxpds.to_dataframes(Al_gdx_file)

base_gdx_file = root_dir / "model/" / f"energy_climate_results_{base_model_version}.gdx"
base_gdx_data = gdxpds.to_dataframes(base_gdx_file)

# %%
EMISS_Al = Al_gdx_data["EMISS"]
EMISS_base = base_gdx_data["EMISS"]

EMISS_diff = EMISS_Al["Level"] - EMISS_base["Level"]
fig, ax = plt.subplots()
ax.plot(EMISS_Al["year_all"], EMISS_diff)
print(EMISS_diff)
ax.set_xticklabels(EMISS_Al["year_all"], rotation=45)
ax.set_xlabel("Year")
ax.set_ylabel("CO2 Emissions in GtCO2")
name = "base scenario"
plt.title(f"Al caused increase in  CO2 Emissions over time - {name}")
plt.show()
fig.savefig(
    root_dir
    / "project"
    / "result_visualization"
    / "plots"
    / f"CO2_Al_increase_{name}_.png"
)
# %%
