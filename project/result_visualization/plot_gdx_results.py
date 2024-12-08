# %%
import gdxpds
from pathlib import Path
import matplotlib.pyplot as plt

root_dir = Path(__file__).parents[2]
# print(root_dir)
model_version = "Al_end_2C"
plot_dir = root_dir / "project" / "result_visualization" / "plots" / model_version
# if not plot_dir.exists():
plot_dir.mkdir(parents=True, exist_ok=True)
# %%
# Load the GDX file
gdx_file = root_dir / "model/" / f"energy_climate_results_{model_version}.gdx"
gdx_data = gdxpds.to_dataframes(gdx_file)

# Access the data
for symbol, df in gdx_data.items():
    # print(f"Symbol: {symbol}")
    # print(df)
    pass
# print(gdx_data.keys())

# %%
# print CO2 emissions over time
EMISS = gdx_data["EMISS"]
print(EMISS)
# plot year_all and Level:
fig, ax = plt.subplots(figsize=(8, 5))
ax.plot(EMISS["year_all"], EMISS["Level"])
ax.set_xticklabels(EMISS["year_all"], rotation=45)
ax.set_xlabel("Year")
ax.set_ylabel("CO2 Emissions in GtCO2")
plt.title(f"CO2 Emissions over time -{model_version}")
plt.show()
# save the plot
fig.savefig(plot_dir / f"CO2_emissions_{model_version}.png")
# %%
# emissions by technology:
EMISS_TECH = gdx_data["EMISS_TECH"]
print(EMISS_TECH)
# plot year_all and Level:
fig, ax = plt.subplots(1, 3, figsize=(15, 5))
fig.suptitle(f"CO2 Emissions by Technology over time -{model_version}")
technologies = gdx_data["technology"]["*"]

for tech in technologies:
    if tech.endswith("extr") or tech.endswith("pot") or tech.endswith("fuel"):
        tech_data = EMISS_TECH[EMISS_TECH["technology"] == tech]
        ax[0].plot(tech_data["year_all"], tech_data["Level"], label=tech)
    elif tech.endswith("ppl"):
        tech_data = EMISS_TECH[EMISS_TECH["technology"] == tech]
        ax[1].plot(tech_data["year_all"], tech_data["Level"], label=tech)
    else:
        tech_data = EMISS_TECH[EMISS_TECH["technology"] == tech]
        ax[2].plot(tech_data["year_all"], tech_data["Level"], label=tech)

for a in ax:
    a.set_xlabel("Year")
    a.set_ylabel("CO2 Emissions in GtCO2")
    a.legend()
plt.show()
fig.savefig(plot_dir / f"CO2_emissions_by_technology_{model_version}.png")
# %%
# aluminum related emissions only
fig, ax = plt.subplots(1, 3, figsize=(15, 5))
fig.suptitle(f"CO2 Emissions by Technology over time -{model_version}")
for tech in technologies:
    tech_emissions = EMISS_TECH[EMISS_TECH["technology"] == tech]
    if tech.endswith("Al_extr"):
        ax[0].plot(tech_emissions["year_all"], tech_emissions["Level"], label=tech)
    if tech.endswith("Al_smelt"):
        ax[1].plot(tech_emissions["year_all"], tech_emissions["Level"], label=tech)
    # if tech.endswith("Al_smelt_inert"):
    #     ax[2].plot(tech_emissions["year_all"], tech_emissions["Level"], label=tech)
    if tech.endswith("Al_prod"):
        ax[2].plot(tech_emissions["year_all"], tech_emissions["Level"], label=tech)
for a in ax:
    a.set_xlabel("Year")
    a.set_ylabel("CO2 Emissions in GtCO2")
    a.legend()
plt.show()
fig.savefig(plot_dir / f"CO2_emissions_by_Al_technology_{model_version}.png")
#
# %%
# plot the relative temperature increase
TATM = gdx_data["TATM"]
# print(TATM)
t = TATM["t"]
# print(t)
years = [(int(i) - 1) * 10 + 2020 for i in t]
for y, t in zip(years, TATM["Level"]):
    # print(y, t)
    pass
# print(years)
# print(TATM['Level'])
fig, ax = plt.subplots()
ax.plot(years, TATM["Level"])
ax.set_xlabel("Year")
ax.set_ylabel("Temperature Increase in °C")
xticks = ax.get_xticks()
ax.set_xticklabels([int(i) for i in ax.get_xticks()], rotation=45)
plt.title(f"Temperature Increase over time -{model_version}")
plt.show()
fig.savefig(plot_dir / f"Temperature_increase_{model_version}.png")
# %%
# the demand by energy level
ACT_DEMAND = gdx_data["INV_DEMAND"]
# the uniwue energy and level keys:
energys = ACT_DEMAND["energy"].unique()
levels = ACT_DEMAND["level"].unique()

fig, ax = plt.subplots(len(energys), len(levels), figsize=(20, 15))
fig.suptitle(f"Demand by energy_level over time -{model_version}")

for ie, energy in enumerate(energys):
    for le, level in enumerate(levels):
        # fetch all rows where [energy is energy and level is level]
        energy_data = ACT_DEMAND[
            (ACT_DEMAND["energy"] == energy) & (ACT_DEMAND["level"] == level)
        ]
        ax[ie, le].plot(
            energy_data["year_all"], energy_data["Level"], label=f"{energy}-{level}"
        )
        ax[ie, le].set_xlabel("Year")
        ax[ie, le].set_ylabel("Indogenous demand in PWh/Gt Al")
        ax[ie, le].legend()
        if energy == "aluminum" and level == "final":
            print(energy_data)

# %%
# the demand by energy level
ACT_DEMAND = gdx_data["ACT_DEMAND"]
# the uniwue energy and level keys:
energys = ACT_DEMAND["energy"].unique()
levels = ACT_DEMAND["level"].unique()

fig, ax = plt.subplots(len(energys), len(levels), figsize=(20, 15))
fig.suptitle(f"Demand by energy_level over time -{model_version}")

for ie, energy in enumerate(energys):
    for le, level in enumerate(levels):
        # fetch all rows where [energy is energy and level is level]
        energy_data = ACT_DEMAND[
            (ACT_DEMAND["energy"] == energy) & (ACT_DEMAND["level"] == level)
        ]
        ax[ie, le].plot(
            energy_data["year_all"], energy_data["Level"], label=f"{energy}-{level}"
        )
        ax[ie, le].set_xlabel("Year")
        ax[ie, le].set_ylabel("Exogenous demand in PWh/Gt Al")
        ax[ie, le].legend()
        if energy == "aluminum" and level == "final":
            # print(energy_data)
            pass

# %%
# the demand by energy level
ACT_DEMAND = gdx_data["TOT_DEMAND"]
print(ACT_DEMAND)
# the uniwue energy and level keys:
energys = ACT_DEMAND["energy"].unique()
levels = ACT_DEMAND["level"].unique()

fig, ax = plt.subplots(len(energys), len(levels), figsize=(20, 15))
fig.suptitle(f"Total demand by energy_level over time -{model_version}")

for ie, energy in enumerate(energys):
    for le, level in enumerate(levels):
        # fetch all rows where [energy is energy and level is level]
        energy_data = ACT_DEMAND[
            (ACT_DEMAND["energy"] == energy) & (ACT_DEMAND["level"] == level)
        ]
        ax[ie, le].plot(
            energy_data["year_all"], energy_data["Level"], label=f"{energy}-{level}"
        )
        ax[ie, le].set_xlabel("Year")
        ax[ie, le].set_ylabel("Combined exogenous and endogenous demand in PWh/Gt Al")
        ax[ie, le].legend()

        if energy == "aluminum" and level == "final":
            # print(energy_data)
            pass


# %%
# additional internal demand for aluminum only
INV_DEMAND = gdx_data["INV_DEMAND"]
fig, ax = plt.subplots(figsize=(8, 5))
Al_data = INV_DEMAND[
    (INV_DEMAND["energy"] == "aluminum") & (INV_DEMAND["level"] == "final")
]
ax.plot(Al_data["year_all"], Al_data["Level"])
ax.set_xlabel("Year")
ax.set_ylabel("Endogeneous AL Demand in Gt")
ax.legend()
# print(Al_data)
plt.title(f"Endogeneous_Al_demand_{model_version}.png")
plt.show()
fig.savefig(plot_dir / f"Endogeneous_Al_demand_{model_version}.png")

# %%
# Exogenous demand for aluminum
ACT_DEMAND = gdx_data["ACT_DEMAND"]
fig, ax = plt.subplots(figsize=(8, 5))
Al_data = ACT_DEMAND[
    (ACT_DEMAND["energy"] == "aluminum") & (ACT_DEMAND["level"] == "final")
]
ax.plot(Al_data["year_all"], Al_data["Level"])
ax.set_xlabel("Year")
ax.set_ylabel("Exogeneous AL Demand in Gt")
ax.legend()
# print(Al_data)
plt.title(f"Exogeneous_Al_demand_{model_version}.png")
plt.show()
fig.savefig(plot_dir / f"Exogeneous_Al_demand_{model_version}.png")

# print(energy_levels)
# %%
# ativity of technology
ACT = gdx_data["ACT"]
# print(ACT)
technologies = gdx_data["technology"]["*"]
fig, ax = plt.subplots()
for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = ACT[ACT["technology"] == tech]
    ax.plot(tech_data["year_all"], tech_data["Level"], label=tech)

    # ax.plot(ACT['year_all'], ACT[tech], label=tech)
# ax.plot(ACT['year_all'], ACT['Level'])
ax.set_xlabel("Year")
ax.set_ylabel("Activity - PWh energy produced")
ax.legend()
# %%
# same as above, but we differentiate between extraction/potential, power plants and the rest:

fig, axs = plt.subplots(1, 3, figsize=(15, 5))
for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = ACT[ACT["technology"] == tech]
    if tech.endswith("extr") or tech.endswith("pot") or tech.endswith("fuel"):
        axs[0].plot(tech_data["year_all"], tech_data["Level"], label=tech)


for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = ACT[ACT["technology"] == tech]
    if tech.endswith("ppl"):
        axs[1].plot(tech_data["year_all"], tech_data["Level"], label=tech)


for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = ACT[ACT["technology"] == tech]
    if (
        not tech.endswith("extr")
        and not tech.endswith("pot")
        and not tech.endswith("ppl")
        and not tech.endswith("fuel")
    ):
        axs[2].plot(tech_data["year_all"], tech_data["Level"], label=tech)

for ax in axs:
    ax.set_xlabel("Year")
    ax.set_ylabel("Activity - PWh energy produced")
    ax.legend()

plt.suptitle(f"Activity of Technologies over time -{model_version}")
plt.show()
fig.savefig(plot_dir / f"Activity_of_technologies_{model_version}.png")

# the activity of aluminum - values:
# print(ACT[ACT["technology"] == "Al_prod"])
# activity of coal as a comparison
# print(ACT[ACT["technology"] == "coal_ppl"])
# %%    aluminum activitys:
fig, ax = plt.subplots(1, 3, figsize=(15, 5))
for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = ACT[ACT["technology"] == tech]
    if tech.endswith("Al_extr"):
        ax[0].plot(tech_data["year_all"], tech_data["Level"], label="Alumina")
    if tech.endswith("Al_smelt"):
        ax[1].plot(tech_data["year_all"], tech_data["Level"], label="Raw aluminum")
    if tech.endswith("Al_prod"):
        ax[2].plot(tech_data["year_all"], tech_data["Level"], label="aluminum products")
for a in ax:
    a.set_xlabel("Year")
    a.set_ylabel("Activity - Gt produced")
    a.legend()
plt.suptitle(f"Activity of Aluminum Technologies over time -{model_version}")
plt.show()
fig.savefig(plot_dir / f"Activity_of_Al_technologies_{model_version}.png")
# %%
# now the construction of new capacities for each technology
CAPNEW = gdx_data["CAP_NEW"]
# print(CAPNEW)
# as before, by technology
fig, ax = plt.subplots()
for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = CAPNEW[CAPNEW["technology"] == tech]
    ax.plot(tech_data["year_all"], tech_data["Level"], label=tech)
ax.legend()


# %%
# now the construction of new capacities for each technology by
# differentiating between extraction/potential, power plants and the rest:
# extraction has no capacity, so we can ignore it
fig, axs = plt.subplots(1, 2, figsize=(15, 5))
fig.suptitle(f"Newly built capacity of Technologies over time - {model_version}")
"""
for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = CAPNEW[CAPNEW['technology'] == tech]
    if tech.endswith('extr') or tech.endswith('pot') or tech.endswith('fuel'):
        ax.plot(tech_data['year_all'], tech_data['Level'], label=tech)
ax.legend()
"""

for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = CAPNEW[CAPNEW["technology"] == tech]
    if tech.endswith("ppl"):
        axs[0].plot(tech_data["year_all"], tech_data["Level"], label=tech)


for tech in technologies:
    # fetch all rows where [technology is tech]
    tech_data = CAPNEW[CAPNEW["technology"] == tech]
    if (
        not tech.endswith("extr")
        and not tech.endswith("pot")
        and not tech.endswith("ppl")
        and not tech.endswith("fuel")
    ):
        axs[1].plot(tech_data["year_all"], tech_data["Level"], label=tech)

for ax in axs:
    ax.set_xlabel("Year")
    ax.set_ylabel("Newly built capacity - PW")
    ax.legend()


plt.show()
fig.savefig(plot_dir / f"Newly_built_capacity_of_technologies_{model_version}.png")
# %% costs annualy
COST_ANNUAL = gdx_data["COST_ANNUAL"]
print(COST_ANNUAL)
fig, ax = plt.subplots()
ax.plot(COST_ANNUAL["year_all"], COST_ANNUAL["Level"])
ax.set_ylim(0, 1.1 * max(COST_ANNUAL["Level"]))
ax.set_xlabel("Year")
ax.set_ylabel("Costs in Trillion $")
plt.title(f"Costs over time - {model_version}")
plt.show()
fig.savefig(plot_dir / f"Total costs_{model_version}.png")
# %%


# %%
