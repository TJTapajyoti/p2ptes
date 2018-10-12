Set
*        Define units: Src=source, Snk=sink, Mix=mixer, Spl=splitter
*                      Str=storage, MS1=in use, MS2=in recovery
         unit    units
        /Wash1, Grind1, Premix1, Jet1, Col1, Liq1, Sac1, Fer1, BC1,
         Rec1, Ads1, MS1*MS2, MecP1*MecP2, Flot1*Flot2, Dry1, WWT1,
         HX1*HX12, Cond1, Cond2, Src1*Src9, Snk1*Snk9, Str1*Str2,
         Mix2*Mix7, Spl1*Spl7/

*        Define subsets of units
         HX(unit) heat exchangers
        /HX1*HX12/

         Mix(unit) mixers
        /Mix2*Mix7/

        Mix_v(Mix) mixers with vapor inlet
                 /Mix4*Mix7/
        Mix_l(Mix) mixers with liquid inlet
                 /Mix2*Mix3/

         Spl(unit) splitter
         /Spl1*Spl7/

         Src(unit) sources
         /Src1*Src9/

         Snk(unit) sinks
         /Snk1*Snk9/

         Column(Unit) distillation columns
         /BC1,Rec1/

*        Define components
         J       components
         /Wa, Star, Gluc, Malt, Prot, Etho, Glyc, SucA, AceA, LacA, Urea,
         CellM, CO2, O2, Cellu, HCellu, Oil, Ash/

         liquids(J)
         /Wa, Etho, Glyc, AceA, LacA, Oil/

         solids(J)
         /Star, Prot, CellM, Cellu, HCellu, Ash/

         h(J)    water and ethanol
         /Wa, Etho/

*        Define reactions; Star_Malt is reaction starch to maltose etc.
*        Note: star_gluc in Sac1 is neglected
         react
         /Star_Malt, Malt_Gluc, Gluc_Etho, Gluc_Glyc, Gluc_SucA, Gluc_AceA,
         Gluc_LacA, Gluc_CellM/

*        running variable for vapor pressure correlation
         l /1*3/


Alias(unit, unit1)
Alias(h,h1)



*Data

Parameters

*        feedstock composition in mass fractions: corn, #2 yellow dent
         x_0(J)
         /Wa             0.15
          Star           0.6185
          Gluc           0.0162
          Malt           0
          Prot           0.076
          Etho           0
          Glyc           0
          SucA           0
          AceA           0
          LacA           0
          Urea           0
          CellM          0
          CO2            0
          O2             0
          Cellu          0.0274
          HCellu         0.0638
          Oil            0.0354
          Ash            0.0127/

*        composition of adsorbend - corn grits
         x_ads(J)
         /Wa             0
          Star           0.881
          Gluc           0
          Malt           0
          Prot           0.0847
          Etho           0
          Glyc           0
          SucA           0
          AceA           0
          LacA           0
          Urea           0
          CellM          0
          CO2            0
          O2             0
          Cellu          0.0069
          HCellu         0.0161
          Oil            0.0079
          Ash            0.0034/

*        individual liquid heat capacity of a component (average in a range 20 C - 100 C)
*        in kJ/(kg*C), assume: constant heat capacities and c_p_ind('CellM')=c_p_ind('Wa')
         c_p_ind(J)
         /Wa             4.19
          Star           1.64
          Gluc           1.64
          Malt           1.64
          Prot           2.07
          Etho           2.83
          Glyc           1.0477
          SucA           0.6079
          AceA           0.6687
          LacA           0.8706
          Urea           0
          CellM          4.19
          CO2            0
          O2             0
          Cellu          1.94
          HCellu         1.94
          Oil            2.23
          Ash            1.19/


*        standard heat of vaporization: kJ/kg
         dH_vap_0(h)
        /Wa      2254.62
         Etho    840.192/

*        critical temperature: C
         Tc(h)
        /Wa      374.15
         Etho    243.05/

*        boiling point temperature: C
         Tb(h)
        /Wa      100
         Etho    78.35/

*        Molecular weight: g/mol
         MW(h)
        /Wa             18.015
         Etho           46.069/

*        conversion of the individual reactions
         conv(react)
        /Star_Malt      0.99
         Malt_Gluc      0.99
         Gluc_Etho      0.470496
         Gluc_Glyc      0.034762
         Gluc_SucA      0.01319
         Gluc_AceA      0.0024
         Gluc_LacA      0.002
         Gluc_CellM     0.025919/

*        density in kg/l; assume: constant density
         dens(h)
        /Wa     1
         Etho    0.787/

*        individual vapor heat capacity (average in a range 80 C - 100 C)
*        assume: constant heat capacities
         c_p_v(h)
        /Wa      1.89
         Etho    1.67/

Scalar   n_watson        exponent in Watson correlation /0.38/;

Table
*        vapor pressure coefficients: mmHq, T= C
*        750 mmHq = 1bar, 760mmHq = 1atm
*        ln(p_k)= coef_p(h,1)-coef_p(h,2)/(T+coef_p(h,3))
*        Data from Biegler's database
         coef_p(h,l)
                 1        2        3
         Wa      18.3036  3816.44  227.02
         Etho    18.9119  3803.98  231.47
         ;



SET      Arc(unit,unit1) stream matrix;

*setting entries in stream matrix
***Arc is unknown symbol***
Arc(unit, unit1)=No;

*Define all existing streams Arc('1','2') is stream from unit 1 to unit 2

*Washing
Arc('Src1','Wash1')=Yes;
Arc('Src2','Wash1')=Yes;
Arc('Wash1','Grind1')=Yes;

*Grinding
Arc('Grind1','Mix2')=Yes;
Arc('Mix2','HX1')=Yes;
Arc('Src3','Mix2')=Yes;
Arc('Spl6','Mix2')=Yes;

*Cooking
Arc('HX1','Premix1')=Yes;
Arc('Premix1','Jet1')=Yes;
Arc('Src4','Jet1')=Yes;
Arc('Jet1','Col1')=Yes;
Arc('Col1','Liq1')=Yes;
Arc('Src5','Liq1')=Yes;
Arc('Liq1','HX2')=Yes;
Arc('HX2','Sac1')=Yes;
Arc('Src6','Sac1')=Yes;
Arc('Sac1','HX3')=Yes;

*Fermentation
Arc('HX3','Mix3')=Yes;
Arc('Src7','Mix3')=Yes;
Arc('Mix3','Str1')=Yes;
Arc('Fer1','Snk1')=Yes;
Arc('Str2','Spl1')=Yes;
*Note:stream Str1_Fer1, Fer1_Str2 are covered by the fermenter eq. and the don't have to be defined

*Liquid-Solid separation
Arc('Spl1','MecP1')=Yes;
Arc('Spl1','HX4')=Yes;
Arc('MecP1','Flot1')=Yes;
Arc('MecP1','Dry1')=Yes;
Arc('Flot1','HX4')=Yes;
Arc('Flot1','Dry1')=Yes;
Arc('HX4','BC1')=Yes;
Arc('BC1','Spl2')=Yes;
Arc('BC1','Spl3')=Yes;
Arc('Spl3','HX11')=Yes;
Arc('HX11','WWT1')=Yes;
Arc('Spl3','MecP2')=Yes;
Arc('MecP2','Dry1')=Yes;
Arc('MecP2','Flot2')=Yes;
Arc('Flot2','WWT1')=Yes;
Arc('Flot2','Dry1')=Yes;
Arc('WWT1','Snk7')=Yes;
Arc('WWT1','Snk6')=Yes;
Arc('Dry1','Spl7')=Yes;
Arc('Dry1','HX10')=Yes;
Arc('HX10','Snk8')=Yes;
Arc('Spl7','HX4')=Yes;
Arc('Spl7','Snk9')=Yes;

*Ethanol purification
Arc('Spl2','Mix4')=Yes;
Arc('Spl2','Mix5')=Yes;
Arc('Spl2','Mix6')=Yes;
Arc('Mix4','Rec1')=Yes;
Arc('Mix5','Ads1')=Yes;
Arc('Mix6','HX7')=Yes;
Arc('HX7','MS1')=Yes;
Arc('Rec1','Spl4')=Yes;
Arc('Rec1','Snk2')=Yes;
Arc('Ads1','Spl6')=Yes;
Arc('Spl6','Snk3')=Yes;
Arc('Ads1','Spl5')=Yes;
Arc('Src9','HX6')=Yes;
Arc('HX6','Ads1')=Yes;
Arc('MS1','Mix7')=Yes;
Arc('MS1','MS2')=Yes;
Arc('Src8','HX8')=Yes;
Arc('HX8','MS2')=Yes;
Arc('MS2','HX9')=Yes;
Arc('HX9','Snk4')=Yes;
Arc('Spl4','Mix5')=Yes;
Arc('Spl4','Mix6')=Yes;
Arc('Spl4','Mix7')=Yes;
Arc('Spl5','Mix4')=Yes;
Arc('Spl5','Mix6')=Yes;
Arc('Spl5','Mix7')=Yes;
Arc('Mix7','Cond1')=Yes;
Arc('Cond1','HX5')=Yes;
Arc('HX5','Snk5')=Yes;
Arc('Spl7','Cond2')=Yes;
Arc('Cond2','HX4')=Yes;


Positive Variables
*        streams and mass fractions: all in kg/s
         fc(J,unit,unit1)        individual components streams
         x(J,unit,unit1)         mass fraction of comp J in stream

*        vapor pressure: water and etho
         p_v(h,unit,unit1)       vapor pressure in bar

*        temperatures in C
         T(unit,unit1)          temperature of stream in C

*        power
         W(Unit)                 power consumption of unit in kW (efficiency included)

         m_frac(h,unit,unit1)    mol fraction of water or ethanol
         ;

Variables
*        heat
         Q(Unit)         heat produced or consumed in unit (efficiency included)
         Q_cond(column)  heat load of condenser of column
         Q_reb(column)   heat load of reboiler of column

         Z               objective function value ;

Parameter
*        temperatures in C
         Tmp(unit,unit1)          temperature of stream in C
/Grind1.Mix2 0/;



Tmp('Grind1','Mix2') = 20;
Tmp('Src3','Mix2') = 20;
Tmp('HX1','Premix1') = 60;
Tmp('Premix1','Jet1') = 60;
Tmp('Jet1','Col1') = 120;
Tmp('Col1','Liq1') = 85;
Tmp('Src3','Mix2') = 20;
Tmp('HX1','Premix1') = 60;
Tmp('HX2','Sac1') = 75;
Tmp('Liq1','HX2') = 85;
Tmp('Sac1','HX3') = 75;
Tmp('Src7','Mix3') = 20;
Tmp('Mix3','Str1') = 32;
Tmp('Str2','Spl1') = 32;
Tmp('Spl1','MecP1') = 32;
Tmp('Spl1','HX4') = 32;
Tmp('MecP1','Dry1') = 32;
Tmp('MecP1','Flot1') = 32;
Tmp('Flot1','HX4') = 32;
Tmp('Flot1','Dry1') = 32;
Tmp('HX11','WWT1') = 25;
Tmp('Dry1','HX10') = 100;
Tmp('Dry1','Spl7') = 100;
Tmp('Spl7','Cond2')= 100;
Tmp('Spl7','Snk9') = 100;
Tmp('HX5','Snk5') = 25;
Tmp('HX9','Snk4') = 25;
Tmp('HX10','Snk8') = 25;
Tmp('Src8','HX8') = 20;
Tmp('HX8','MS2') = 95;
Tmp('MS2','HX9') = 95;
Tmp('HX7','MS1') = 95;
Tmp('MS1','MS2') = 95;
Tmp('MS1','Mix7') = 95;
Tmp('Src9','HX6') = 20;
Tmp('HX6','Ads1') = 91;
Tmp('Ads1','Spl6') = 91;
Tmp('Spl6','Mix2') = 91;
Tmp('Spl6','Snk3') = 91;
Tmp('Ads1','Spl5') = 91;
Tmp('Spl5','Mix4')= 91;
Tmp('Spl5','Mix6') = 91;
Tmp('Spl5','Mix7') = 91;

*Define global bounds and fix specific variables

*mass fractions
x.UP(J,unit,unit1)$Arc(unit,unit1)=1;

*Component streams
fc.UP(J,unit,unit1)$Arc(unit,unit1)=220;

fc.up(J,unit,unit1)$(not Arc(unit,unit1)) = 0;


*Specifying heat consumption of certain units
Q.Fx('Wash1')=0;
Q.Fx('Grind1')=0;
Q.Fx('Premix1')=0;
*Q.Fx('Jet1')=0;
Q.Fx('Liq1')=0;
Q.Fx('Sac1')=0;
Q.Fx('MecP1')=0;
Q.Fx('MecP2')=0;
Q.Fx('Flot1')=0;
Q.Fx('Flot2')=0;
Q.Fx('WWT1')=0;
Q.Fx('BC1')=0;
Q.Fx(Mix)=0;
Q.Fx(Spl)=0;
Q.Fx(Src)=0;
Q.Fx(Snk)=0;

*It is assumed that the heat of adsorption is stored in the bed and
*then the bed provides the heat of desorption
Q.Fx('MS1')=0;
Q.Fx('MS2')=0;


*Specify power consumption for cerain units

$ontext
power consumption of all pumps neglected
power consumption for stirring in Premix1, Li1, Sac1, Fer1 neglected
power consumption on dryer and flotation units neglected
$offtext

W.Fx('Wash1')=0;
W.Fx('Premix1')=0;
W.Fx('Jet1')=0;
W.Fx('Liq1')=0;
W.Fx('Sac1')=0;
W.Fx('Fer1')=0;
W.Fx('Flot1')=0;
W.Fx('Flot2')=0;
W.Fx('WWT1')=0;
W.Fx('Dry1')=0;
W.Fx('BC1')=0;
W.Fx('Rec1')=0;
W.Fx('Ads1')=0;
W.Fx('MS1')=0;
W.Fx('Cond1')=0;
W.Fx(Mix)=0;
W.Fx(Spl)=0;
W.Fx(Src)=0;
W.Fx(Snk)=0;
W.Fx(HX)=0;


*Temperature settings

Scalars
*Define temperatures in C
*Data for premix, cook, liq, sac, fer from alcohol textbook (mean values)
         T_amb           ambient temperature /20/
         T_cooldown      cool down temperature /25/
         T_premix        temperature in premixer /60/
         T_cook          temperature in cooker /120/
         T_liq           liquefaction temperature /85/
         T_sac           saccharification temperature /75/
         T_fer           fermentation temperature /32/
         T_MS1           adsorption temperature in MS1 /95/
         T_MS2           desorption temperature in MS2 /95/
         T_Ads           temperature for adsorption on corn grits /91/
         T_dry           drying temperature /100/
         dT_min          EMAT /5/
         T_max           max temperature for a process stream /120/
         T_steam_max     max steam temperature /300/;


*global temperature bounds - bounds get redefined for specific streams
T.LO(unit,unit1)=T_amb;
T.UP(unit,unit1)=300;

*Specifying temperatures
*Pretreatment
T.Fx('Src1','Wash1')=T_amb;
T.Fx('Src2','Wash1')=T_amb;
T.Fx('Wash1','Grind1')=T_amb;
T.Fx('Grind1','Mix2')=T_amb;
T.Fx('Src3','Mix2')=T_amb;
T.Fx('HX1','Premix1')=T_premix;
T.Fx('Premix1','Jet1')=T_premix;
T.Fx('Jet1','Col1')=T_cook;
T.Fx('Col1','Liq1')=T_liq;
T.Fx('Src5','Liq1')=T_liq;
T.Fx('Liq1','HX2')=T_liq;
T.Fx('HX2','Sac1')=T_sac;
T.Fx('Src6','Sac1')=T_sac;
T.Fx('Sac1','HX3')=T_sac;
T.FX('Src7','Mix3')=T_amb;
T.FX('Mix3','Str1')=T_fer;

*Liquid-solid separation
T.Fx('Str2','Spl1')=T_fer;
T.Fx('Spl1','MecP1')=T_fer;
T.Fx('Spl1','HX4')=T_fer;
T.Fx('MecP1','Dry1')=T_fer;
T.Fx('MecP1','Flot1')=T_fer;
T.Fx('Flot1','HX4')=T_fer;
T.Fx('Flot1','Dry1')=T_fer;
T.Fx('HX11','WWT1')=T_cooldown;

*Dryer
T.FX('Dry1','HX10')=T_dry;
T.FX('Dry1','Spl7')=T_dry;
T.FX('Spl7','Snk9')=T_dry;

T.UP('Cond2','HX4')=T_dry;

*Sinks
T.Fx('HX5','Snk5')=T_cooldown;
T.Fx('HX9','Snk4')=T_cooldown;
T.Fx('HX10','Snk8')=T_cooldown;

*Ethanol purification
T.Fx('Src8','HX8')=T_amb;
T.Fx('HX8','MS2')=T_MS2;
T.Fx('MS2','HX9')=T_MS2;
T.Fx('HX7','MS1')=T_MS1;
T.Fx('MS1','MS2')=T_MS1;
T.Fx('MS1','Mix7')=T_MS1;
T.FX('Src9','HX6')=T_amb;
T.FX('HX6','Ads1')=T_ads;
T.FX('Ads1','Spl6')=T_ads;
T.FX('Spl6','Mix2')=T_ads;
T.FX('Spl6','Snk3')=T_ads;
T.FX('Ads1','Spl5')=T_ads;
T.FX('Spl5','Mix4')=T_ads;
T.FX('Spl5','Mix6')=T_ads;
T.FX('Spl5','Mix7')=T_ads;

*bounds for steam temperatures in jet cooker
T.UP('Src4','Jet1')=T_steam_max;
T.LO('Src4','Jet1')=T_cook;
T.L('Src4','Jet1')=(T_cook+T_steam_max)*0.5;

T.Fx('MecP2','Dry1')=T_cooldown;
T.Fx('MecP2','Flot2')=T_cooldown;
T.Fx('Flot2','Dry1')=T_cooldown;
T.Fx('Flot2','WWT1')=T_cooldown;

T.LO('HX3','Mix3') =  25;
T.UP('HX3','Mix3') =  100;
T.L('HX3','Mix3')=50;



$ontext
Here all src streams, which have specified values for a 60MGal/yr
plant, are fixed.
Source 1 can be found in the data.
$offtext


*src2: net consumption of washing water; pure water in src2
fc.Fx('Star','Src2','Wash1')=0;
fc.Fx('Gluc','Src2','Wash1')=0;
fc.Fx('Malt','Src2','Wash1')=0;
fc.Fx('Prot','Src2','Wash1')=0;
fc.Fx('Etho','Src2','Wash1')=0;
fc.Fx('Glyc','Src2','Wash1')=0;
fc.Fx('SucA','Src2','Wash1')=0;
fc.Fx('AceA','Src2','Wash1')=0;
fc.Fx('LacA','Src2','Wash1')=0;
fc.Fx('Urea','Src2','Wash1')=0;
fc.Fx('CellM','Src2','Wash1')=0;
fc.Fx('CO2','Src2','Wash1')=0;
fc.Fx('O2','Src2','Wash1')=0;
fc.Fx('Cellu','Src2','Wash1')=0;
fc.Fx('HCellu','Src2','Wash1')=0;
fc.Fx('Oil','Src2','Wash1')=0;
fc.Fx('Ash','Src2','Wash1')=0;



*Src3 contains only water
fc.UP('Wa','Src3','Mix2')=45;
fc.L('Wa','Src3','Mix2')=fc.UP('Wa','Src3','Mix2');
fc.lo('Wa','Src3','Mix2')= 0;

fc.Fx('Star','Src3','Mix2')=0;
fc.Fx('Gluc','Src3','Mix2')=0;
fc.Fx('Malt','Src3','Mix2')=0;
fc.Fx('Prot','Src3','Mix2')=0;
fc.Fx('Etho','Src3','Mix2')=0;
fc.Fx('Glyc','Src3','Mix2')=0;
fc.Fx('SucA','Src3','Mix2')=0;
fc.Fx('AceA','Src3','Mix2')=0;
fc.Fx('LacA','Src3','Mix2')=0;
fc.Fx('Urea','Src3','Mix2')=0;
fc.Fx('CellM','Src3','Mix2')=0;
fc.Fx('CO2','Src3','Mix2')=0;
fc.Fx('O2','Src3','Mix2')=0;
fc.Fx('Cellu','Src3','Mix2')=0;
fc.Fx('HCellu','Src3','Mix2')=0;
fc.Fx('Oil','Src3','Mix2')=0;
fc.Fx('Ash','Src3','Mix2')=0;


*Src4 contains only steam
*Steam temperature is bounded above
fc.UP('Wa','Src4','Jet1')=70;
fc.LO('Wa','Src4','Jet1')=0.01;
fc.L('Wa','Src4','Jet1')=0;

fc.Fx('Star','Src4','Jet1')=0;
fc.Fx('Gluc','Src4','Jet1')=0;
fc.Fx('Malt','Src4','Jet1')=0;
fc.Fx('Prot','Src4','Jet1')=0;
fc.Fx('Etho','Src4','Jet1')=0;
fc.Fx('Glyc','Src4','Jet1')=0;
fc.Fx('SucA','Src4','Jet1')=0;
fc.Fx('AceA','Src4','Jet1')=0;
fc.Fx('LacA','Src4','Jet1')=0;
fc.Fx('Urea','Src4','Jet1')=0;
fc.Fx('CellM','Src4','Jet1')=0;
fc.Fx('CO2','Src4','Jet1')=0;
fc.Fx('O2','Src4','Jet1')=0;
fc.Fx('Cellu','Src4','Jet1')=0;
fc.Fx('HCellu','Src4','Jet1')=0;
fc.Fx('Oil','Src4','Jet1')=0;
fc.Fx('Ash','Src4','Jet1')=0;


*Src5 contains only enzyme
fc.UP('Prot','Src5','Liq1')=0.5;
fc.LO('Prot','Src5','Liq1')=0.001;
fc.L('Prot','Src5','Liq1')=0.009;

fc.Fx('Wa','Src5','Liq1')=0;
fc.Fx('Star','Src5','Liq1')=0;
fc.Fx('Gluc','Src5','Liq1')=0;
fc.Fx('Malt','Src5','Liq1')=0;
fc.Fx('Etho','Src5','Liq1')=0;
fc.Fx('Glyc','Src5','Liq1')=0;
fc.Fx('SucA','Src5','Liq1')=0;
fc.Fx('AceA','Src5','Liq1')=0;
fc.Fx('LacA','Src5','Liq1')=0;
fc.Fx('Urea','Src5','Liq1')=0;
fc.Fx('CellM','Src5','Liq1')=0;
fc.Fx('CO2','Src5','Liq1')=0;
fc.Fx('O2','Src5','Liq1')=0;
fc.Fx('Cellu','Src5','Liq1')=0;
fc.Fx('HCellu','Src5','Liq1')=0;
fc.Fx('Oil','Src5','Liq1')=0;
fc.Fx('Ash','Src5','Liq1')=0;



*Src6 contains only enzyme
fc.UP('Prot','Src6','Sac1')=13;
fc.LO('Prot','Src6','Sac1')=0.001;
fc.L('Prot','Src6','Sac1')=0.0216;

fc.Fx('Wa','Src6','Sac1')=0;
fc.Fx('Star','Src6','Sac1')=0;
fc.Fx('Gluc','Src6','Sac1')=0;
fc.Fx('Malt','Src6','Sac1')=0;
fc.Fx('Etho','Src6','Sac1')=0;
fc.Fx('Glyc','Src6','Sac1')=0;
fc.Fx('SucA','Src6','Sac1')=0;
fc.Fx('AceA','Src6','Sac1')=0;
fc.Fx('LacA','Src6','Sac1')=0;
fc.Fx('Urea','Src6','Sac1')=0;
fc.Fx('CellM','Src6','Sac1')=0;
fc.Fx('CO2','Src6','Sac1')=0;
fc.Fx('O2','Src6','Sac1')=0;
fc.Fx('Cellu','Src6','Sac1')=0;
fc.Fx('HCellu','Src6','Sac1')=0;
fc.Fx('Oil','Src6','Sac1')=0;
fc.Fx('Ash','Src6','Sac1')=0;



*Src7 contains only water, urea and yeast(cell mass)
fc.Fx('Star','Src7','Mix3')=0;
fc.Fx('Gluc','Src7','Mix3')=0;
fc.Fx('Malt','Src7','Mix3')=0;
fc.Fx('Prot','Src7','Mix3')=0;
fc.Fx('Etho','Src7','Mix3')=0;
fc.Fx('Glyc','Src7','Mix3')=0;
fc.Fx('SucA','Src7','Mix3')=0;
fc.Fx('AceA','Src7','Mix3')=0;
fc.Fx('LacA','Src7','Mix3')=0;
fc.Fx('CO2','Src7','Mix3')=0;
fc.Fx('O2','Src7','Mix3')=0;
fc.Fx('Cellu','Src7','Mix3')=0;
fc.Fx('HCellu','Src7','Mix3')=0;
fc.Fx('Oil','Src7','Mix3')=0;
fc.Fx('Ash','Src7','Mix3')=0;


*Cragill. 0.00027654 kg_yeast/kg_corn * 18 kg_corn/s
*assume: same amount of yeast is needed, if corn grits are used
fc.Fx('CellM','Src7','Mix3')=0.004977;

fc.UP('Wa','Src7','Mix3')=150;
fc.L('Wa','Src7','Mix3')=5;
fc.LO('Wa','Src7','Mix3')=0;

fc.UP('Urea','Src7','Mix3')=15;
fc.LO('Urea','Src7','Mix3')=0.01;
fc.L('Urea','Src7','Mix3')=10;



parameter
*        heat of evaporation
         dH_v(h,unit,unit1)      individual heat of vap. (KJ per kg)  ;

dH_v(h,'Dry1','Spl7') = dH_vap_0(h)*((Tc(h)-Tmp('Dry1','Spl7'))/(Tc(h)-Tb(h)))**n_watson;



Equations
         Wash_1, Wash_2, Wash_3

         Grind_1;


****THAT'S NOT GOING TO WORK THIS WAY - FIX ETHO OUTLET LATER****
*For a 60 MGal/yr ethanol plant, about 18 kg_corn/s is needed


*Washing: Wash1
Scalar   frac_wash       fraction of washing water that stays with the corn /0.01/
         min_wash        min amount of washing water (kg per kg corn) /0.5/
         Fcorn           Total amount of corn entering the plant      /18/;
*        min_wash is guessed, frac_wash according to Cargill


*composition of src1 is given, F('Src1','Wash1') total amount of corn proceed
Wash_3.. fc('Wa','Src2','Wash1') =E= min_wash*frac_wash*Fcorn;

Wash_1(J)..
         fc(J,'Src1','Wash1') =E= x_0(J)*Fcorn;

Wash_2(J)..
         fc(J,'Wash1','Grind1') =E= fc(J,'Src1','Wash1') +fc(J,'Src2','Wash1');

Grind_1(J)..
         fc(J,'Grind1','Mix2') =E= fc(J,'Wash1','Grind1');

*I am adding temporary variables for every equation to make them linear. For that I am disintegrating equations to make them simple.
*This is leading to writing of more equations and introduction of many new temporary variables.

Equations
         Mix2_1,HX1_1,Mix2_3,Mix2_2,HX1_2;
Variable Mix2_temp1,Mix2_temp2,temp;

*,Mix2_2,

Mix2_1(J)..
         fc(J,'Mix2','HX1') =E= fc(J,'Grind1','Mix2')+fc(J,'Src3','Mix2');



HX1_1(J)..
         fc(J,'HX1','Premix1') =E= fc(J,'Mix2','HX1');

Mix2_3.. Mix2_temp1 =E= sum(J,fc(J,'Mix2','HX1')*c_p_ind(J));

*Calculate Outlet temperature of mixer
*Mix2_2.. Mix2_temp1*(T('Mix2','HX1')-Tmp('Grind1','Mix2'))  +
*         Mix2_temp2*(T('Mix2','HX1')-Tmp('Src3','Mix2'))
*         =E= 0;

*Linearized by finding that the temperature is constant.

Mix2_2.. T('Mix2','HX1') =E= (Tmp('Grind1','Mix2') + Tmp('Src3','Mix2'))/2;



HX1_2..  Q('HX1') =E= sum(J,fc(J,'Mix2','HX1')*c_p_ind(J))*
         (Tmp('HX1','Premix1')-(Tmp('Grind1','Mix2') + Tmp('Src3','Mix2'))/2);

Equations
         Premix_1

         Jet_Cook_1,Jet_Cook_4

  Jet_Cook_3,Col1_1, Col1_2;
;


Premix_1(J)..
         fc(J,'Premix1','Jet1') =E= fc(J,'HX1','Premix1');

Jet_Cook_1(J)..
         fc(J,'Jet1','Col1') =E= fc(J,'Premix1','Jet1')+fc(J,'Src4','Jet1');

*Linearized as value is constant.

dH_v('Wa','Jet1','Col1') = 2190.6453;



Jet_Cook_4..
         Q('Jet1') =E= sum(J,fc(J,'Premix1','Jet1')*c_p_ind(J))*(Tmp('Jet1','Col1')-Tmp('Premix1','Jet1'));

*Linearized by using Taylor Series Expansion
Jet_Cook_3..  2498.2201+2530.8453*(fc('Wa','Src4','Jet1')-0.9041)+1.708*(T('Src4','Jet1')-300) =E= Q('Jet1');

Col1_1(J)..
         fc(J,'Col1','Liq1') =E= fc(J,'Jet1','Col1');

Col1_2.. Q('Col1') =E= sum(J,fc(J,'Jet1','Col1')*c_p_ind(J))*(Tmp('Col1','Liq1')-Tmp('Jet1','Col1'));

Equations
         Liq_1, Liq_2, Liq_3, Liq_4, Liq_5

         HX2_1,HX2_2;

*Liquefaction
Scalars
         Wa_star_malt    stoch. water requirement for reaction starch to maltose /0.0555/
         Wa_malt_gluc    stoch. water requirement for reaction maltose to glucose /0.0526/
         Wa_abundant     /1.5/
         Enz_Liq         enzyme requirement in liquefaction kg per kg feedstock /0.0005/;

Liq_2..  fc('Prot','Src5','Liq1') =E= Enz_Liq*sum(J,fc(J,'Col1','Liq1'));

Liq_1(J)$((ord(J) ne 1) and (ord(J) ne 2) and (ord(J) ne 4))..
         fc(J,'Liq1','HX2') =E= fc(J,'Col1','Liq1')+fc(J,'Src5','Liq1');

Liq_3..
         fc('Star','Liq1','HX2') =E= (fc('Star','Col1','Liq1')
         +fc('Star','Src5','Liq1'))*(1-conv('Star_Malt'));

Liq_4..  fc('Malt','Liq1','HX2') =E=(1+Wa_star_malt)*conv('star_malt')*(fc('Star','Col1','Liq1')
         +fc('Star','Src5','Liq1'))+fc('Malt','Col1','Liq1')+fc('Malt','Src5','Liq1');

Liq_5..  fc('Wa','Liq1','HX2') =E= fc('Wa','Col1','Liq1')+fc('Wa','Src5','Liq1')
         -Wa_star_malt*conv('Star_Malt')*(fc('Star','Col1','Liq1')+fc('Star','Src5','Liq1'));

HX2_1(J)..
         fc(J,'HX2','Sac1') =E= fc(J,'Liq1','HX2');

HX2_2..  Q('HX2') =E= Sum(J,fc(J,'Liq1','HX2')*c_p_ind(J))*(Tmp('HX2','Sac1')-Tmp('Liq1','HX2'));



Equations
         Sac_1, Sac_2, Sac_3, Sac_4, Sac_5

         HX3_1;


*Saccharification:Sac1
Scalar   Enz_Sac         enzyme requirement in saccarafication kg per kg feedstock /0.0012/;

*for all components J except water, maltose, glucose
Sac_1(J)$((ord(J) ne 1) and (ord(J) ne 3) and (ord(J) ne 4))..
         fc(J,'Sac1','HX3') =E= fc(J,'HX2','Sac1')+fc(J,'Src6','Sac1');

*Amount of enzyme from alcohol textbook: proportional to amount of feedstock
Sac_2..  fc('Prot','Src6','Sac1') =E= Enz_Sac*sum(J,fc(J,'HX2','Sac1'));

Sac_3..  fc('Gluc','Sac1','HX3') =E= fc('Gluc','HX2','Sac1')+fc('Gluc','Src6','Sac1')
         +(1+Wa_malt_gluc)*conv('Malt_Gluc')*(fc('Malt','HX2','Sac1')
         +fc('Malt','Src6','Sac1'));

Sac_4..  fc('Malt','Sac1','HX3') =E= (fc('Malt','HX2','Sac1')
         +fc('Malt','Src6','Sac1'))*(1-conv('Malt_Gluc'));

Sac_5..  fc('Wa','Sac1','HX3') =E= fc('Wa','HX2','Sac1')+fc('Wa','Src6','Sac1')
         -Wa_malt_gluc*conv('Malt_Gluc')*(fc('Malt','HX2','Sac1')
         +fc('Malt','Src6','Sac1'));


*Heat exchanger 3
*T('HX2','Sac1') and T('Liq1','HX2') are fixed

HX3_1(J)..
         fc(J,'HX3','Mix3') =E= fc(J,'Sac1','HX3');


Variable
         Mix3_temp1,Mix3_temp2;


Equations
         Mix3_1,Mix3_3,Mix3_4,Mix3_2,HX3_2;

fc.fx('CellM','Src7','Mix3')= 0.004977;

Mix3_1(J)..
         fc(J,'Mix3','Str1') =E= fc(J,'HX3','Mix3')+fc(J,'Src7','Mix3');

Mix3_3.. Mix3_temp1 =E= Sum(J,fc(J,'HX3','Mix3')*c_p_ind(J));

Mix3_4.. Mix3_temp2 =E= Sum(J,fc(J,'Src7','Mix3')*c_p_ind(J));
*Taylor Series Linearization
Mix3_2.. 32*38.8863-38.8863*38.7198+(32-38.7198)*(Mix3_temp1-38.8863)-38.8863*(T('HX3','Mix3')-38.7198)+Sum(J,fc(J,'Src7','Mix3')*c_p_ind(J))*(Tmp('Mix3','Str1')-Tmp('Src7','Mix3')) =E= 0;
*Taylor Series Linearization
HX3_2..  Q('HX3') =E= 38.8863*38.7198-Tmp('Sac1','HX3')*38.8863+(Mix3_temp2-38.8863)*(38.7198-Tmp('Sac1','HX3'))+(T('HX3','Mix3')-38.7198)*38.8863;




Equations
         Fer_3, Fer_4, Fer_5, Fer_6, Fer_7, Fer_8, Fer_9, Fer_10
         Fer_11, Fer_12, Fer_13, Fer_14, Fer_15, Fer_16, Fer_17, Fer_18
         Fer_19, Fer_21, Fer_22;

*Fer_3,Fer_16;

*Fermentation: Fer1
Variables
         mc_in(J)        inlet mass of component for one fermenter
         mc_out(J)       outlet mass of component for one fermenter (time dependent)
         ;

mc_in.LO(J) = 0;
mc_out.LO(J) = 0;
mc_in.L(J) = 10;
mc_out.L(J) = 10;
mc_in.UP(J) = 3000000;
mc_out.UP(J) = 3000000;

Parameter t_l             lack time in h /4/
          t_f_max         time after which fermentation is complete /26/
          sugar_max       max sugar mass fraction (inlet) /0.21/
          etho_max        max etho mass fraction (outlet) /0.16/
          SucA_max        max succinic a. mass fraction (outlet) /0.0033/
          AceA_max        max acetic a. mass fraction (outlet) /0.00055/
          LacA_max        max lactic a. mass fraction (outelt) /0.0089/
          solid_max       max solid load for fermenter   /0.36/
          t_f             fermentation time in h      /26/;

Parameters

*        conversion of the individual reactions
         conv_t(react)
        /Star_Malt      0.99
         Malt_Gluc      0.99
         Gluc_Etho      0.470496
         Gluc_Glyc      0.034762
         Gluc_SucA      0.01319
         Gluc_AceA      0.0024
         Gluc_LacA      0.002
         Gluc_CellM     0.025919/  ;




Fer_3(J)..
         mc_in(J) =E= (t_l+t_f)*fc(J,'Mix3','Str1')*3600;


Fer_16.. mc_in('Urea') =E= 0.006955*t_f/t_f_max*mc_in('Gluc');


Fer_4(J)$((Ord(J) ne 1) and (Ord(J) ne 3) and (Ord(J) ne 6) and (Ord(J) ne 7) and
         (Ord(J) ne 8) and (Ord(J) ne 9) and (Ord(J) ne 10) and (Ord(J) ne 11)
         and (Ord(J) ne 12) and (Ord(J) ne 13) and (Ord(J) ne 14))..
         mc_out(J) =E= mc_in(J);
Fer_5..  mc_out('Etho') =E= mc_in('Etho')
         + conv_t('gluc_etho')*mc_in('Gluc');

Fer_6..  mc_out('Glyc') =E= mc_in('Glyc')
         + conv_t('gluc_glyc')*mc_in('Gluc');

Fer_7..  mc_out('SucA') =E= mc_in('SucA')
         + conv_t('gluc_sucA')*mc_in('Gluc');

Fer_8..  mc_out('AceA') =E= mc_in('AceA')
         + conv_t('gluc_aceA')*mc_in('Gluc');

Fer_9..  mc_out('LacA') =E= mc_in('LacA')
         + conv_t('gluc_lacA')*mc_in('Gluc');

Fer_10.. mc_out('CellM') =E= mc_in('CellM')
         + conv_t('gluc_cellM')*mc_in('Gluc');

Fer_11.. mc_out('Gluc') =E= mc_in('Gluc')*(1-t_f/t_f_max) ;

Fer_12.. mc_out('urea') =E= (1.1-t_f/t_f_max)*mc_in('urea');

Fer_13.. mc_out('Wa') =E= mc_in('Wa')
         - 0.00111*t_f/t_f_max*mc_in('Gluc');

Fer_14.. mc_out('CO2') =E= mc_in('CO2')
         +0.449*t_f/t_f_max*mc_in('Gluc');

Fer_15.. mc_out('O2') =E= mc_in('O2')
         +0.00949*t_f/t_f_max*mc_in('Gluc');

*connect mass at end of fermentation to outlet streams
Fer_17(J)$((Ord(J) ne 13) and (Ord(J) ne 14))..
          fc(J,'Str2','Spl1')*(t_l+t_f)*3600 =E= mc_out(J);
Fer_21..  fc('CO2','Str2','Spl1')=E= 0;
Fer_22..  fc('O2','Str2','Spl1')=E= 0;

*just Co2 and O2 in stream Fer1 to Snk1
Fer_18.. fc('CO2','Fer1','Snk1')*(t_l+t_f)*3600 =E= mc_out('CO2');

Fer_19.. fc('O2','Fer1','Snk1')*(t_l+t_f)*3600 =E= mc_out('O2');

fc.FX(J,'Fer1','Snk1')$((Ord(J) ne 13) and (Ord(J) ne 14) )=0;


Equations
         Spl1_1 ;


fc.fx('CO2','Spl1','MecP1')=0.0;
fc.fx('O2','Spl1','MecP1')=0.0;

Spl1_1(J)$((Ord(J) ne 13) and (Ord(J) ne 14 ))..
         fc(J,'Spl1','MecP1') =E= fc(J,'Str2','Spl1');

fc.fx(J,'Spl1','HX4')=0;
fc.fx(J,'Spl3','HX11')=0;



*Mechanical Press
Equations
          MecP_1,MecP_2,MecP_3;
variable
         split_MecP1     split fraction of water in MecP1

Parameter
         factor(J)       solubility in water
         /Wa             1
          Star           0
          Gluc           1
          Malt           1
          Prot           1
          Etho           1
          Glyc           1
          SucA           1
          AceA           1
          LacA           1
          Urea           1
          CellM          0
          CO2            0
          O2             0
          Cellu          0
          HCellu         0
          Oil            0.4
          Ash            0/
         ;

*bounds on split fraction of water
split_MecP1.UP=1;
split_MecP1.Lo=0;
split_MecP1.L=0.9;


fc.Fx('CO2','MecP1','Flot1')=0;
fc.FX('O2','MecP1','Flot1')=0;
fc.Fx('CO2','MecP1','Dry1')=0;
fc.FX('O2','MecP1','Dry1')=0;


Parameter
         f_data_Split1_MecP1(J)       solubility in water
         /Wa             7.6549
          Star           0.1113
          Gluc           0
          Malt           0.1163
          Prot           1.4003
          Etho           5.8409
          Glyc           0.4316
          SucA           0.1637
          AceA           0.0298
          LacA           0.0248
          Urea           0.0086
          CellM          0.3267
          CO2            0
          O2             0
          Cellu          0.4932
          HCellu         1.484
          Oil            0.6372
          Ash            0.2286/
         ;




*Taylor Series with NLP values:
MecP_2(J)$((Ord(J) ne 13) and (Ord(J) ne 14 ))..
         fc(J,'MecP1','Flot1') =E= factor(J)*(0.9060*f_data_Split1_MecP1(J)+(fc(J,'Spl1','MecP1')-f_data_Split1_MecP1(J))*0.9060 + (split_MecP1-0.9060)*f_data_Split1_MecP1(J));



MecP_3(J)$((Ord(J) ne 13) and (Ord(J) ne 14 ))..
         fc(J,'MecP1','Dry1') =E=  factor(J)*(0.099*f_data_Split1_MecP1(J)+(fc(J,'Spl1','MecP1')-f_data_Split1_MecP1(J))*0.099 + (1-split_MecP1-0.099)*f_data_Split1_MecP1(J));


MecP_1.. fc('Etho','MecP1','Dry1')+fc('Wa','MecP1','Dry1')+fc('Oil','MecP1','Dry1') =G= 0.4*sum(J, fc(J,'MecP1','Dry1'));


*MecP_4(J).. fc(J,'MecP1','Flot1')+ fc(J,'MecP1','Dry1') =E= fc(J,'Spl1','MecP1');




*Flotation
Equations
         Flot_1, Flot_2, Flot_3
         ;

Scalar   rec_prot        recovery of protein in flotation unit /0.95/
         wat_prot        amount of water that stays with 1 kg of protein after flotation /0.01/;
*rec_prot and wat_prot are guessed

Flot_1.. fc('Prot','Flot1','Dry1') =E= rec_prot*fc('Prot','MecP1','Flot1');

Flot_2.. fc('Wa','Flot1','Dry1') =E= wat_prot*rec_prot*fc('Prot','MecP1','Flot1');

Flot_3(J)$((Ord(J) ne 1) and (Ord(J) ne 5 ))..
         fc(J,'Flot1','Dry1') =E= 0;


*Drying
Equations
         Dry_1, Dry_2, Dry_3, Dry_4, Dry_5, Dry_6, Dry_9, Dry_7;

Positive variable
         split_wa_dry    split fraction of water in dryer
         split_etho_dry  split fraction of ethanol in dryer;

Scalar   eff_dry         drying effiency /0.85/
         wa_max          maximum water level in cattle feed /0.1/;
Scalar   alpha           rel. volatility of ethanol based on water /2.239/  ;
fc.up('etho','Dry1','Hx10')= 0.005;

Dry_9.. fc('Wa','Dry1','HX10') =L= wa_max*sum(J,fc(J,'Dry1','HX10'));
*bounds on split fraction for water and ethanol
split_wa_dry.UP=1;

split_etho_dry.UP=1;


Dry_1..  split_etho_dry*1+(alpha-1)*(0.9798*0.9909+(split_etho_dry-0.9909)*0.9798+(split_wa_dry-0.9798)*0.9909) =E= (alpha*split_wa_dry);

Dry_2(J)$((Ord(J) ne 1) and (Ord(J) ne 6))..
         fc(J,'Dry1','HX10') =E= fc(J,'MecP1','Dry1')+fc(J,'Flot1','Dry1');
*Taylor Series Linearization
Dry_3..  fc('Wa','Dry1','Spl7') =E= 0.9798*0.7197+(split_wa_dry-0.9798)*0.7197+(fc('Wa','MecP1','Dry1')-0.7197)*0.9798+0.9798*6.9352+(split_wa_dry-0.9798)*6.9352+(fc('Wa','Flot1','Dry1')-6.9352)*0.9798;
*Taylor Series Linearization
Dry_4..  fc('Etho','Dry1','Spl7') =E= 0.9909*0.5492+(split_etho_dry-0.9909)*0.5492+(fc('Etho','MecP1','Dry1')-0.5492)*0.9909+0.9909*5.2918+(split_etho_dry-0.9909)*5.2918+(fc('Etho','Flot1','Dry1')-5.2918)*0.9909;
*Taylor Series Linearization
Dry_5..  fc('Wa','Dry1','HX10') =E= 0.0202*0.7197+(1-split_wa_dry-0.0202)*0.7197+(fc('Wa','MecP1','Dry1')-0.7197)*0.0202+0.0202*6.9352+(1-split_wa_dry-0.0202)*6.9352+(fc('Wa','Flot1','Dry1')-6.9352)*0.0202;
*Taylor Series Linearization
Dry_6..  fc('Etho','Dry1','HX10') =E= 0.0091*0.5492+(1-split_etho_dry-0.0091)*0.5492+(fc('Etho','MecP1','Dry1')-0.5492)*0.0091+0.0091*5.2918+(1-split_etho_dry-0.0091)*5.2918+(fc('Etho','Flot1','Dry1')-5.2918)*0.0091;



Dry_7..  fc('Wa','Dry1','Spl7')*dH_v('Wa','Dry1','Spl7')+ fc('Etho','Dry1','Spl7')*dH_v('Etho','Dry1','Spl7')+ sum(J$((Ord(J) ne 13) and (Ord(J) ne 14)),fc(J,'MecP1','Dry1')*c_p_ind(J))*(Tmp('Dry1','HX10')-Tmp('MecP1','Dry1'))+ sum(J$((Ord(J) ne 13) and (Ord(J) ne 14)),fc(J,'Flot1','Dry1')*c_p_ind(J))*(Tmp('Dry1','HX10')-Tmp('Flot1','Dry1'))=E= Q('Dry1');


*Fix for dryer
fc.Fx('CO2','Dry1','HX10')=0;
fc.Fx('O2','Dry1','HX10')=0;
fc.FX(J,'Dry1','Spl7')$((Ord(J) ne 1) and (Ord(J) ne 6)) = 0;

*HX10
Equations
         HX10_1,ddg;

HX10_1(J)..
         fc(J,'HX10','Snk8') =E= fc(J,'Dry1','HX10');


variables ddgs;
ddg.. ddgs =E= sum(J,fc(J,'HX10','Snk8'));





*Splitter 7
Equations
         Spl7_1(J),Spl7_2(J),Spl7_4(J);



parameters
f_data_Dry1_Spl7(J)
         /Wa             0.71
          Star           0.113
          Gluc           0
          Malt           0
          Prot           0
          Etho           0.5442
          Glyc           0
          SucA           0
          AceA           0
          LacA           0
          Urea           0
          CellM          0
          CO2            0
          O2             0
          Cellu          0
          HCellu         0
          Oil            0
          Ash            0/;


variables
split_Spl7_Snk9;

split_Spl7_Snk9.up = 1;
split_Spl7_Snk9.LO = 0;



*Spl7_3..   fc('Etho','Spl7','Snk9')=L= 0.005;

*Taylor Series with Values from NLP
Spl7_1(J).. fc(J,'Spl7','Snk9')=E= 0.0092*f_data_Dry1_Spl7(J)+(split_Spl7_Snk9-0.0092)*f_data_Dry1_Spl7(J)+(fc(J,'Dry1','Spl7')-f_data_Dry1_Spl7(J))*0.0092;
Spl7_2(J).. fc(J,'Spl7','Cond2') =E= fc(J,'Dry1','Spl7')-fc(J,'Spl7','Snk9');
Spl7_4(J).. fc(J,'Cond2','HX4')=E= fc(J,'Spl7','Cond2');

* Condenser 2
Scalar
         pcond /760/;

Equations
*Cond2_2,Cond2_1,Cond2_3,Cond2_4,Cond2_5;
Cond2_1,Cond2_2,Cond2_3;
m_frac.UP(h,'Cond2','HX4')=1;
m_frac.LO(h,'Cond2','HX4')=0;
T.up('Spl7','HX4')=100;
T.lo('Spl7','HX4')=20;
Variable
Temp2;

Cond2_2.. Temp2 =E= sum(h1,fc(h1,'Cond2','HX4')/MW(h1));


Parameter
m_frac_Cond2_HX4(h)
/Wa 0.7711
Etho 0.2289/;

*Taylor Series with Values from NLP
Cond2_1(h)..
0.0405*m_frac_Cond2_HX4(h)+(m_frac(h,'Cond2','HX4')-m_frac_Cond2_HX4(h))*0.0405+(Temp2-0.0405)*m_frac_Cond2_HX4(h) =E= fc(h,'Cond2','HX4')/MW(h);

*Using Graph In excel
Cond2_3..  T('Cond2','HX4') =E= 21.45*m_frac('Wa','Cond2','HX4')+77.2;

*Cond2_4..
*         dH_v('Wa','Cond2','Hx4') =E= -3.0562*T('Cond2','HX4')+2560.4;
*Cond2_5..
*         dH_v('Etho','Cond2','Hx4') =E= -2.037*T('Cond2','HX4')+1000.4;

*Cond2_5.. -sum(h,fc(h,'Cond2','HX4')*(c_p_v(h)*(Tmp('Dry1','Spl7')-T('Cond2','HX4'))+dH_v(h,'Cond2','HX4'))) =E= Q('Cond2');


*Preliminary Distillation

fc.FX('CO2','Flot1','HX4') = 0;
fc.FX('O2','Flot1','HX4') = 0;




Equations

Flot_4,HX4_1;

Flot_4(J)$((Ord(J) ne 13) and (Ord(J) ne 14 ))..
         fc(J,'Flot1','Dry1')+fc(J,'Flot1','HX4') =E= fc(J,'MecP1','Flot1');

HX4_1(J)$((Ord(J) ne 13) and (Ord(J) ne 14 ))..
         fc(J,'HX4','BC1') =E= fc(J,'Flot1','HX4') + fc(J,'Cond2','HX4');

T.UP('HX4','BC1')=110;
T.LO('HX4','BC1')=78.35;
T.l('HX4','BC1')= 90;


m_frac.UP('Wa','HX4','BC1')=0.99;
m_frac.UP('Etho','HX4','BC1')=0.23;
m_frac.LO('Wa','HX4','BC1')=0.2;
m_frac.LO('Etho','HX4','BC1')=0.01;

Equations
BCCC_1,BCCC_11,BCCC_2t,BCCC_3t,HX4_2,BC_10;
Variable
Temp11,Temp22,BC_temp1,BC_temp2;
Temp11.lo = 0.00001;
Temp22.lo = 0.00001;

BCCC_1.. Temp22 =E= sum(h1,fc(h1,'HX4','BC1')/MW(h1));
*Taylor series using guesses
BC_10(h).. 0.051*0.5+(m_frac(h,'HX4','BC1')-0.5)*0.051+(Temp22-0.051)*0.5 =E= fc(h,'HX4','BC1')/MW(h);

*Using Graph In excel
BCCC_11..   T('HX4','BC1') =E= 21.45*m_frac('Wa','HX4','BC1')+77.2;

BCCC_2t.. BC_temp1 =E= Sum(J,fc(J,'Flot1','HX4')*c_p_ind(J)) ;
BCCC_3t.. BC_temp2 =E= Sum(J,fc(J,'Cond2','HX4')*c_p_ind(J)) ;
HX4_2..  Q('HX4') =E= 45.3401*93.128+(T('HX4','BC1')-93.128)*45.3401+(BC_temp1-45.3401)*93.128-BC_temp1*Tmp('Flot1','HX4')+4.5026*93.128+(BC_temp2-4.5026)*93.128+(T('HX4','BC1')-93.128)*4.5026-93.1535*4.5026+(BC_temp2-4.5026)*93.1235+(T('Cond2','HX4')-93.1535)*4.5026;




*Distillation Column


Positive Variable
         rec_Wa(column)  water recovery in column;

Scalar
*alpha is calculated at 370K; it is assumed to be constant
*the rel. volatilities of all other components are neglegtable small for a calculations
         p               pressure in both columns in mmHg to be consistent with vapor pressure correlation  /760/
         d_p             pressure drop in column in mmHg /76/
         R_BC            reflux ratio on a MASS basis /2/;

Parameter
         rec_Etho(column) recovery of ethanol in BC1 and Rec1 is fixed
        /BC1     0.996
         Rec1    0.996/;


*bounds for beer column equations
*water recovery
rec_Wa.UP('BC1')=1;
rec_Wa.lo('BC1')=0;
rec_wa.L('BC1') = 0.2817;
*update these bounds later, now avoid division by zero in BC_1
*these bounds must be placed before BC_1, so don't move them to Rec1
*rec_Wa.UP('Rec1')=0.2;
*rec_Wa.LO('Rec1')=0.0001;

equations BC_2,BC_3,BC_1_1,BC_1_2,BC_1_3;


*mass balance
*BC_1(J)..
*Linearizing Using Taylot Series with values from NLP
BC_2..   fc('Wa','BC1','Spl2') =E= 0.2817*7.663+(rec_Wa('BC1')-0.2817)*7.663+(fc('Wa','HX4','BC1')-7.663)*0.2817;
BC_3..   fc('Etho','BC1','Spl2') =E= rec_Etho('BC1')*fc('Etho','HX4','BC1');
BC_1_1..   fc('Etho','BC1','Spl3') =E= fc('Etho','HX4','BC1')-fc('Etho','BC1','Spl2');
BC_1_2..   fc('Wa','BC1','Spl3') =E= fc('Wa','HX4','BC1')-fc('Wa','BC1','Spl2');
BC_1_3(J)$((Ord(J) ne 1) and (Ord(J) ne 6 ))..   fc(J,'BC1','Spl3')=E= fc(J,'HX4','BC1')-fc(J,'BC1','Spl2');
fc.fx(J,'BC1','Spl2')$((Ord(J) ne 1) and (Ord(J) ne 6 ))=0;

Equations
BC_19;

BC_19..  Q_reb('BC1') =E= sum(h1,fc(h1,'BC1','Spl2'))*2250.789*3*0.99;



*DDGS and WASTE Stream Part
variable Heat(unit);

Heat.L('HX11') = 10;

Equations heat_1,heat_2,Rec1,Rec2,Rec3;
heat_1.. Heat('HX11') =E= sum(J,fc(J,'BC1','Spl3'))*75;
heat_2.. Heat('Hx10') =E= sum(J,fc(J,'HX10','Snk8'))*75;

Equations Rec0,Rec4;

Rec0(h)..   fc(h,'Spl2','Mix4')=E=fc(h,'BC1','Spl2');
Rec4(h)..   fc(h,'Mix4','Rec1')=E=fc(h,'Spl2','Mix4');



*Making The process Simple By removing options and directly Passing through the Second Distillation Column

rec_Wa.UP('Rec1')=0.999;
rec_Wa.lo('Rec1')=0.14;

*fc.L(h1,'Rec1','Spl4')=0.01;
*fc.L(h1,'Rec1','Snk2')=0.01;

Rec1..   fc('Wa','Rec1','Spl4') =E= 0.14*0.1658+(rec_Wa('Rec1')-0.14)*0.1658 +(fc('Wa','Mix4','Rec1')-0.1658)*0.14;
Rec2..   fc('Etho','Rec1','Spl4') =E= rec_Etho('Rec1')*fc('Etho','Mix4','Rec1');
Rec3(h1)..   fc(h1,'Rec1','Snk2') =E= fc(h1,'Mix4','Rec1')- fc(h1,'Rec1','Spl4');



equations heat3;
Heat.L('Rec1') = 10;
heat3.. Heat('rec1') =E= (sum(h1,fc(h1,'rec1','Spl4'))*2-sum(h1,fc(h1,'rec1','Snk2')))*2250;


variable ethanol;

equation Fproduct;
Fproduct.. ethanol =E= fc('Etho','Rec1','Spl4');


equation nitrate_eq;
Variable urea_eq;
nitrate_eq.. urea_eq =E= fc('Urea','Spl7','Snk9') + fc('Urea','BC1','Spl3');

equation obj;

variable energy_req;
obj.. energy_req =E= Q('HX1')+Q('Jet1')+Q('Dry1')+Q('HX4')+Q_reb('BC1')+Heat('HX11')+Heat('Hx10')+Heat('rec1');



***************************************************Equipment scale matrix information*****************************************************
Parameter CornInput in unit of 10*5 kg per year
/5676.4/;







****************************************************Cost information**********************************************************************
Parameter

till_corn_price dollarperkg   /0.170/
notill_corn_price dollarperkg /0.020/  ;



*obj.. Z =E= Q('HX1')+Q('Jet1')+Q('Dry1')+Q('HX4');
*obj.. Z =E= urea_eq;

*MODEL TRANS /ALL/ ;

*TRANS.optFile = 1

*option NLP = BARON;

*Solve TRANS Using NLP Minimizing Z;
*Solve TRANS Using NLP Maximizing NPV;


