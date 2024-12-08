* ------------------------------------------------------------------------------
* integrating energy systems model and FaIR simple climate model
* ------------------------------------------------------------------------------

* include set, parameter and variable definitions that are shared across the models
$include shared.gms

$include energy/energy_model_world.gms

* include specifications for FaIR that are originally part of DICE2023 code
$include climate/FaIR_auxiliary.gms

* Include file for DFAIR model and climate equations
$include climate/FAIR-beta-4-3-1.gms

SETS
           mapping(t, year_all)    Mapping time sets from DFaIR and energy systems model onto each other
           / 1.2020, 2.2030, 3.2040, 4.2050, 5.2060, 6.2070, 7.2080, 8.2080, 9.2080 / ;

* hand

* ------------------------------------------------------------------------------
* solve soft linked model
* ------------------------------------------------------------------------------
$ONTEXT
OPTION LP = CPLEX ;

SOLVE energy_model using LP minimize TOTAL_COST ;

model fair /
        ECO2eq
        ECO2Eeq
        EINDeq
        F_GHGabateEQ
        cumulative
        CCATOTEQ
        FORCE
        RES0LOM
        RES1LOM
        RES2LOM
        RES3LOM
        MMAT
        Cacceq
        TATMEQ
        TBOX1EQ
        TBOX2EQ
        IRFeqLHS
        IRFeqRHS
/ ;

* hand over of emissions for softlink
E.FX(t) = SUM(year_all$mapping(t,year_all), EMISS.L(year_all)) ;

* solve
SOLVE fair maximizing CUM_E using nlp ;
$OFFTEXT
* ------------------------------------------------------------------------------
* solve hard linked model
* ------------------------------------------------------------------------------

EQUATION EQ_MAP(t) ;

EQ_MAP(t)..
         E(t) =E= SUM(year_all$mapping(t,year_all), EMISS(year_all)) ;

model energy_climate /
    EQ_INV_DEMAND
    EQ_ACT_DEMAND
    EQ_TOT_DEMAND
    EQ_ENERGY_BALANCE
    EQ_CAPACITY_BALANCE
    EQ_EMISSION
    EQ_EMISSION_TECH
    EQ_EMISSION_CUMULATIVE
    EQ_DIFFUSION_UP
    EQ_COST_ANNUAL
    EQ_COST
    EQ_SHARE_UP
    EQ_SHARE_LO
        ECO2eq
        ECO2Eeq
        EINDeq
        F_GHGabateEQ
        cumulative
        CCATOTEQ
        FORCE
        RES0LOM
        RES1LOM
        RES2LOM
        RES3LOM
        MMAT
        Cacceq
        TATMEQ
        TBOX1EQ
        TBOX2EQ
        IRFeqLHS
        IRFeqRHS
    EQ_MAP
/ ;

TATM.UP(t)$(ORD(t) le 9) = 2 ;

* Specify the solver and options
*Option NLP = IPOPT;
* Set optimality criterion
*Option OPTCR = 0.05;
** Increase iteration limit
*Option ITERLIM = 10000;  

* solve model
solve energy_climate using NLP minimize TOTAL_COST ;

* ------------------------------------------------------------------------------
* reporting
* ------------------------------------------------------------------------------

execute_unload "energy_climate_results_Al_end_2C.gdx"

