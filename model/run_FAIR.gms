*set        t  Time periods (5 years per period)                   /1*81/
set        t  Time periods (10 years per period)                   /1*41/
;
sets     tfirst(t), tlast(t), tearly(t), tlate(t);

parameter
*        tstep       Years per Period                               / 5  /
        tstep       Years per Period                               / 10  /
        eland(t)       Emissions from deforestation (GtCO2 per year)
        e1        Industrial emissions 2020 (GtCO2 per year)           / 37.56  /
        CumEmiss0 Cumulative emissions 2020 (GtC)                      / 633.5/
        e(t)      Energy and industrial missions over time
;

* assume emissions to be constant at current levels
e(t) = e1 ;

variable
        CCATOT(t)       Total carbon emissions (GtC)
        CUM_E            cumulative emissions
;

equation
        cumulative        cumulative emissions equation
        CCATOTEQ(t)      Cumulative total carbon emissions
;

** Include non-CO2 GHGs

* nonco2 Parameters      
Parameters
        CO2E_GHGabateB(t)         Abateable non-CO2 GHG emissions base
        CO2E_GHGabateact(t)       Abateable non-CO2 GHG emissions base (actual)
        F_Misc(t)                 Non-abateable forcings (GHG and other)
        emissrat(t)               Ratio of CO2e to industrial emissions
        sigmatot(t)               Emissions output ratio for CO2e       
        FORC_CO2(t)               CO2 Forcings
;      
** Parameters for non-industrial emission
** Assumes abateable share of non-CO2 GHG is 65%
Parameters
        eland0         Carbon emissions from land 2015 (GtCO2 per year)  / 5.9    /
        deland         Decline rate of land emissions (per period)       / .1     /      
        F_Misc2020     Non-abatable forcings 2020                       /  -0.054    /
        F_Misc2100     Non-abatable forcings 2100                        / .265/       
        F_GHGabate2020 Forcings of abatable nonCO2 GHG                   / 0.518 /
        F_GHGabate2100 Forcings of abatable nonCO2 GHG                   / 0.957 /

        ECO2eGHGB2020  Emis of abatable nonCO2 GHG GtCO2e  2020             /  9.96/     
        ECO2eGHGB2100  Emis of abatable nonCO2 GHG GtCO2e  2100             /  15.5 /     
        emissrat2020   Ratio of CO2e to industrial CO2 2020                 / 1.40 /
        emissrat2100   Ratio of CO2e to industrial CO2 2020                 / 1.21 /       
        Fcoef1         Coefficient of nonco2 abateable emissions            /0.00955/
        Fcoef2         Coefficient of nonco2 abateable emissions            /.861/
        ;
** Parameters emissions and non-CO2
eland(t) = eland0*(1-deland)**(t.val-1);      
* original parameterization for 5-year time steps             
*        CO2E_GHGabateB(t)=ECO2eGHGB2020+((ECO2eGHGB2100-ECO2eGHGB2020)/16)*(t.val-1)$(t.val le 16)+((ECO2eGHGB2100-ECO2eGHGB2020))$(t.val ge 17);
*        F_Misc(t)=F_Misc2020 +((F_Misc2100-F_Misc2020)/16)*(t.val-1)$(t.val le 16)+((F_Misc2100-F_Misc2020))$(t.val ge 17);
*        emissrat(t) = emissrat2020 +((emissrat2100-emissrat2020)/16)*(t.val-1)$(t.val le 16)+((emissrat2100-emissrat2020))$(t.val ge 17); 
* VK: change to 10-year timesteps which means period 9 instead of 16 equals 2100
        CO2E_GHGabateB(t)=ECO2eGHGB2020+((ECO2eGHGB2100-ECO2eGHGB2020)/9)*(t.val-1)$(t.val le 9)+((ECO2eGHGB2100-ECO2eGHGB2020))$(t.val ge 10);
        F_Misc(t)=F_Misc2020 +((F_Misc2100-F_Misc2020)/9)*(t.val-1)$(t.val le 9)+((F_Misc2100-F_Misc2020))$(t.val ge 10);
        emissrat(t) = emissrat2020 +((emissrat2100-emissrat2020)/9)*(t.val-1)$(t.val le 9)+((emissrat2100-emissrat2020))$(t.val ge 10); 

DISPLAY CO2E_GHGabateB, F_Misc, emissrat;

VARIABLES
        ECO2(t)         Total CO2 emissions (GtCO2 per year)
        ECO2E(t)        Total CO2e emissions including abateable nonCO2 GHG (GtCO2 per year)
        EIND(t)         Industrial CO2 emissions (GtCO2 per yr)
        F_GHGabate      Forcings abateable nonCO2 GHG     
;
Equations
        ECO2eq(t)         CO2 Emissions equation
        ECO2Eeq(t)        CO2E Emissions equation
        EINDeq(t)        Industrial CO2 equation
        F_GHGabateEQ(t)
;        

* Program control definitions
        tfirst(t) = yes$(t.val eq 1);
        tlast(t)  = yes$(t.val eq card(t));

 eco2eq(t)..          ECO2(t)        =E= e(t) + eland(t) ;
 eindeq(t)..          EIND(t)        =E= e(t) ;
 eco2Eeq(t)..         ECO2E(t)       =E= e(t) + eland(t) + CO2E_GHGabateB(t) ;
 F_GHGabateEQ(t+1)..  F_GHGabate(t+1) =E= Fcoef2*F_GHGabate(t)+ Fcoef1*CO2E_GHGabateB(t) ;
 ccatoteq(t+1)..      CCATOT(t+1)    =E= CCATOT(t) +  ECO2(T)*(5/3.666) ;
 cumulative..         CUM_E          =E= SUM(t, ECO2(t)) ;


** Include file for DFAIR model and climate equations
$include FAIR-beta-4-3-1.gms

model fair /all/ ;

* initial conditions
F_GHGabate.fx(tfirst)   = F_GHGabate2020;
ccatot.fx(tfirst)       = CumEmiss0;

solve fair maximizing CUM_E using nlp ;
