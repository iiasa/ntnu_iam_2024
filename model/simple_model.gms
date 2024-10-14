
Sets
         technology 'set, of technologies' / coal_ppl, gas_ppl, wind_ppl /
         year       / 2020, 2030 /
;

Variables
         X(technology, year)     technology activity
         COST_ANNUAL(year)       costs per year
         TOTAL_COST              total energy system costs
         EMISS(year)             total CO2 emissions
;

Parameters
          demand(year)  total energy demand per hour / 2020 100, 2030 120 /
;
Table
          cost(technology, year)
                         2020    2030
          coal_ppl         20      20
          gas_ppl          22      22
          wind_ppl         30      30
;
Table
          emission_intensity(technology, year)
                         2020    2030
          coal_ppl        1.5     1.5
          gas_ppl         1.0     1.0
          wind_ppl          0       0
;

Equations
         EQ_COST_ANNUAL(year)
         EQ_COST
         EQ_ENERGY_BALANCE(year)
         EQ_EMISSION(year)
;


EQ_COST_ANNUAL(year)..    Sum(technology, X(technology, year) * cost(technology, year)) =E= COST_ANNUAL(year) ;
EQ_COST..                 Sum(year, COST_ANNUAL(year)) =E= TOTAL_COST ;
EQ_ENERGY_BALANCE(year).. Sum(technology, X(technology, year)) =G= demand(year) ;
EQ_EMISSION(year)..       Sum(technology, X(technology, year) * emission_intensity(technology, year)) =E= EMISS(year) ;


Model simple_model / all / ;

X.LO(technology, year) = 0 ;
EMISS.UP('2030') = 100 ;
*TOTAL_COST.UP = 2050 ;

Solve simple_model minimize TOTAL_COST using LP ;

