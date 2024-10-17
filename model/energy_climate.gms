* ------------------------------------------------------------------------------
* integrating energy systems model and FaIR simple climate model
* ------------------------------------------------------------------------------

$include energy_model_world.gms

*CUM_EMISS.UP = 1000 ;

SOLVE simple using LP minimize TOTAL_COST ;

set        t  Time periods (10 years per period)                   / 1*41 /
           mapping(t, year)    Mapping time sets from DFaIR and energy systems model onto each other
           / 1.2020, 2.2030, 3.2040, 4.2050, 5.2060, 6.2070, 7.2080, 8.2080, 9.2080 / ;

parameter
        e(t)      Energy and industrial missions over time ;

e(t) = SUM(year$mapping(t,year), EMISS.L(year)) ;

DISPLAY e ;

$include run_FAIR.gms



