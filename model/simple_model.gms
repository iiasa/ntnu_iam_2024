
Sets
         technology 'set, of technologies' / coal_ppl, gas_ppl, wind_ppl /
         year       / 2020, 2030 /
         share      'technology share set' / coal_power /
         tec_share(share, technology)    'technology share left hand side'   / coal_power.coal_ppl /
         tec_share_rhs(share, technology)  'technology share right hand side'    / coal_power.coal_ppl, coal_power.gas_ppl, coal_power.wind_ppl /
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
         CUM_EMISS               cumulative CO2 emissions
;

Parameters
          demand(year)  total energy demand per hour / 2020 100, 2030 120 /
          discount_rate  / 0.05 /
          plength  / 10 /
          cost_capacity(technology, year)
          share_up(share)  / coal_power 0.4 /
          share_lo(share)
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
$ONTEXT
inv(technology, year) = 0 ;
fom(technology, year) = 0 ;
Table
          vom(technology, year) '[$/kWh]'
                         2020    2030
          coal_ppl       0.20    0.20
          gas_ppl        0.22    0.22
          wind_ppl       0.30    0.30
;
$OFFTEXT

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

Table
          lifetime(technology, year) 'full load hours per year'
                         2020    2030
          coal_ppl         30      30
          gas_ppl          30      30
          wind_ppl         30      30
;

Parameter
          diffusion(technology) 'annual growth rate of capacity additions'
        / coal_ppl         0.05,
          gas_ppl          0.05,
          wind_ppl         0.05 /
;

Parameter
          startup(technology) 'constant capacity additions per period'
        / coal_ppl         0.001,
          gas_ppl          0.001,
          wind_ppl         0.001 /
;


cost_capacity(technology, year) = inv(technology, year) * ((1 + discount_rate)**lifetime(technology, year) * discount_rate) /
                                                          ((1 + discount_rate)**lifetime(technology, year) - 1)
                                + fom(technology, year) ;



Equations
         EQ_COST_ANNUAL(year)
         EQ_COST
         EQ_ENERGY_BALANCE(year)
         EQ_EMISSION(year)
         EQ_EMISSION_CUMULATIVE
         EQ_CAPACITY_BALANCE(technology, year)
         EQ_CAPACITY_DIFFUSION(technology, year)
         EQ_SHARE_UP(share, year)
*         EQ_SHARE_LO(share, year)
;


EQ_COST_ANNUAL(year)..    Sum(technology, ACT(technology, year) * vom(technology, year)
                                        + Sum(vintage $ ((ORD(vintage) le ORD(year)) AND ((ORD(year) - ORD(vintage) + 1) * plength le lifetime(technology, vintage))), CAP_NEW(technology, vintage) * cost_capacity(technology, vintage)))
                          =E= COST_ANNUAL(year) ;
EQ_COST..                 Sum(year, COST_ANNUAL(year) * plength * (1 - discount_rate)**(plength * (ORD(year) - 1))) =E= TOTAL_COST ;
EQ_ENERGY_BALANCE(year).. Sum(technology, ACT(technology, year)) =G= demand(year) ;
EQ_EMISSION(year)..       Sum(technology, ACT(technology, year) * emission_intensity(technology, year)) =E= EMISS(year) ;
EQ_EMISSION_CUMULATIVE..  Sum(year, EMISS(year) * plength) =E= CUM_EMISS ;
EQ_CAPACITY_BALANCE(technology, year)..  ACT(technology, year) =L= Sum(vintage $ ((ORD(vintage) le ORD(year)) AND ((ORD(year) - ORD(vintage) + 1) * plength le lifetime(technology, vintage))), CAP_NEW(technology, vintage)) * hours(technology, year) ;
EQ_CAPACITY_DIFFUSION(technology, year)$(ORD(year) > 1)..
                         CAP_NEW(technology, year) =L= CAP_NEW(technology, year-1) * (1 + diffusion(technology))**plength + startup(technology) ;
EQ_SHARE_UP(share, year)$(share_up(share))..
                          Sum(technology$tec_share(share, technology), ACT(technology, year)) =L= Sum(technology$tec_share_rhs(share, technology), ACT(technology, year)) * share_up(share) ;
*EQ_SHARE_LO(share, year)$(share_lo(share))..
*                          Sum(technology$tec_share(share, technology), ACT(technology, year)) =G= Sum(technology$tec_share_rhs(share, technology), ACT(technology, year)) * share_lo(share) ;


DISPLAY vintage ;

Model simple_model / all / ;

ACT.LO(technology, year) = 0 ;
CAP_NEW.LO(technology, year) = 0 ;
*CAP_NEW.FX('coal_ppl', '2020') = 0.009 ;
*EMISS.UP('2030') = 0 ;
*CUM_EMISS.UP = 1.8612E+6 / 2 ;
*TOTAL_COST.UP = 2050 ;


Solve simple_model minimize TOTAL_COST using LP ;

