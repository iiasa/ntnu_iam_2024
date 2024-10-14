Sets
        technology / coal_ppl, gas_ppl, wind_ppl /
        year / 2020, 2030/
        ;
Variables
        X(technology, year) technology activity
        EMISS_ANNUAL (year)
        TOTAL_EMISS
        COST_ANNUAL (year)
        TOTAL_COST total energy system cost
        ;
Parameter
        demand (year) total energy demand per hour / 2020 100, 2030 120 /
        ;
TABLE
        cost(technology, year)
                        2020    2030
        coal_ppl        20      20
        gas_ppl         22      22
        wind_ppl        30      30
;
TABLE
        emission_intensity(technology, year)
                        2020    2030
        coal_ppl        1.5     1.5
        gas_ppl         1       1
        wind_ppl        0.5     0.5
;
Equations
        EQ_COST
        EQ_COST_ANNUAL(year)
        EQ_ENERGY_BALANCE(year)
        EQ_EMISS_ANNUAL(year)
        EQ_TOTAL_EMISSION
        ;

EQ_COST_ANNUAL(year)..   Sum(technology, X(technology, year)*cost(technology, year)) =E= COST_ANNUAL(year);
EQ_COST..   Sum(year, COST_ANNUAL(year)) =E= TOTAL_COST;
EQ_ENERGY_BALANCE(year).. SUM(technology, X(technology, year)) =G= demand(year);
EQ_EMISS_ANNUAL(year).. Sum(technology, X(technology, year)*emission_intensity(technology, year)) =E= EMISS_ANNUAL(year);
EQ_TOTAL_EMISSION.. Sum(year, EMISS_ANNUAL(year)) =E= TOTAL_EMISS;

Model simple_model / all / ;
X.LO(technology, year) = 0;
TOTAL_EMISS.UP = 200;
*TOTAL_COST.UP = 5050;

Solve simple_model minimize TOTAL_COST using LP;