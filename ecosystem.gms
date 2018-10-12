
$ontext
Ecosystem Addition
Author : Tapajyoti Ghosh
$offtext

*****************DATA INEDUCED OUTPUT
*$inlinecom /* */


$offlisting
$offsymxref
$offsymlist
$offinclude

option limrow = 0;

option limcol = 0;
option solprint = off;
option sysout = off;


$Include maumee.gms


**************************************************Description of Scaling Varaibles*******************************************************************
positive variable scaling_vec(TM);


positive variable e_scaling_vec(ECO);

scaling_vec.FX(TM)$(Ord(TM) ge 22 and Ord(TM) le 42) = 1;
scaling_vec.UP(TM)$(Ord(TM) ne 43)=1;




*******************************   THE ECOSYSTEMS ONLY ARE CONSIDERED IF CORESSPONDING THE FARMS ARE CHOSENNNN*************************************
equation farms_eco;
farms_eco(VCF,ECO)$(Ord(VCF) eq Ord(ECO)).. e_scaling_vec(ECO) =E= scaling_vec(VCF);




********************************* TESTING FARMS BY FIXING THEM AND CHECK IF OPTIMIZATION IS WORKING OR NOT**************************************************

*scaling_vec.FX('2') = 1;



*********************************************************************Scaling vector for Consumers is 1;No need for those equations******************************************************
equation core1,core2,core3,core4;

core1(TM)$(Ord(TM) le 21).. sum[TM1,P2P_X(TM,TM1)*scaling_vec(TM1)] =E= 0;
core2(TM)$(Ord(TM) ge 44).. sum[TM1,P2P_X(TM,TM1)*scaling_vec(TM1)] =G= 0;
core4.. sum[TM1,P2P_X('43',TM1)*scaling_vec(TM1)] =E=0;

**************************************The scaling vectors for the biodiesel plants may not be zero due to this equation not equaling to zero. hence we might want to rectify that. lets try. 

core3(EQ).. scaling_vec(EQ) =E= R(EQ);


**********************************************Environmental calculations****************************************************************************************
variable phos(VCE),co2,obj_em ;
variable phos_em;
equation emission1,emission2,emission3,emission4;
emission1(VCE).. phos(VCE) =E= sum[VCF,P2P_B(VCE,VCF)*scaling_vec(VCF)] - sum[ECO,ecosystem(VCE,ECO)*e_scaling_vec(ECO)];  

emission2..  co2 =E= sum[TM$(Ord(TM) le 21),sum[TM1,((P2P_X(TM,TM1)*P2P_X(TM,TM1))**0.5)*transport(TM1,TM)*1389]] + sum[TM$(Ord(TM) ge 42),sum[TM1,((P2P_X(TM,TM1)*P2P_X(TM,TM1))**0.5)*transport(TM1,TM)*2751]];


emission3.. phos_em =E= sum[VCE,phos(VCE)];

*emission4.. obj_em =E= 0.5*phos_em+0.5*co2;
emission4.. obj_em =E= phos_em;

MODEL TRANS /ALL/ ;

TRANS.optFile = 1

option MINLP = BARON;

Solve TRANS Using MINLP Minimizing phos_em;


parameter excess(TM);


excess(TM) = sum[TM1,p2p_x.L(TM,TM1)*scaling_vec.L(TM1)]

display ethanol.L;
display P2P_B.L;
display R.L;
display ce.L;
display cf.L;
display ef.L;
display P2P_X.L;
display co2.L;
display phos.L;
display scaling_vec.L;
display e_scaling_vec.L;
display excess;
display ecosystem;


file fx /transfereco.txt/;
fx.ps = 130;
fx.pw = 2000;
fx.nd = 4;
put fx
Loop(TM,
Loop(TM1,
put P2P_X.L(TM,TM1);
);
put /;
)
