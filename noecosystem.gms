
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



positive variable scaling_vec(TM);
*Dont fix Farm scaling vectors. Doesnt make sense in terms of LCA. LCA means emission atrributed only to the consumers.
*Professor Bakshi says that this is not valid. The farm emission should be taken from all farms because it is the actual problem. Just looking at what Toledo consumes does not make sense. 

*scaling_vec.FX(TM)$(Ord(TM) ge 22 and Ord(TM) le 42) = 1;
*scaling_vec.UP(TM)$(Ord(TM) ne 43)=1;
*Scaling vector for Consumers is 1;No need for those equations
*

scaling_vec.UP(TM) = 1;
scaling_vec.FX('1470') = 1;


variable final_demand(TM);
final_demand.FX(TM)$(Ord(TM) ne 1470) = 0;
final_demand.FX('1470') = 1;

*equation core1,core2,core3,core4;
equation core1;


core1(TM).. sum[TM1,P2P_X(TM,TM1)*scaling_vec(TM1)] =E= final_demand(TM);
*core2(TM)$(Ord(TM) ge 44).. sum[TM1,P2P_X(TM,TM1)*scaling_vec(TM1)] =G= 0;
*core4.. sum[TM1,P2P_X('43',TM1)*scaling_vec(TM1)] =E=0;

*core3(EQ).. scaling_vec(EQ) =E= R(EQ);



variable phos(VCE),co2,obj_em;

variable phos_em;
equation emission1,emission3,emission4,emission2;
emission1(VCE).. phos(VCE) =E= sum[VCF,P2P_B(VCE,VCF)*scaling_vec(VCF)];

*emission2..  co2 =E= sum[TM$(Ord(TM) le 21),sum[TM1,((P2P_X(TM,TM1)*P2P_X(TM,TM1))**0.5)*transport(TM1,TM)*1389]] + sum[TM$(Ord(TM) ge 42),sum[TM1,((P2P_X(TM,TM1)*P2P_X(TM,TM1))**0.5)*transport(TM1,TM)*2751]];

emission2.. co2 =E= -1*sum[VCF,P2P_X(VCF,'1470')*transport(VCF,'1')*0.054];

emission3.. phos_em =E= sum[VCE,phos(VCE)];

*emission4.. obj_em =E= co2;


emission4.. obj_em =E= phos_em;


*equation cost1,cost2;
*variable farm_cost(VCF);

*cost1(VCF)$((Ord(VCF) ne 1) and (Ord(VCF) ne 5) and (Ord(VCF) ne 7) and (Ord(VCF) ne 11) and (Ord(VCF) ne 16) and (Ord(VCF) ne 18)).. farm_cost(VCF) =E= sum[EQ,P2P_X(VCF,EQ)*till_corn_price];
*cost2(VCF)$((Ord(VCF) eq 1) or (Ord(VCF) eq 5) or (Ord(VCF) eq 7) or (Ord(VCF) eq 11) or (Ord(VCF) eq 16) or (Ord(VCF) eq 18)).. farm_cost(VCF) =E= sum[EQ,P2P_X(VCF,EQ)*till_corn_price];




MODEL TRANS /ALL/ ;

TRANS.optFile = 1

option NLP = CONOPT;

Solve TRANS Using NLP Minimizing co2;


parameter excess(TM);


excess(TM) = sum[TM1,p2p_x.L(TM,TM1)*scaling_vec.L(TM1)]


display P2P_B.L
*display R.L;
*display ce.L;
*display cf.L;
*display ef.L;

display P2P_X.L;
display co2.L;
display phos.L;
display phos_em.L;
display scaling_vec.L;
display excess;

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
