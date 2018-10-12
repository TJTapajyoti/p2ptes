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





*******************************   THE ECOSYSTEMS ONLY ARE CONSIDERED IF CORESSPONDING THE FARMS ARE CHOSENNNN*************************************
equation farms_eco;
farms_eco(VCF,ECO)$(Ord(VCF) eq Ord(ECO)).. e_scaling_vec(ECO) =E= scaling_vec(VCF);


*********************************************************************Scaling vector for Consumers is 1;No need for those equations******************************************************


scaling_vec.UP(TM) = 1;
scaling_vec.FX('1470') = 1;


variable final_demand(TM);
final_demand.FX(TM)$(Ord(TM) ne 1470) = 0;
final_demand.FX('1470') = 1;

*equation core1,core2,core3,core4;
equation core1;


core1(TM).. sum[TM1,P2P_X(TM,TM1)*scaling_vec(TM1)] =E= final_demand(TM);


**********************************************Environmental calculations****************************************************************************************
variable phos(VCE),co2,obj_em ;
variable phos_em;
equation emission1,emission2,emission3,emission4;
emission1(VCE).. phos(VCE) =E= sum[VCF,P2P_B(VCE,VCF)*scaling_vec(VCF)] - sum[ECO,ecosystem(VCE,ECO)*e_scaling_vec(ECO)];  

emission2.. co2 =E= -1*sum[VCF,P2P_X(VCF,'1470')*transport(VCF,'1')*0.054];


emission3.. phos_em =E= sum[VCE,phos(VCE)];


*emission4.. obj_em =E= 0.5*phos_em+0.5*co2;


emission4.. obj_em =E= phos_em;

phos_em.UP = -3100;

MODEL TRANS /ALL/ ;

TRANS.optFile = 1

option NLP = CONOPT;

*Solve TRANS Using NLP Minimizing phos_em;
Solve TRANS Using NLP Minimizing co2;



parameter excess(TM);


excess(TM) = sum[TM1,p2p_x.L(TM,TM1)*scaling_vec.L(TM1)]



*display ethanol.L;
display P2P_B.L;
*display R.L;
*display ce.L;
*display cf.L;
*display ef.L;
display P2P_X.L;
display co2.L;
display phos_em.L;
display scaling_vec.L;
display e_scaling_vec.L;
display excess;
display ecosystem;

file fx /p2p.txt/;
fx.ps = 130;
fx.pw = 32767;
fx.nd = 2;
fx.pc = 6;
put fx
Loop(TM,
Loop(TM1,
put P2P_X.L(TM,TM1);
);
put /;
);

putclose;

file fx2 /scaling_vec.txt/;
fx.ps = 130;
fx.pw = 32767;
fx.nd = 3;
fx.pc = 6;
put fx2
Loop(TM,
put scaling_vec.L(TM);
put /;
);

putclose;


execute_unload 'p2p.gdx', P2P_X;

