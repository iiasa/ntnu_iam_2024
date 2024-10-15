
Sets
         technology 'set, of technologies' / coal_ppl, gas_ppl, wind_ppl /
         year       / 2020, 2030 /
*         vintage(year)
;

*vintage(year) = YES ;
ALIAS(year, vintage);


Variables
         ACT(technology, year)     technology activity
         CAP_NEW(technology, year) new technology capacity
         COST_ANNUAL(year)       costs per year
         TOTAL_COST              total energy system costs
         EMISS(year)             total CO2 emissions
;

Parameters
          demand(year)  total energy demand per hour / 2020 100, 2030 120 /
;

Table
          inv(technology, year) '[$/kW]'
                         2020    2030
          coal_ppl       1500    1500
          gas_ppl         800     800
          wind_ppl       1000    1000
;

Table
          fom(technology, year) '[$/kW]'
                         2020    2030
          coal_ppl         60      60
          gas_ppl          32      32
          wind_ppl         40      40
;

Table
          vom(technology, year) '[$/kWh]'
                         2020    2030
          coal_ppl      0.018   0.018
          gas_ppl       0.036   0.036
          wind_ppl          0       0
;

Table
          emission_intensity(technology, year) '[gCO2/kWh]'
                         2020    2030
          coal_ppl        846     846
          gas_ppl         367     367
          wind_ppl          0       0
;

Table
          hours(technology, year) 'full load hours per year'
                         2020    2030
          coal_ppl       7000    7000
          gas_ppl        7000    7000
          wind_ppl       2000    2000
;


Equations
         EQ_COST_ANNUAL(year)
         EQ_COST
         EQ_ENERGY_BALANCE(year)
         EQ_EMISSION(year)
         EQ_CAPACITY_BALANCE(technology, year)
;


EQ_COST_ANNUAL(year)..    Sum(technology, ACT(technology, year) * vom(technology, year)
                                        + CAP_NEW(technology, year) * inv(technology, year)
                                        + Sum(vintage $ (ORD(vintage) le ORD(year)), CAP_NEW(technology, vintage) * fom(technology, vintage)))
                          =E= COST_ANNUAL(year) ;
EQ_COST..                 Sum(year, COST_ANNUAL(year)) =E= TOTAL_COST ;
EQ_ENERGY_BALANCE(year).. Sum(technology, ACT(technology, year)) =G= demand(year) ;
EQ_EMISSION(year)..       Sum(technology, ACT(technology, year) * emission_intensity(technology, year)) =E= EMISS(year) ;
EQ_CAPACITY_BALANCE(technology, year)..  ACT(technology, year) =L= Sum(vintage $ (ORD(vintage) le ORD(year)), CAP_NEW(technology, vintage)) * hours(technology, year) ;

DISPLAY vintage ;

Model simple_model / all / ;

ACT.LO(technology, year) = 0 ;
CAP_NEW.LO(technology, year) = 0 ;
*EMISS.UP('2030') = 0 ;
*TOTAL_COST.UP = 2050 ;


Solve simple_model minimize TOTAL_COST using LP ;

