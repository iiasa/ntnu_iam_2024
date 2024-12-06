* ------------------------------------------------------------------------------
* include model specification
* ------------------------------------------------------------------------------

* include set, parameter and variable definitions that are shared across the models
$include shared.gms

* include specifications for FaIR that are originally part of DICE2023 code
$include climate/FaIR_auxiliary.gms

* Include file for DFAIR model and climate equations
$include climate/FAIR-beta-4-3-1.gms

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

* assume emissions to be constant at current levels specified by parameter e1
E.FX(t) = e1 ;

* ------------------------------------------------------------------------------
* solve model
* ------------------------------------------------------------------------------

solve fair maximizing CUM_E using nlp ;

* ------------------------------------------------------------------------------
* reporting
* ------------------------------------------------------------------------------

execute_unload "climate_results.gdx"
