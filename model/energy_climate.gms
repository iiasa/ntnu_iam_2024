* ------------------------------------------------------------------------------
* integrating energy systems model and FAIR model
* ------------------------------------------------------------------------------

$include energy_model_world.gms

*$include FAIR-beta-4-3-1.gms

* we detached the solving in the energy model and set a constraint on emissions
*CUM_EMISS.UP = 500;
*SOLVE simple using LP minimize TOTAL_COST ;

* map the year and set indexex from energy and Fair respectively(
set
    t  Time periods with ten years each /1*41/
    mapping(t, year) /1.2020, 2.2030, 3. 2040, 4.2050, 5.2060, 6.2070, 7.2080, 8.2080, 9.2080/
;
*Parameter
*    e(t)      Energy and industrial missions over time
*;
*e(t) = SUM(year$mapping(t,year), EMISS.L(year));

Variable E(t) Energy and industrial missions over time
;

Equation EQ_MAP_E_EMISS
;

EQ_MAP_E_EMISS(t).. E(t) =E= SUM(year$mapping(t,year), EMISS(year));



$include run_FAIR.gms

TATM.UP(t) $(ORD(t) le 9) = 2
model hardlink /all/;

solve hardlink minimize TOTAL_COST using nlp;

