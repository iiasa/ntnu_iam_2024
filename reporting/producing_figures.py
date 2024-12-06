import pandas as pd
import matplotlib.pyplot as plt

def main():

    results_version = 'v02'

    path_to_file = f'C:/projects/ntnu_iam_2024/results/{results_version}/results_act_{results_version}.csv'
    path_to_output_folder = f'C:/projects/ntnu_iam_2024/results/{results_version}/figures/'

    sector_electricity = ['coal_ppl', 'gas_ppl','oil_ppl','bio_ppl','hydro_ppl','wind_ppl','solar_PV_ppl','nuclear_ppl','other_ppl']
    sector_non_electric = ['coal_nele','oil_nele' ,'gas_nele','bio_nele','solar_nele','other_nele']
    sector_extraction = ['coal_extr', 'gas_extr', 'oil_extr', 'nuclear_fuel', 'bio_pot', 'hydro_pot', 'wind_pot', 'solar_pot']
    sector_aviation_short = ['aviation_short_jet_a', 'aviation_short_saf', 'aviation_short_electric']
    sector_aviation_long = ['aviation_long_jet_a', 'aviation_long_saf', 'aviation_long_electric']

    sectors = [sector_electricity, sector_non_electric, sector_extraction, sector_aviation_short, sector_aviation_long]
    sector_names = ['Power plants', 'Non-electric', 'Extraction or potential', 'Short-haul aviation', 'Long-haul aviation']
    sector_units = ['PWh', 'PWh', 'PWh', 'Gvkm', 'Gvkm']


    sector_electricity_colors = {
        'coal': 'k',
        'oil': 'gray',
        'gas': 'r',
        'bio': 'g',
        'hydro':'b',
        'wind':'c',
        'solar_pv':'darkorange',
        'nuclear':'violet',
        'other':'gray'
    }

    sector_non_electric_colors = {
        'coal':'k',
        'oil':'gray',
        'gas':'r',
        'bio':'g',
        'solar':'darkorange',
        'other':'gray'
    }

    sector_extraction_colors = {
        'coal':'k',
        'oil': 'gray',
        'gas':'r',
        'bio':'g',
        'hydro':'b',
        'wind':'c',
        'solar':'darkorange',
        'nuclear':'violet'
    }

    sector_aviation_short_colors = {
        'jet_a':'gray',
        'saf':'g',
        'electric':'gold'}

    sector_aviation_long_colors = {
        'jet_a':'gray',
        'saf':'g',
        'electric':'gold'}

    sector_colors = [sector_electricity_colors, sector_non_electric_colors, sector_extraction_colors, sector_aviation_short_colors, sector_aviation_long_colors]

    sector_electricity_legends = {
        'coal_ppl': 'coal',
        'oil_ppl': 'oil',
        'gas_ppl': 'gas',
        'bio_ppl': 'bio',
        'hydro_ppl': 'hydro',
        'wind_ppl': 'wind',
        'solar_PV_ppl': 'solar_pv',
        'nuclear_ppl': 'nuclear',
        'other_ppl': 'other'
    }

    sector_non_electric_legends = {
        'coal_nele':'coal',
        'oil_nele':'oil',
        'gas_nele':'gas',
        'bio_nele':'bio',
        'solar_nele':'solar',
        'other_nele':'other'
    }

    sector_extraction_legends = {
        'coal_extr':'coal',
        'oil_extr': 'oil',
        'gas_extr':'gas',
        'bio_pot':'bio',
        'hydro_pot':'hydro',
        'wind_pot':'wind',
        'solar_pot':'solar',
        'nuclear_fuel':'nuclear'
    }

    sector_aviation_short_legends = {
        'aviation_short_jet_a':'jet_a',
        'aviation_short_saf':'saf',
        'aviation_short_electric':'electric'}

    sector_aviation_long_legends = {
        'aviation_long_jet_a':'jet_a',
        'aviation_long_saf':'saf',
        'aviation_long_electric':'electric'}

    sector_legends = [sector_electricity_legends, sector_non_electric_legends, sector_extraction_legends, sector_aviation_short_legends, sector_aviation_long_legends]

    results = pd.read_csv(path_to_file, delimiter=';')

    list_emission_constraints = ['No', '1000' ,'500', '400', '350', '310', '300', '290']

    for i in range(len(list_emission_constraints)):
        for j in range(len(sectors)):
            scenario = results[['ACT', 'Years', list_emission_constraints[i]]]

            scenario = scenario.pivot(index='ACT', columns='Years', values=list_emission_constraints[i])
            scenario = scenario.loc[sectors[j]]
            scenario = scenario.transpose()
            scenario = scenario.rename(columns=sector_legends[j])

            plt.rcParams.update({'font.size': 18})
            scenario.plot.bar(stacked=True, color=sector_colors[j],figsize=(8, 11))
            plt.title(f'{sector_names[j]} - Constraint: {list_emission_constraints[i]}')
            plt.ylabel(sector_units[j])

            plt.tight_layout()

            plt.savefig(path_to_output_folder + f'{list_emission_constraints[i]}_{sector_names[j]}.png')


    return 0



main()


