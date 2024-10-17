** Equals old FAIR with recalibrated parameters for revised F2xco2 and Millar model.
** Deletes nonnegative reservoirs. See explanation below


sets     tfirst(t), tlast(t);

PARAMETERS
        yr0     Calendar year that corresponds to model year zero         /2020/
        emshare0 Carbon emissions share into Reservoir 0   /0.2173/
        emshare1 Carbon emissions share into Reservoir 1    /0.224/
        emshare2 Carbon emissions share into Reservoir 2    /0.2824/
        emshare3 Carbon emissions share into Reservoir 3    /0.2763/
        tau0    Decay time constant for R0  (year)                            /1000000/
        tau1    Decay time constant for R1  (year)                            /394.4/
        tau2    Decay time constant for R2  (year)       /36.53/
        tau3    Decay time constant for R3  (year) /4.304/

        teq1    Thermal equilibration parameter for box 1 (m^2 per KW)         /0.324/
        teq2    Thermal equilibration parameter for box 2 (m^2 per KW)        /0.44/
        d1      Thermal response timescale for deep ocean (year)               /236/
        d2      Thermal response timescale for upper ocean (year)              /4.07/

        irf0    Pre-industrial IRF100 (year)                                        /32.4/
        irC      Increase in IRF100 with cumulative carbon uptake (years per GtC)    /0.019/
        irT      Increase in IRF100 with warming (years per degree K)                /4.165/
        fco22x   Forcings of equilibrium CO2 doubling (Wm-2)                        /3.93/

** INITIAL CONDITIONS TO BE CALIBRATED TO HISTORY
** CALIBRATION
       mat0   Initial concentration in atmosphere in 2020 (GtC)       /886.5128014/

       res00  Initial concentration in Reservoir 0 in 2020 (GtC)      /150.093 /
       res10  Initial concentration in Reservior 1 in 2020 (GtC)      /102.698 /
       res20  Initial concentration in Reservoir 2 in 2020 (GtC)      /39.534  /
       res30  Initial concentration in Reservoir 3 in 2020 (GtC)      / 6.1865 /



       mateq      Equilibrium concentration atmosphere  (GtC)            /588   /
       tbox10    Initial temperature box 1 change in 2020 (C from 1765)  /0.1477  /
       tbox20    Initial temperature box 2 change in 2020 (C from 1765)  /1.099454/
       tatm0     Initial atmospheric temperature change in 2020          /1.24715 /

;
VARIABLES
*Note: Stock variables correspond to levels at the END of the period
        FORC(t)        Increase in radiative forcing (watts per m2 from 1765)
        TATM(t)        Increase temperature of atmosphere (degrees C from 1765)
        TBOX1(t)       Increase temperature of box 1 (degrees C from 1765)
        TBOX2(t)       Increase temperature of box 2 (degrees C from 1765)
        RES0(t)        Carbon concentration in Reservoir 0 (GtC from 1765)
        RES1(t)        Carbon concentration in Reservoir 1 (GtC from 1765)
        RES2(t)        Carbon concentration in Reservoir 2 (GtC from 1765)
        RES3(t)        Carbon concentration in Reservoir 3 (GtC from 1765)
        MAT(t)         Carbon concentration increase in atmosphere (GtC from 1765)
        CACC(t)        Accumulated carbon in ocean and other sinks (GtC)
        IRFt(t)        IRF100 at time t
        alpha(t)       Carbon decay time scaling factor
        SumAlpha      Placeholder variable for objective function;

**** IMPORTANT PROGRAMMING NOTE. Earlier implementations has reservoirs as non-negative.
**** However, these are not physical but mathematical solutions.
**** So, they need to be unconstrained so that can have negative emissions.
NONNEGATIVE VARIABLES   TATM, MAT,  IRFt, alpha

EQUATIONS
        FORCE(t)        Radiative forcing equation
        RES0LOM(t)      Reservoir 0 law of motion
        RES1LOM(t)      Reservoir 1 law of motion
        RES2LOM(t)      Reservoir 2 law of motion
        RES3LOM(t)      Reservoir 3 law of motion
        MMAT(t)         Atmospheric concentration equation
        Cacceq(t)       Accumulated carbon in sinks equation
        TATMEQ(t)       Temperature-climate equation for atmosphere
        TBOX1EQ(t)      Temperature box 1 law of motion
        TBOX2EQ(t)      Temperature box 2 law of motion
        IRFeqLHS(t)     Left-hand side of IRF100 equation
        IRFeqRHS(t)     Right-hand side of IRF100 equation
;
** Equations of the model
    res0lom(t+1)..   RES0(t+1) =E=  (emshare0*tau0*alpha(t+1)*(Eco2(t+1)/3.667))*(1-exp(-tstep/(tau0*alpha(t+1))))+Res0(t)*exp(-tstep/(tau0*alpha(t+1)));
    res1lom(t+1)..   RES1(t+1) =E=  (emshare1*tau1*alpha(t+1)*(Eco2(t+1)/3.667))*(1-exp(-tstep/(tau1*alpha(t+1))))+Res1(t)*exp(-tstep/(tau1*alpha(t+1)));
    res2lom(t+1)..   RES2(t+1) =E=  (emshare2*tau2*alpha(t+1)*(Eco2(t+1)/3.667))*(1-exp(-tstep/(tau2*alpha(t+1))))+Res2(t)*exp(-tstep/(tau2*alpha(t+1)));
    res3lom(t+1)..   RES3(t+1) =E=  (emshare3*tau3*alpha(t+1)*(Eco2(t+1)/3.667))*(1-exp(-tstep/(tau3*alpha(t+1))))+Res3(t)*exp(-tstep/(tau3*alpha(t+1)));
    mmat(t+1)..      MAT(t+1)  =E=   mateq+Res0(t+1)+Res1(t+1)+Res2(t+1)+Res3(t+1);
    cacceq(t)..      Cacc(t)   =E=  (CCATOT(t)-(MAT(t)-mateq));
    force(t)..       FORC(t)    =E=  fco22x*((log((MAT(t)/mateq))/log(2))) + F_Misc(t)+F_GHGabate(t);

    tbox1eq(t+1)..   Tbox1(t+1) =E=  Tbox1(t)*exp(-tstep/d1)+teq1*Forc(t+1)*(1-exp(-tstep/d1));
    tbox2eq(t+1)..   Tbox2(t+1) =E=  Tbox2(t)*exp(-tstep/d2)+teq2*Forc(t+1)*(1-exp(-tstep/d2));
    tatmeq(t+1)..    TATM(t+1)  =E=   Tbox1(t+1)+Tbox2(t+1);
    irfeqlhs(t)..    IRFt(t)   =E=  ((alpha(t)*emshare0*tau0*(1-exp(-100/(alpha(t)*tau0))))+(alpha(t)*emshare1*tau1*(1-exp(-100/(alpha(t)*tau1))))+(alpha(t)*emshare2*tau2*(1-exp(-100/(alpha(t)*tau2))))+(alpha(t)*emshare3*tau3*(1-exp(-100/(alpha(t)*tau3)))));
    irfeqrhs(t)..    IRFt(t)   =E=  irf0+irC*Cacc(t)+irT*TATM(t);

**  Upper and lower bounds for stability
MAT.LO(t)       = 10;
TATM.UP(t)      = 20;
TATM.lo(t)      = .5;
alpha.up(t) = 100;
alpha.lo(t) = 0.1;

* Initial conditions
MAT.FX(tfirst)    = mat0;
TATM.FX(tfirst)   = tatm0;
Res0.fx(tfirst) = Res00;
Res1.fx(tfirst) = Res10;
Res2.fx(tfirst) = Res20;
Res3.fx(tfirst) = Res30;
Tbox1.fx(tfirst) = Tbox10;
Tbox2.fx(tfirst) = Tbox20;

** Solution options
option iterlim = 99900;
option reslim = 99999;
option solprint = on;
option limrow = 0;
option limcol = 0;

