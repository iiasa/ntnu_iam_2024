
*----------------------------------------------------------------------------------------------------------------------*
* set and parameter definitions                                                                                        *
*----------------------------------------------------------------------------------------------------------------------*

Sets
*    commodity       commodity ( resources - oil - gas - electricty - water - land availability - etc. )
*    level           level ( primary - secondary - ... - useful )
*    year_all        years (over entire model horizon) / 2020, 2030, 2040, 2050, 2060, 2070, 2080 /
    year(year_all)  years included in a model instance (for myopic or rolling-horizon optimization)
    macro_horizon(year_all)          set of periods included in the MACRO model horizon
    macro_base_period(year_all)      flag for base year period in model horizon (period prior to first model period) - used in MACRO
    first_period(year_all)           flag for first period in model horizon
    last_period(year_all)            flag for last period in model horizon
;

* definition of aliases shared with MESSAGE

Alias(year_all,year_all2);
Alias(year_all,year_all3);
Alias(year,year2);
Alias(year,year3);

$LABEL macro_sets

* sets specific to MACRO

Sets
*    sector      Energy Sectors for macro-economic analysis in MACRO    / ELEC, NELE /
    seq_period(year_all,year_all2)    mapping of one period ('year_all') to the next ('year_all2')
;

SCALAR  epsilon            small number to avoid divergences
        / 0.01 /
;

PARAMETERS
         i0                    Initial investment in base year
         c0                    Initial consumption in base year
         k0                    Initial capital in base year
         y0                    Initial output in base year

         gdp_base              Initial GDP (Trillion $) in base year / 71 /
         kgdp                  Initial capital to GDP ratio in base year  / 2.8 /
         depr                  Annual percent depreciation  / 0.05 /
         drate                 Social discount rate  / 0.05 /
         esub                  Elasticity between capital-labor (K-L) and energy (Sum E)  / 0.3 /
         rho                   Production function exponent between capital-labor and energy nest (rho = (esub - 1) : esub)
         kpvs                  Capital value share parameter     / 0.28 /
         elvs                  Electricity value share parameter     / 0.42 /
         ecst0                 Energy costs in base year
         demand_base(sector)    base year consumption level of energy services from MESSAGE

         enestart(sector,year_all)  Consumption level of energy services from MESSAGE model run
         eneprice(sector,year_all)  Shadow prices of energy services from MESSAGE model run
         total_cost_energy(year_all)       Total energy system costs from MESSAGE model run

         udf(year_all)             Utility discount factor in period year
         labor(year_all)           Labor force (efficiency units) in period year
         newlab(year_all)          New vintage of labor force in period year

         grow(year_all)            Annual growth rates of potential GDP  / 2020 0.03, 2030 0.03, 2040 0.03, 2050 0.03, 2060 0.03, 2070 0.02, 2080 0.01 /
         aeei_factor(sector, year_all) Cumulative effect of autonomous energy efficiency improvement (AEEI)

         finite_time_corr(year_all) finite time horizon correction factor in utility function
         lotol                 Tolerance factor for lower bounds on MACRO variabales    / 0.05 /

         SVKN(year_all)    'start values for new capital variable KN'
         SVNEWE(sector, year_all)    'start values for new energy variable'
;

Table    aeei(sector, year_all)    Annual potential decrease of energy intensity in sector sector
                 2020    2030    2040    2050   2060    2070    2080
         ELEC    0.02    0.02    0.02    0.02   0.02    0.02    0.02
         NELE    0.02    0.02    0.02    0.02   0.02    0.02    0.02
;
*aeei(sector,year_all) = 0.0 ;
*grow(year_all) = 0.0 ;
Parameters
* general parameters
    duration_period     duration of one multi-year period (in years)   / 10 /
* parameters for spatially and temporally flexible formulation, and for myopic/rolling-horizon optimization
    duration_period_sum(year_all,year_all2)   number of years between two periods ('year_all' must precede 'year_all2')
;

* ------------------------------------------------------------------------------
* define sets for period structure
* ------------------------------------------------------------------------------

* set MACRO base year (not solved)
macro_base_period('2020') = yes ;

*year(year_all) = no ;
*year(year_all)$( NOT macro_base_period(year_all) ) = yes ;
year(year_all) = yes ;


* compute auxiliary parameters for duration over periods (years)

* auxiliary parameters for duration between periods (years) - not including the final period 'year_all2'
duration_period_sum(year_all,year_all2) =
    SUM(year_all3$( ORD(year_all) <= ORD(year_all3) AND ORD(year_all3) < ORD(year_all2) ) , duration_period ) ;

* mapping of sequence of periods over the model horizon
seq_period(year_all,year_all2)$( ORD(year_all) + 1 = ORD(year_all2) ) = yes ;

* first and last model period
first_period(year_all)$( ORD(year_all) eq 1 ) = yes ;
last_period(year_all)$( ORD(year_all) = CARD(year_all) ) = yes ;

macro_horizon(year_all) = no ;
macro_horizon(year_all)$( ORD(year_all) >= sum(year_all2$first_period(year_all2), ORD(year_all2) )
    AND ORD(year_all) <= sum(year_all2$last_period(year_all2), ORD(year_all2) ) ) = yes ;
macro_horizon(year_all)$macro_base_period(year_all) = yes;

DISPLAY macro_base_period, first_period, last_period, macro_horizon, year, year2, seq_period;

* ------------------------------------------------------------------------------
* use externally supplied scenario parameters as default starting values for MACRO (these will be overwritten in the actual iteration process)
* ------------------------------------------------------------------------------

* the following three parameters are used for running MACRO standalone and for calibration purposes
Table    demand_MESSAGE(sector,year_all) consumption level of energy services from MESSAGE model run
                 2020    2030    2040    2050   2060    2070    2080
         ELEC    22.6    25.7    28.60   32.80  36.7    41.7    47.6
         NELE    87.3    99.0    110.00  117.00 142.    161     184
;
*demand_MESSAGE('ELEC',year_all) = 22.6 ;
*demand_MESSAGE('NELE',year_all) = 87.3 ;
Table
         price_MESSAGE(sector,year_all)  shadow prices of energy services [USD per kWk] from MESSAGE model run
                 2020    2030    2040    2050    2060    2070    2080
         ELEC    0.0567  0.0567  0.0567  0.0567  0.0567  0.0567  0.0567
         NELE    0.020   0.020   0.020   0.020   0.020   0.020   0.020
;
*price_MESSAGE(sector, year_all)$(NOT macro_base_period(year_all)) = price_MESSAGE(sector, year_all) * 1.5 ;
Parameter
         cost_MESSAGE(year_all)          total energy system costs [trillionUSD] from MESSAGE model run
         / 2020 5.053, 2030 3.045, 2040 3.080, 2050 3.516, 2060 3.852, 2070 4.376, 2080 4.996 / ;
*cost_MESSAGE(year_all) = 5.053 ;
* useful energy/service demand levels from MESSAGE get mapped onto MACRO sector structure
enestart(sector,year_all) = demand_MESSAGE(sector,year_all) ;
* useful energy/service demand prices from MESSAGE get mapped onto MACRO sector structure
eneprice(sector,year_all) = price_MESSAGE(sector,year_all) ;
* total energy system costs by node and time
total_cost_energy(year_all) = cost_MESSAGE(year_all) ;

* base year useful energy/service demand levels from MESSAGE get mapped onto MACRO sector structure
demand_base(sector) = sum(macro_base_period, enestart(sector,macro_base_period) ) ;

DISPLAY enestart, eneprice, total_cost_energy;

* ------------------------------------------------------------------------------
* calculate start values
* ------------------------------------------------------------------------------

PARAMETER growth_factor(year_all)  'cumulative growth factor' ;

growth_factor(macro_base_period) = 1 ;

LOOP(year $ (NOT macro_base_period(year)),
    growth_factor(year) = SUM(year_all$( seq_period(year_all,year) ), growth_factor(year_all) * (1 + grow(year))**(duration_period)) ;
) ;

PARAMETER potential_gdp(year_all) ;

potential_gdp(year_all) = gdp_base * growth_factor(year_all) ;

DISPLAY grow, growth_factor, potential_gdp, duration_period ;

* ------------------------------------------------------------------------------
* assigning parameters and calculation of cumulative effect of AEEI over time
* ------------------------------------------------------------------------------

* calculation of cumulative effect of AEEI over time
aeei_factor(sector, macro_base_period) = 1;

LOOP(year_all $ ( ORD(year_all) > sum(year_all2$( macro_base_period(year_all2) ), ORD(year_all2) ) ),
aeei_factor(sector, year_all) = SUM(year_all2$( seq_period(year_all2,year_all) ), ( (1 - aeei(sector, year_all)) ** duration_period ) * aeei_factor(sector, year_all2))
);

DISPLAY aeei_factor ;

* ------------------------------------------------------------------------------
* calculation of total labor supply, new labor supply and utility discount factor
* ------------------------------------------------------------------------------

* caluclate production function exponent between capital-labor and energy nest from elasticity of substitution
rho = (esub - 1)/esub ;
DISPLAY rho ;

udf(macro_base_period)   = 1 ;
labor(macro_base_period) = 1 ;

LOOP(year_all $( ORD(year_all) > sum(year_all2$( macro_base_period(year_all2) ), ORD(year_all2) ) ),
* exogenous labor supply growth (including both changes in labor force and labor productivity growth)
   labor(year_all)  = SUM(year_all2$( seq_period(year_all2,year_all) ), labor(year_all2) * (1 + grow(year_all))**duration_period) ;
* new labor supply
   newlab(year_all) = SUM(year_all2$( seq_period(year_all2,year_all) ), (labor(year_all) - labor(year_all2)*(1 - depr)**duration_period)$((labor(year_all) - labor(year_all2)*(1 - depr)**duration_period) > 0)) + epsilon ;
* calculation of utility discount factor based on discount rate (drate)
   udf(year_all)    = SUM(year_all2$( seq_period(year_all2,year_all) ), udf(year_all2) * (1 - (drate - grow(year_all)))**duration_period) ;
);

DISPLAY labor, newlab, udf;

* ------------------------------------------------------------------------------
* Calculation of base year energy system costs, capital stock and GDP components (investment, consumption, production)
* ------------------------------------------------------------------------------

ecst0 = cost_MESSAGE('2020') ;

k0 = kgdp * gdp_base ;

* pseudo loop over base_period set which includes single element
LOOP(macro_base_period,
     i0 = (k0 * (grow(macro_base_period) + depr))$(k0 * (grow(macro_base_period) + depr) > 0) + epsilon ;
);

c0 = gdp_base - i0 - ecst0 ;
y0 = gdp_base ;

DISPLAY ecst0, k0, i0, c0, y0 ;

SCALAR  a 'production function coefficient for capital and labor'
        b 'production function coefficient for energy' ;

b = price_MESSAGE('NELE', '2020') / ((1 - elvs) * y0**(1 - rho) * demand_MESSAGE('ELEC', '2020')**(rho * elvs) * demand_MESSAGE('NELE', '2020')**(rho * (1 - elvs) - 1)) ;

a = (y0**rho - b * demand_MESSAGE('ELEC', '2020')**(rho * elvs) * demand_MESSAGE('NELE', '2020')**(rho * (1 - elvs))) / (k0**(kpvs * rho));

* ------------------------------------------------------------------------------
* Introduced fix for running MACRO myopically when the finite time horizon correction
* of the utility function causes problems in case of labour productivity growth rates
* that are greater than drate = depr. To avoid negative values the absolute value is
* simply taken.
* ------------------------------------------------------------------------------

finite_time_corr(year) = abs(drate - grow(year)) ;
