
* ------------------------------------------------------------------------------
* Start values of variables inside feasible domain (positive variables)
* ------------------------------------------------------------------------------

*SVKN(year) = ((potential_gdp(year) - SUM(year2$( seq_period(year2,year) ), potential_gdp(year2)) * (1 - depr)**duration_period) * kgdp) $ (NOT macro_base_period(year));
SVKN(year) = ((potential_gdp(year) - SUM(year_all2$( seq_period(year_all2,year) ), potential_gdp(year_all2)) * (1 - depr)**duration_period) * kgdp) $ (NOT macro_base_period(year));
SVNEWE(sector, year) = (demand_base(sector) * growth_factor(year) - demand_base(sector) * (1 - depr)**(SUM(year2 $ macro_base_period(year2), duration_period_sum(year2, year)))) $ (NOT macro_base_period(year));

NEWENE.L(sector, macro_horizon)  = SVNEWE(sector, macro_horizon)$(SVNEWE(sector, macro_horizon) > 0) + epsilon ;
PHYSENE.L(sector, year)  = enestart(sector, year) ;
KN.L(macro_horizon)  = SVKN(macro_horizon) $ (SVKN(macro_horizon) > 0) + epsilon ;

* ------------------------------------------------------------------------------
* Lower bounds on variables help to avoid singularities
* ------------------------------------------------------------------------------

K.LO(macro_horizon)  = LOTOL * k0 ;
KN.LO(macro_horizon) = LOTOL * i0 * duration_period ;
Y.LO(macro_horizon)  = LOTOL * y0 ;
YN.LO(macro_horizon) = LOTOL * y0 * newlab(macro_horizon) ;

C.LO(macro_horizon)  = LOTOL * c0 ;
I.LO(macro_horizon)  = LOTOL * i0 ;

PRODENE.LO(sector, macro_horizon) = LOTOL * enestart(sector, macro_horizon) / aeei_factor(sector, macro_horizon) ;
NEWENE.LO(sector, macro_horizon)  = LOTOL * enestart(sector, macro_horizon) / aeei_factor(sector, macro_horizon) ;

* ------------------------------------------------------------------------------
* Base year values of variables are fixed to historical values
* ------------------------------------------------------------------------------

* division by aeei_factor is necesary in case MACRO starts after initialize_period (in case of slicing)
PRODENE.FX(sector, macro_base_period) = demand_base(sector) / aeei_factor(sector, macro_base_period) ;

Y.FX(macro_base_period) = y0 ;
K.FX(macro_base_period) = k0 ;
C.FX(macro_base_period) = c0 ;
I.FX(macro_base_period) = i0 ;
EC.FX(macro_base_period) = y0 - i0 - c0 ;

* ------------------------------------------------------------------------------
* solve statement
* ------------------------------------------------------------------------------

SOLVE MACRO MAXIMIZING UTILITY USING NLP ;

* ------------------------------------------------------------------------------
* calculate GDP
* ------------------------------------------------------------------------------

GDP.L(year) = (I.L(year) + C.L(year) + EC.L(year)) ;

DISPLAY GDP.L ;
