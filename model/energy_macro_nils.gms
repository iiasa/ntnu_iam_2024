
$include energy_model_world.gms


$INCLUDE macro_data_load.gms
$INCLUDE macro_core.gms

model hardlink2 /all/;

$INCLUDE macro_solve.gms


CUM_EMISS.UP = 1000 ;

SOLVE hardlink2 MAXIMIZING UTILITY USING NLP ;

GDP_MACRO.L(year) = (I.L(year) + C.L(year) + EC.L(year)) ;

DISPLAY GDP_MACRO.L ;

*excecute_unload ""