* ------------------------------------------------------------------------------
* integrating energy systems model and FAIR model
* ------------------------------------------------------------------------------

$include energy_model_world.gms
*$include FAIR-beta-4-3-1.gms

* map the year and set indexex from energy and Fair respectively(
set
    t  Time periods with ten years each /1*43/
    mapping(t, year) /1.2020, 2.2030, 3. 2040, 4.2050, 5.2060, 6.2070, 7.2080, 8.2080, 9.2080/
;
Parameter
    e(t)      Energy and industrial missions over time
;
e(t) = SUM(year$mapping(t,year), EMISS.L(year));

$include run_FAIR.gms


