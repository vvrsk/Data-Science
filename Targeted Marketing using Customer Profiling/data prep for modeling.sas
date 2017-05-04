/*This program reads in data and transforms variables for regression. */
/*change program to fit your data and model*/

libname storage 'C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\Projects\Project3\Code\Data';

proc import datafile='C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\Projects\Project3\Fall 2016 Overdraft Loan.csv' 
	out=resp_data dbms=csv replace;
run;

/*macros*/
%include 'C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\Projects\Project3\Code\data_prep_macros.sas';

/*looking at data to understand variables and determine how to work with them*/
proc contents data=resp_data;
run;

proc print data=resp_data (obs=10);
run;

data tmp;
set resp_data;
drop seqnum resp;
run;

proc freq data=tmp order=freq; 
tables _all_ /maxlevels=5;
run;


proc univariate data=tmp;
var mgemom;
run;

proc freq data=tmp;
tables mgemom;
run;

proc freq data= tmp;
run;

/***resetting ordinal variables**/
data resp_data2;
set  resp_data;

*******************************************************;
array origf[10](0, 1, 2,  3,  4,  5,   6,   7,    8,    9);
array newf[10] (0,25,75,150,350,750,3000,7500,15000,30000);
retain origf1-origf10 newf1-newf10; 
do i=1 to dim(origf); 
 if pwapar=origf[i] then pwapar2=newf[i];
 if PAANHA=origf[i] then PAANHA2=newf[i];
 if PPERSA=origf[i] then PPERSA2=newf[i];
end;
drop origf1--origf10 newf1--newf10 i; 
*******************************************************;

array orig[10](0,  1, 2, 3, 4, 5, 6, 7, 8,  9);
array new[10] (0,5.5,17,30,43,56,69,82,94,100);
retain orig1-orig10 new1-new10; 
do i=1 to dim(orig); 
if MGODRK =orig[i] then MGODRK2 =new[i];
if MGODPR =orig[i] then MGODPR2 =new[i];
if MRELGE =orig[i] then MRELGE2 =new[i];
if MFALLE =orig[i] then MFALLE2 =new[i];
if MFWEKI =orig[i] then MFWEKI2 =new[i];
if MOPLHO =orig[i] then MOPLHO2 =new[i];
if MSKA   =orig[i] then MSKA2 =new[i];
if MSKB1  =orig[i] then MSKB12 =new[i];
if MSKB2  =orig[i] then MSKB22 =new[i];
if MSKC   =orig[i] then MSKC2 =new[i];
if MHHUUR =orig[i] then MHHUUR2 =new[i];
if MAUT1  =orig[i] then MAUT12 =new[i];
if MAUT2  =orig[i] then MAUT22 =new[i];
if MAUT0  =orig[i] then MAUT02 =new[i];
if MINKGE =orig[i] then MINKGE2 =new[i];
end;
drop orig1--orig10 new1--new10 i; 
*************************************************;
run;

*QA;
proc freq data=resp_data2;
tables
MGODRK*MGODRK2
MGODPR*MGODPR2
MRELGE*MRELGE2
MFALLE*MFALLE2
MFWEKI*MFWEKI2
MOPLHO*MOPLHO2
MSKA*MSKA2
MSKB1*MSKB12
MSKB2*MSKB22
MSKC*MSKC2
MHHUUR*MHHUUR2
MAUT1*MAUT12
MAUT2*MAUT22
MAUT0*MAUT02
MINKGE*MINKGE2
pwapar*pwapar2
PAANHA*PAANHA2
PPERSA*PPERSA2 / list;
run;

data resp_data2;
set  resp_data2;
drop pwapar paanha ppersa
MGODRK
MGODPR
MRELGE
MFALLE
MFWEKI
MOPLHO
MSKA
MSKB1
MSKB2
MSKC
MHHUUR
MAUT1
MAUT2
MAUT0
MINKGE
;
run;

/**resetting categorical to binary variables*/
data resp_data3;
set resp_data2;

%macro binarycreate(varname, numcat);
%do i=1 %to &numcat;
	if &varname =&i then &varname&i=1; else &varname&i=0;
%end;
%mend;

%binarycreate(moshoo, 10);
%binarycreate(mostyp, 41);

drop moshoo mostyp;

run;

proc print data=resp_data3 (obs=10);
run;

/** looking at graphs- predictors by response**/
*get var list;
data indep;                                                                   
set  resp_data2 (drop=resp seqnum moshoo mostyp);                                                 
run;                                                                          
                                                                              
%ObsAndVars(indep);                                                           
%varlist(indep);                                                              

*run macro for graphs;
%macro GraphLoop;     
options mprint; 
 %do i=1 %to &nvars;                                                               
   %let variable=%scan(&varlist,&i);                                          
%DissGraphMakerLogOdds(resp_data2,10,&variable,resp);
 %end;             
options nomprint; 
%mend GraphLoop;                                                              
%GraphLoop; 

/** testing for linear vs quadratic form**/
data resp_data4;
set  resp_data3;

*SqrSCDJOBINC=(SCDJOBINC-6)**2;
mgemomsq=mgemom**2;
mgemomcu = mgemom**3;
run;

proc logistic data=resp_data4 descending;
model resp=scdjobinc;
title "scdjobinc linear";
run;

proc logistic data=resp_data4 descending;
model resp=Sqrscdjobinc scdjobinc;
title "Sqrscdjobinc quadratic";
run;
title;


proc logistic data=resp_data4 descending;
model resp=mgemom;
title "Mgemom LINEAR Model";
run;
title;
proc logistic data=resp_data4 descending;
model resp=mgemom mgemomsq;
title "Mgemom QUADRATIC Model";
run;
title;


/**final dataset for modeling**/

data storage.model_vars;
set resp_data4;

/*additional programming as needed*/

run;

proc contents data=storage.model_vars;
run;

proc print data=storage.model_vars (obs=10);
run;

*get var list;

proc datasets noprint;
 delete indep;
run;

data indep;                                                                   
set  storage.model_vars (drop=resp seqnum);                                                 
run;                                                                          
                                                                                                                                      
%varlist(indep);       
