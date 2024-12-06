* ------------------------------------------------------------------------------
* include model specification
* ------------------------------------------------------------------------------

* include set, parameter and variable definitions that are shared across the models
$INCLUDE shared.gms

$INCLUDE macro/macro_data_load.gms
$INCLUDE macro/macro_core.gms
$INCLUDE macro/macro_presolve.gms

* ------------------------------------------------------------------------------
* solve model
* ------------------------------------------------------------------------------

SOLVE MACRO MAXIMIZING UTILITY USING NLP ;

* ------------------------------------------------------------------------------
* reporting
* ------------------------------------------------------------------------------

GDP_MACRO.L(year) = (I.L(year) + C.L(year) + EC.L(year)) ;

DISPLAY GDP_MACRO.L ;

execute_unload "macro_results.gdx"

