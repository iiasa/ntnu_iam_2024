* ------------------------------------------------------------------------------
* include model specification
* ------------------------------------------------------------------------------

* include set, parameter and variable definitions that are shared across the models
$include shared.gms

$include energy/energy_model_world.gms

* ------------------------------------------------------------------------------
* solve model
* ------------------------------------------------------------------------------

OPTION LP = CPLEX ;

SOLVE energy_model using LP minimize TOTAL_COST ;

* ------------------------------------------------------------------------------
* reporting
* ------------------------------------------------------------------------------

execute_unload "energy_results.gdx"
