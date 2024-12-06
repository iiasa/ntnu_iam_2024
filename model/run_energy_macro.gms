* ------------------------------------------------------------------------------
* integrating energy systems model and macro-economic model
* ------------------------------------------------------------------------------

* include set, parameter and variable definitions that are shared across the models
$include shared.gms

$include energy/energy_model_world.gms

$INCLUDE macro/macro_data_load.gms
$INCLUDE macro/macro_core.gms
$INCLUDE macro/macro_presolve.gms

* ------------------------------------------------------------------------------
* model definition
* ------------------------------------------------------------------------------

MODEL energy_macro /
    EQ_ENERGY_BALANCE
    EQ_CAPACITY_BALANCE
    EQ_EMISSION
    EQ_EMISSION_CUMULATIVE
    EQ_DIFFUSION_UP
    EQ_COST_ANNUAL
    EQ_COST
    EQ_SHARE_UP
    EQ_SHARE_LO
    UTILITY_FUNCTION
    CAPITAL_CONSTRAINT
    NEW_CAPITAL
    NEW_PRODUCTION
    TOTAL_CAPITAL
    TOTAL_PRODUCTION
    NEW_ENERGY
    ENERGY_SUPPLY
    COST_ENERGY_LINKED
    TERMINAL_CONDITION
/ ;


*CUM_EMISS.UP = 1000 ;

* ------------------------------------------------------------------------------
* solve model
* ------------------------------------------------------------------------------

SOLVE energy_macro MAXIMIZING UTILITY USING NLP ;

* ------------------------------------------------------------------------------
* reporting
* ------------------------------------------------------------------------------

GDP_MACRO.L(year) = (I.L(year) + C.L(year) + EC.L(year)) ;

DISPLAY GDP_MACRO.L ;

execute_unload "energy_macro_results.gdx"

