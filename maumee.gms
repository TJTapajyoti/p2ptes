$ontext
11/17/2017
10.58pm


This is the main case study of the P2P TES problem with the
Author : Tapajyoti Ghosh
$offtext

*****************DATA INEDUCED OUTPUT
$inlinecom /* */


$offlisting
$offsymxref
$offsymlist
$offinclude

option limrow = 0;

option limcol = 0;
*option solprint = off;
option sysout = off;

$Include baronlinear.gms

***************************************Value Chain Matrix Information*******************************************************
*************Setting up the sizes of the value chain matrices****************************************************************
*************Defining the Sets which determine the size of the different matrices********************************************

Set TE Techno-Eco-Env Matrix /1*2940/;

   Alias(TE,TE1)

Set TM(TE) Technology-Multiscale P2P matrix  /1*1470/;

   Alias(TM,TM1);

Set VC(TM) Value chain matrix /1*1469/;

   Alias(VC,VC1);

Set P2PE(TE) P2P-Envmatrix /1471*2940/;

   Alias(P2PE,P2PE1);

Set VCE(P2PE) Value Chain Env matrix /1471*2940/;

   Alias(VCE,VCE1,ECO,ECO1);

Set VCF(VC) Value chain Farms /1*1469/;

   Alias(VCF,VCF1);

Set VCC(TM) Value chain consumers /1470/;

   Alias(VCC,VCC1);

SET TR /1/;

*Set EQ(TM)  Equipment Scale /1470/;
*
*   Alias(EQ,EQ1);

*Set ENVEQ(P2PE) Equipment scale emissions /87*107/;

*  Alias(ENVEQ,ENVEQ1);

*Set ECO(TE) ecosystem /1471*2940/;

*  Alias(ECO,ECO1);










**************CALLING GDX FUNCTIONS TO READ THE EXCEL FILES AND GET DATA***********************************************************

Parameter Level1(VC,VC1) store data temporarily

*******************************Read the Value chain scale Make matrix**************************************************************
*$CALL GDXXRW.EXE VCMake.xlsx par=Level1 rng=Sheet1!A1:BDN1470

$GDXIN VCMake.gdx
$LOAD Level1
$GDXIN



Parameter Level2(VC,VC1) store data temporarily

*******************************Read the Value chain scale Use matrix**************************************************************
*$CALL GDXXRW.EXE VCUse.xlsx par=Level2 rng=Sheet1!A1:BDN1470

$GDXIN VCUse.gdx
$LOAD Level2
$GDXIN


Parameter Level3(VCE,VCF) store data temporarily

*******************************Read the Value chain scale Environmental matrix**************************************************************
*$CALL GDXXRW.EXE VCEnv.xlsx par=Level3 rng=Sheet1!A1:BDN1470

$GDXIN VCEnv.gdx
$LOAD Level3
$GDXIN


*Parameter Level4(EQ,VCC) store data temporarily

*******************************Read the Ethanol Demand matrix**************************************************************
*$CALL GDXXRW.EXE EthDemand.xlsx par=Level4 rng=Sheet1!A1:V22

*$GDXIN EthDemand.gdx
*$LOAD Level4
*$GDXIN


Parameter Level5(VCF,TR) store data temporarily

*******************************Read the Ethanol Demand matrix**************************************************************
*$CALL GDXXRW.EXE trans.xlsx par=Level5 rng=Sheet1!A1:B1470

$GDXIN trans.gdx
$LOAD Level5
$GDXIN


Parameter Level6(ECO,ECO1) store data temporarily

*******************************Read the Ethanol Demand matrix**************************************************************
*$CALL GDXXRW.EXE ecosystem.xlsx par=Level6 rng=Sheet1!A1:BDN1470

$GDXIN ecosystem.gdx
$LOAD Level6
$GDXIN


*Parameter Level7(VCE,VCF) store data temporarily

*******************************Read the Value chain scale Environmental matrix**************************************************************
*$CALL GDXXRW.EXE VCEnv2.xlsx par=Level7 rng=Sheet1!A1:V22

*$GDXIN VCEnv2.gdx
*$LOAD Level7
*$GDXIN


*Parameter Level8(VCF1,VCE) store data temporarily

*******************************Read the Value chain scale Environmental matrix**************************************************************
*$CALL GDXXRW.EXE permut1.xlsx par=Level8 rng=Sheet1!A1:V22

*$GDXIN permut1.gdx
*$LOAD Level8
*$GDXIN


*Parameter Level9(VCF1,VCE) store data temporarily

*******************************Read the Value chain scale Environmental matrix**************************************************************
*$CALL GDXXRW.EXE permut2.xlsx par=Level9 rng=Sheet1!A1:V22

*$GDXIN permut2.gdx
*$LOAD Level9
*$GDXIN


*Parameter Level10(VC,VC1) store data temporarily

*******************************Read the Value chain scale Make matrix**************************************************************
*$CALL GDXXRW.EXE VCMake_2.xlsx par=Level10 rng=Sheet1!A1:AR44

*$GDXIN VCMake_2.gdx
*$LOAD Level10
*$GDXIN





Parameter VCMake(VC,VC1) make
          VCUse(VC,VC1)  use
          VCEnv(VCE,VCF)  intervention
          VCEnv2(VCE,VCF) internvention till
*          EthDemand(EQ,VCC)  ethanol Demand by society
          transport(VCF,TR) transport
          ecosystem(ECO,ECO1) ecosystem;
;


VCMake(VC,VC1) = Level1(VC,VC1);
VCUse(VC,VC1) = Level2(VC,VC1);
VCEnv(VCE,VCF) = Level3(VCE,VCF);
*EthDemand(EQ,VCC) = Level4(EQ,VCC);
transport(VCF,TR) = Level5(VCF,TR);
ecosystem(ECO,ECO1) = Level6(ECO,ECO1);
*VCEnv2(VCE,VCF) = Level7(VCE,VCF);






******************************************************Creating the P2P matrix**************************************************************
Variable P2P_X(TM,TM1);

*Equation Buildmatrix1,Buildmatrix2,Buildmatrix3,Buildmatrix4,Buildmatrix5,Buildmatrix6,Buildmatrix7,Buildmatrix8;

Equation Buildmatrix1;

*****************************************************Filling up the places without variables. The VCUSE has variables for the farm to consumer flow to satisfy the food demand
****************as a fraction of different food amounts from different farms******************************

*Remember to transpose the VCMake matrix*******
Buildmatrix1(VC,VC1)$(Ord(VC1) le 1469).. P2P_X(VC,VC1) =E= VCMake(VC1,VC) - VCUse(VC,VC1);
*Overlapping equation but should be fine....
*Buildmatrix6(VC,VC1)$(Ord(VC) ge 1469)..  P2P_X(VC,VC1) =E= VCMake(VC1,VC) - VCUse(VC,VC1);
******Filling up the ooal sector column***************
*Buildmatrix7(VC,'1470')..   P2P_X(VC,'1470') =E= 1;


*************************************Filling up the Demand of Food by consumsers**************************************************
positive Variable cf(VCF,VCC) continuous_variables for satisfaction of Food demand of every consumer from different farms;
cf.UP(VCF,VCC) = 1;
cf.L(VCF,VCC)= 0.5;


*Value chain Upstream Cutoff
Equation Food_demand;
Food_demand(VCF,VCC)..  P2P_X(VCF,VCC) =E= cf(VCF,VCC)*(-1990787);

************************************Constraint of food Satisfaction Variable*****************************************
Equation food_satisfaction;
****Sum of rows in every column is 1
food_satisfaction(VCC).. sum[VCF,cf(VCF,VCC)] =E= 1;


*A Placeholder value representing the consumers
P2P_X.FX(VCC,VCC) = 1;

*Downstream Cutoff Consumer to Farms
P2P_X.FX(VCC,VCF) = 0;





*************************************************No flows in Cutoff from Refinery to Farms*************************************************

*Buildmatrix2(EQ,VCF).. P2P_X(EQ,VCF) =E= 0;

*************************************************No flows in Cutoff from Refinery to Coal Mines*************************************************

*Buildmatrix3(EQ,'43').. P2P_X(EQ,'43') =E= 0;










*********Biorefinery Location Variable**********************************************************
*binary variable R(EQ);

*Constraint on number of biorefineries
*Equation refinerynumber;
*refinerynumber.. sum[EQ,R(EQ)] =L= 8;



*************Continuous Variables for satisfaction of energy by society**********************************
*positive Variable ce(EQ,VCC) continuous_variables for satisfaction of energy demand of every consumer from different farms;
*ce.UP(EQ,VCC) = 1;
*ce.L(EQ,VCC)= 0.5;



*Highly difficult constraint. First we have defined the biorefinery location variable R.  Now, we define continuous variable that determines the satisfaction of
*energy demand by the society. The consumer will only consume ethanol from those refineries which exist. Thus row wise, some elements will not appear because every row represents refinery. Hence, we can
*deduce from that some ce variables in some rows will not exist due to non existence of R. Thus, trying to build a constraint from there.
*************************************CUTOFF flow Between Refinery and Society/Consumers***************************************************

*Buildmatrix4(EQ,VCC).. P2P_X(EQ,VCC) =E= -EthDemand(EQ,VCC)*ce(EQ,VCC);
*Buildmatrix8(EQ,VCC).. ce(EQ,VCC) =L= R(EQ);


*Equation energy_satisfaction1;
*This equation is always true because the consumers energy demand whould always be satisfied.
*energy_satisfaction1(VCC).. sum[EQ,ce(EQ,VCC)] =E= 1;











***********************************Fillin up matrix with equipment scale info********************************************
*Equation Buildmatrix9,Buildmatrix10;
*Buildmatrix9(EQ,EQ1)$(ord(EQ) eq ord(EQ1))..   P2P_X(EQ,EQ1) =E= (Ethanol*86400*365)*R(EQ)/100000;
*Buildmatrix10(EQ,EQ1)$(ord(EQ) ne ord(EQ1))..   P2P_X(EQ,EQ1) =E= 0;











*********************************This variable is for storing the continuous decisions for demand of corn by biorefineries**************************************
*positive Variable ef(VCF,EQ) continuous_variables for satisfaction of corn demand of every biorefinery from different farms;

*ef.L(VCF,EQ) = 0.5;
*ef.UP(VCF,EQ) = 1;

************************************************Filling up demand of corn by biorefineires*******************************************
*Equation corn_demand;

*corn_demand(VCF,EQ).. P2P_X(VCF,EQ) =E= -Corninput*ef(VCF,EQ);

************************************Constraint of corn Satisfaction Variables*****************************************
*Equation corn_satisfaction;

*corn_satisfaction(EQ).. sum[VCF,ef(VCF,EQ)] =E= R(EQ);
*Thus sum of all columns is not equal to 1 because some columns do not even have a refinery. So it is equal to R.


************Refinery does not have any demand from Socciety or consumers**************************************

*P2P_X.FX(VCC,EQ) = 0;

*Fixing the cutoff from society to refinery as 0.

*P2P_X.FX(VCC,EQ) = 0;








*Coal consumption by refinery also in 10^5 kg Units. So divided by 100000
*equation Buildmatrix11;

*Buildmatrix11('43',EQ).. P2P_X('43',EQ) =E= -R(EQ)*(energy_req*86400*364)/(37500*100000);


***************Filling up the environmental part of the matrix****************************************************

Variable P2P_B(P2PE,TM);

*************************************Environmental Flow From farm***************************************************
Variable temp_inv1(VCE,VCF);


*Buildmatrix5(VCE,VCF).. temp_inv1(VCE,VCF) =E= sum[VCF1,VCEnv(VCE,VCF1)*Level8(VCF1,VCE)] + sum[VCF1,VCEnv2(VCE,VCF1)*Level9(VCF1,VCE)];
*correction(VCE,VCF)$(Ord(VCE) eq Ord(VCF)).. P2P_B(VCE,VCF) =E= temp_inv1(VCE,VCF);
*Buildmatrix5(VCE,VCF)$(Ord(VCE) eq Ord(VCF)).. P2P_B(VCE,VCF) =E= VCEnv(VCE,VCF);

*P2P_B.FX(VCE,VCF)$(Ord(VCE) ne Ord(VCF)) = 0;




P2P_B.FX(VCE,VCF) = VCEnv(VCE,VCF);



**********All emission values in the Row of farm emissions except in the first 1469 columns will be 0.

P2P_B.FX(VCE,TM)$(Ord(TM) ge 1470)=0;

***********Emissions in the row of coal emissions are taken to be zero as of now as because its outside the system boundary****************************************

*P2P_B.FX('86',TM)=0;

***********Refinery Emissions for the Value chain scale columns are all zero*********************************************

*P2P_B.FX(P2PE,TM)$(Ord(P2PE) ge 23 and Ord(TM) le 43)=0;








***********Refinery Emissions****************************************************

*equation Buildmatrix12,Buildmatrix13;

*Buildmatrix12(ENVEQ,TM)$(Ord(ENVEQ) eq (Ord(TM)-43)).. P2P_B(ENVEQ,TM) =E= 0;
*Buildmatrix13(ENVEQ,TM)$(Ord(ENVEQ) ne (Ord(TM)-43)).. P2P_B(ENVEQ,TM) =E= 0;










