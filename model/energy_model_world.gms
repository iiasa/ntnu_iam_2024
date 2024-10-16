* energy model GAMS

* ------------------------------------------------------------------------------
* set definitions
* ------------------------------------------------------------------------------

* Definition of indices (sets in GAMS) for technologies, energy carriers, energy levels and periods

SET technology          'technologies'
    /
      coal_extr         'coal extraction'
      gas_extr          'natural gas extraction'
      oil_extr          'crude oil extraction'
      nuclear_fuel      'nuclear fuel for light water reactors'
      bio_pot           'bioenergy potential'
      hydro_pot         'hydropower potential'
      wind_pot          'wind potential'
      solar_pot         'solar energy potential'
      coal_ppl          'coal power plant'
      gas_ppl           'natural gas combined cycle power plant'
      oil_ppl           'fuel oil power plant'
      bio_ppl           'biomass power plant'
      hydro_ppl         'hydroelectric power plant'
      wind_ppl          'wind turbine'
      solar_PV_ppl      'solar photovoltaics power plant'
      nuclear_ppl       'nuclear_ppl power plant'
      other_ppl             'other_ppl power plants'
      coal_nele         'non-electric coal'
      oil_nele          'non-electric oil'
      gas_nele          'non-electric gas'
      bio_nele          'non-electric biomass'
      solar_nele        'non-electric solar'
      other_nele        'non-electric other_ppl'
      electricity_grid  'electricity grid'
      appliances        'electric appliances (other_ppl electricity consumption)'
    /

    energy              'energy carriers'
    / coal
      gas
      oil
      biomass
      nuclear
      hydro
      wind
      solar
      electricity
      nonelectric /

    level               'energy level'
    / primary
      secondary
      final
      useful /

    energy_level(energy, level)    'combinations of energy carriers and levels'
    / hydro.primary
      wind.primary
      nuclear.primary
      coal.final
      oil.final
      gas.final
      biomass.final
      solar.final
      electricity.secondary
      electricity.final
      electricity.useful
      nonelectric.useful /

    year                'periods'
    / 2020
      2030
      2040
      2050
      2060
      2070
      2080 /

    share      'technology share set'
    / coal_nonelectric /

    tec_share(share, technology)      'technology share left hand side'
    / coal_nonelectric.coal_nele /
    
    tec_share_rhs(share, technology)  'technology share right hand side'
    / coal_nonelectric.coal_nele
      coal_nonelectric.gas_nele
      coal_nonelectric.oil_nele
      coal_nonelectric.bio_nele
      coal_nonelectric.solar_nele
      coal_nonelectric.other_nele /
;

ALIAS (year, year_alias) ;

* ------------------------------------------------------------------------------
* parameter definitions
* ------------------------------------------------------------------------------

PARAMETERS
    period_length
    / 10 /
    
    input(technology, energy, level)         'input coefficients'
    / electricity_grid.electricity.secondary 1
      appliances.electricity.final           1
      coal_ppl.coal.final                    2.5
      gas_ppl.gas.final                      1.81
      oil_ppl.oil.final                      2
      bio_ppl.biomass.final                  3
      nuclear_ppl.nuclear.primary            1
      hydro_ppl.hydro.primary                1
      wind_ppl.wind.primary                  1
      solar_PV_ppl.solar.final               1
      coal_nele.coal.final                   1
      oil_nele.oil.final                     1
      gas_nele.gas.final                     1
      bio_nele.biomass.final                 1
      solar_nele.solar.final                 1
    /

    output(technology, energy, level)        'output coefficients'
    / electricity_grid.electricity.final     0.85
      appliances.electricity.useful          1
      coal_ppl.electricity.secondary         1
      gas_ppl.electricity.secondary          1
      oil_ppl.electricity.secondary          1
      bio_ppl.electricity.secondary          1
      hydro_ppl.electricity.secondary        1
      wind_ppl.electricity.secondary         1
      solar_PV_ppl.electricity.final         1
      nuclear_ppl.electricity.secondary      1
      other_ppl.electricity.secondary        1
      coal_nele.nonelectric.useful           1
      oil_nele.nonelectric.useful            1
      gas_nele.nonelectric.useful            1
      bio_nele.nonelectric.useful            1
      solar_nele.nonelectric.useful          1
      other_nele.nonelectric.useful          1
      coal_extr.coal.final                   1
      gas_extr.gas.final                     1
      oil_extr.oil.final                     1
      nuclear_fuel.nuclear.primary           1
      bio_pot.biomass.final                  1
      hydro_pot.hydro.primary                1
      wind_pot.wind.primary                  1
      solar_pot.solar.final                  1
    /

    CO2_emission(technology)                 'specific CO2 emission coefficients [tCO2/MWh]'
    / gas_ppl      0.367
      coal_ppl     0.854
      oil_ppl      0.57
      coal_nele    0.342
      oil_nele     0.202
      gas_nele     0.26
    /

    diffusion_up(technology)                  'maximum annual technology capacity growth rate'
    / coal_ppl     0.075
      gas_ppl      0.10
      oil_ppl      0.075
      bio_ppl      0.075
      hydro_ppl    0.05
      wind_ppl     0.10
      solar_PV_ppl 0.15
      nuclear_ppl  0.05
      other_ppl    0.075
      coal_nele    0.075
      oil_nele     0.075
      gas_nele     0.10
      bio_nele     0.075
      solar_nele   0.15
      other_nele   0.075
      coal_extr    0.05
      gas_extr     0.05
      oil_extr     0.05
      nuclear_fuel 0.05
      bio_pot      0.05
    /

    startup(technology)                  'maximum technology capacity constant addition per period'
    / coal_ppl     1
      gas_ppl      1
      oil_ppl      1
      bio_ppl      1
      hydro_ppl    1
      wind_ppl     1
      solar_PV_ppl 1
      nuclear_ppl  1
      other_ppl    1
      coal_nele    1
      oil_nele     1
      gas_nele     1
      bio_nele     1
      solar_nele   1
      other_nele   1
      coal_extr    1
      gas_extr     1
      oil_extr     1
      nuclear_fuel 1
      bio_pot      1
    /

    demand(energy, level)                    'demand in base year [TWh]'
    / electricity.useful        100
      nonelectric.useful        400 /

    gdp(year)                                'GDP [index]'
    / 2020  1
      2030  1.2
      2040  1.4
      2050  1.7
      2060  2.0
      2070  2.4
      2080  2.9 /

    discount_rate                            'discount rate'
    / 0.05 /

    beta                                     'income elasticity'
    / 0.7 /

    share_up(share)                          'upper share of techology groups relative to reference group'  
    / coal_nonelectric 0.4 /

    share_lo(share)                          'lower share of techology groups relative to reference group'  
    / coal_nonelectric 0 /
;

TABLE
    inv(technology, year)                    'investment cost [$/kW]'
                            2020    2030    2040    2050    2060    2070    2080
    coal_ppl                1500    1500    1500    1500    1500    1500    1500
    gas_ppl                  800     800     800     800     800     800     800
    oil_ppl                  950     950     950     950     950     950     950
    hydro_ppl               3000    3000    3000    3000    3000    3000    3000
    bio_ppl                 1600    1600    1600    1600    1600    1600    1600
    wind_ppl                1000    1000    1000    1000    1000    1000    1000
    solar_PV_ppl            4000    4000    4000    4000    4000    4000    4000
    nuclear_ppl             6000    6000    6000    6000    6000    6000    6000
    other_ppl               4000    4000    4000    4000    4000    4000    4000
;

TABLE
    fom(technology, year)                    'fixed operation and maintenance cost [$/(kW/yr)]'
                            2020    2030    2040    2050    2060    2070    2080
    coal_ppl                  40      40      40      40      40      40      40
    gas_ppl                   25      25      25      25      25      25      25
    oil_ppl                   25      25      25      25      25      25      25
    bio_ppl                   60      60      60      60      60      60      60
    hydro_ppl                 30      30      30      30      30      30      30
    wind_ppl                  40      40      40      40      40      40      20
    solar_PV_ppl              25      25      25      25      25      25      25
    nuclear_ppl              100     100     100     100     100     100     100
    other_ppl                 25      25      25      25      25      25      25
;

TABLE
    vom(technology, year)                    'variable cost [$/MWh]'
                            2020    2030    2040    2050    2060    2070    2080
    coal_ppl                0.0     0.0     0.0     0.0     0.0     0.0     0.0
    gas_ppl                 0.0     0.0     0.0     0.0     0.0     0.0     0.0
    oil_ppl                 0.0     0.0     0.0     0.0     0.0     0.0     0.0
    bio_ppl                 0.0     0.0     0.0     0.0     0.0     0.0     0.0
    nuclear_ppl             0.0     0.0     0.0     0.0     0.0     0.0     0.0
    electricity_grid        47.8    47.8    47.8    47.8    47.8    47.8    47.8
    coal_nele               0.0     0.0     0.0     0.0     0.0     0.0     0.0
    gas_nele                0.0     0.0     0.0     0.0     0.0     0.0     0.0
    oil_nele                0.0     0.0     0.0     0.0     0.0     0.0     0.0
    bio_nele                0.0     0.0     0.0     0.0     0.0     0.0     0.0
    solar_nele              0.0     0.0     0.0     0.0     0.0     0.0     0.0
    other_nele              0.0     0.0     0.0     0.0     0.0     0.0     0.0
    coal_extr               7.2     7.2     7.2     7.2     7.2     7.2     7.2
    gas_extr                14.4    14.4    14.4    14.4    14.4    14.4    14.4
    oil_extr                40.0    40.0    40.0    40.0    40.0    40.0    40.0
    nuclear_fuel            10.0    10.0    10.0    10.0    10.0    10.0    10.0
    bio_pot                 18.0    18.0    18.0    18.0    18.0    18.0    18.0
    hydro_pot               0.0     0.0     0.0     0.0     0.0     0.0     0.0
    wind_pot                0.0     0.0     0.0     0.0     0.0     0.0     0.0
    solar_pot               0.0     0.0     0.0     0.0     0.0     0.0     0.0
;

PARAMETER lifetime(technology)               'technical lifetime'
    /
    coal_ppl     20
    gas_ppl      20
    oil_ppl      20
    bio_ppl      20
    hydro_ppl    40
    wind_ppl     15
    solar_PV_ppl 20
    nuclear_ppl  40
    other_ppl    20
    coal_nele    20
    oil_nele     20
    gas_nele     20
    bio_nele     20
    solar_nele   20
    other_nele   20
/ ;

PARAMETER hours(technology)                  'full load hours'
    /
    coal_ppl     7000
    gas_ppl      6000
    oil_ppl      6000
    bio_ppl      6000
    hydro_ppl    4500
    wind_ppl     2000
    solar_PV_ppl 1200
    nuclear_ppl  7500
    other_ppl    4000
    coal_nele    7000
    oil_nele     7000
    gas_nele     7000
    bio_nele     7000
    solar_nele   7000
    other_nele   7000
/ ;

PARAMETER cost(technology, year)                 'total technology costs on activity basis [$/MWh]'
          cost_capacity(technology, year)        'annuity of capacity-related investment costs [$/MW]'
          cost_activity(technology, year)        'activity-related technology costs [$/MWh]'
;

cost_capacity(technology, year) =  ((inv(technology, year) * ((1 + discount_rate)**(lifetime(technology)) * discount_rate) / ((1 + discount_rate)**(lifetime(technology)) - 1)
                         + fom(technology, year))) * 1000 $ (lifetime(technology) > 0) ;

cost_activity(technology, year) =  vom(technology, year) ;

cost(technology, year) =  ((inv(technology, year) * ((1 + discount_rate)**(lifetime(technology)) * discount_rate) / ((1 + discount_rate)**(lifetime(technology)) - 1)
                         + fom(technology, year)) / (hours(technology)/1000)) $ (lifetime(technology) > 0)
                         + vom(technology, year) ;

DISPLAY cost, cost_capacity, cost_activity ;

* ------------------------------------------------------------------------------
* variables and equations
* ------------------------------------------------------------------------------

* definition of variables that are part of the optimization

VARIABLES
    ACT(technology, year)       'technology acitvity in period year'
    CAP_NEW(technology, year)   'new technology capacity built in period year'
    EMISS(year)                 'CO2 emissions in period year'
    CUM_EMISS                   'cumulative CO2 emissions'
    COST_ANNUAL(year)           'costs per year'
    TOTAL_COST                  'total discounted systems costs'
;

* declaration of equations

EQUATIONS
    EQ_ENERGY_BALANCE          'supply > demand equation for energy carrier and level combination'
    EQ_CAPACITY_BALANCE        'capacity equation for technologies'
    EQ_EMISSION                'summation of CO2 emissions'
    EQ_EMISSION_CUMULATIVE     'cumulative CO2 emissions'
    EQ_DIFFUSION_UP            'upper technology capacity diffusion constraint'
    EQ_COST_ANNUAL             'costs per year'
    EQ_COST                    'summation of total systems costs'
;

* definition of equations

EQ_ENERGY_BALANCE(energy, level, year) $ energy_level(energy, level)..
    SUM(technology, ACT(technology, year) * (output(technology, energy, level) - input(technology, energy, level)))
  - demand(energy, level) * (gdp(year)/gdp('2020'))**beta =G= 0 ;

EQ_CAPACITY_BALANCE(technology, year) $ hours(technology)..
    SUM(year_alias $ ((ORD(year_alias) LE ORD(year)) AND ((ORD(year) - ORD(year_alias)) * period_length) LE lifetime(technology)), CAP_NEW(technology, year_alias) * MIN((lifetime(technology) - (ORD(year) - ORD(year_alias)) * period_length) / period_length, 1)) * hours(technology) =G= ACT(technology, year) ;

EQ_EMISSION(year)..
    SUM(technology, ACT(technology, year) * CO2_emission(technology)) =E= EMISS(year) ;

EQ_EMISSION_CUMULATIVE..  
    SUM(year, EMISS(year) * period_length) =E= CUM_EMISS ;

EQ_DIFFUSION_UP(technology, year) $ ((NOT ORD(year) = 1) AND diffusion_up(technology))..
    CAP_NEW(technology, year) =L= CAP_NEW(technology, year - 1) * (1 + diffusion_up(technology))**period_length + startup(technology) ;

EQ_COST_ANNUAL(year)..
    SUM(technology, cost_activity(technology, year) * ACT(technology, year))
  + SUM(technology, cost_capacity(technology, year) * CAP_NEW(technology, year) * SUM(year_alias $ ((ORD(year_alias) GE ORD(year)) AND ((ORD(year_alias) - ORD(year)) * period_length) LE lifetime(technology)), MIN((lifetime(technology) - (ORD(year_alias) - ORD(year)) * period_length), period_length)))
=E= COST_ANNUAL(year) ;

EQ_COST..
    SUM(year, COST_ANNUAL(year) * period_length * (1 - discount_rate)**(period_length * (ORD(year) - 1)))
=E= TOTAL_COST ;

* definition of model (keyword 'all' means that all equations defined above are part of the model)

MODEL simple / all / ;

* constraint on individual variables

ACT.LO(technology, year) = 0 ;
CAP_NEW.LO(technology, year) = 0 ;

* ------------------------------------------------------------------------------
* model calibration and resource constraints
* ------------------------------------------------------------------------------


* ------------------------------------------------------------------------------
* model solution
* ------------------------------------------------------------------------------

OPTION LP = CPLEX ;

SOLVE simple using LP minimize TOTAL_COST ;

* ------------------------------------------------------------------------------
* export of results in GDX format
* ------------------------------------------------------------------------------

execute_unload "model_results.gdx"
*execute "model_results.gdx"

* ------------------------------------------------------------------------------
* export of resuls in csv format
* ------------------------------------------------------------------------------

* file name
FILE model_output / "model_results.csv" / ;

* options for output format
model_output.lw = 0 ;
model_output.sw = 0 ;
* numeric field width
model_output.nw = 12 ;
* scientific notation
model_output.nr = 2 ;
* number of decimals
model_output.nd = 4 ;
* page control
model_output.pc = 2 ;

PUT model_output ;

* File Header contains name of scenario and execution date and time
model_output.pc = 2 ;
PUT system.title/ system.date, ' ', system.time/ ;

* data output mode for csv-type file
model_output.pc = 5 ;

PUT model_output ;

* ------------------------------------------------------------------------------
* electtricity generation
* ------------------------------------------------------------------------------

PUT / 'electricity generation', 'TWh'/ ;

PUT '', 'Coal', 'Gas', 'Oil', 'Biomass', 'Hydro', 'Wind', 'Solar', 'Nuclear', 'Other' / ;
LOOP(year,
        PUT year.tl,
            (ACT.L('coal_ppl', year)),
            (ACT.L('gas_ppl', year)),
            (ACT.L('oil_ppl', year)),
            (ACT.L('bio_ppl', year)),
            (ACT.L('hydro_ppl', year)),
            (ACT.L('wind_ppl', year)),
            (ACT.L('solar_PV_ppl', year)),
            (ACT.L('nuclear_ppl', year)),
            (ACT.L('other_ppl', year)) /
) ;

* ------------------------------------------------------------------------------
* new capacity
* ------------------------------------------------------------------------------

PUT / 'new capacity', 'GW'/ ;

PUT '', 'Coal', 'Gas', 'Oil', 'Biomass', 'Hydro', 'Wind', 'Solar', 'nuclear', 'other' / ;
LOOP(year,
        PUT year.tl,
            (CAP_NEW.L('coal_ppl', year)),
            (CAP_NEW.L('gas_ppl', year)),
            (CAP_NEW.L('oil_ppl', year)),
            (CAP_NEW.L('bio_ppl', year)),
            (CAP_NEW.L('hydro_ppl', year)),
            (CAP_NEW.L('wind_ppl', year)),
            (CAP_NEW.L('solar_PV_ppl', year)),
            (CAP_NEW.L('nuclear_ppl', year)),
            (CAP_NEW.L('other_ppl', year)) /
) ;

* ------------------------------------------------------------------------------
* final energy consumption
* ------------------------------------------------------------------------------

PUT / 'final energy consumption', 'GWh'/ ;

PUT '', 'electricity', 'coal', 'gas', 'oil', 'biomass', 'solar', 'other' / ;
LOOP(year,
        PUT year.tl,
             (ACT.L('appliances', year) * input('appliances', 'electricity', 'final')),
             (ACT.L('coal_nele', year) * input('coal_nele', 'coal', 'final')),
             (ACT.L('gas_nele', year) * input('gas_nele', 'gas', 'final')),
             (ACT.L('oil_nele', year) * input('oil_nele', 'oil', 'final')),
             (ACT.L('bio_nele', year) * input('bio_nele', 'biomass', 'final')),
             (ACT.L('solar_nele', year) * input('solar_nele', 'solar', 'final')),
             (ACT.L('other_nele', year)) /
) ;

* ------------------------------------------------------------------------------
* emissions
* ------------------------------------------------------------------------------

PUT / 'emissions', 'kt CO2'/ ;

PUT '', 'CO2 emissions' / ;
LOOP(year,
        PUT year.tl,
            EMISS.L(year) /
) ;

* ------------------------------------------------------------------------------
* shadow prices
* ------------------------------------------------------------------------------

PUT / 'shadow price (raw)', 'Euro/MWh'/ ;

PUT '', 'electricity final' / ;
LOOP(year,
        PUT year.tl,
            EQ_ENERGY_BALANCE.M('electricity', 'final', year) /
) ;
