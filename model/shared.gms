

SETS
*    t  Time periods (5 years per period) in FaIR                    /1*81/
    t  Time periods (10 years per period) in FaIR                   /1*41/

    year_all                'periods in energy and macro models'
    / 2020
      2030
      2040
      2050
      2060
      2070
      2080 /

    sector      Energy Sectors for macro-economic analysis in MACRO    / ELEC, NELE /
;

POSITIVE VARIABLES
    PHYSENE(sector, year_all)  Physical end-use service or commodity use
;

VARIABLES
    COST_ANNUAL(year_all)           'costs per year_all'
;