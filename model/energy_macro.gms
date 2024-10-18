* ------------------------------------------------------------------------------
* integrating energy systems model and macro-economic model
* ------------------------------------------------------------------------------

*$include energy_model_world.gms

CUM_EMISS.UP = 1000 ;

$INCLUDE macro_data_load.gms
$INCLUDE macro_core.gms

MODEL energy_macro / all / ;

$INCLUDE macro_solve.gms

SOLVE energy_macro MAXIMIZING UTILITY USING NLP ;

GDP_MACRO.L(year) = (I.L(year) + C.L(year) + EC.L(year)) ;

DISPLAY GDP_MACRO.L ;

execute_unload "energy_macro_results.gdx"

