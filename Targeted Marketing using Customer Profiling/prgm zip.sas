/*This program reads in census data at the zipcode level
  modifies the data to replace missing data
*/  

/*library statement*/
*	Note: adjust this as necessary;

libname storage 'C:\Users\kim\Documents\test\IDS462\Fall 2016\Classes\C2\SAS';

/*Check the data*/
proc contents data=storage.dmefzip;
title "Contents of Zipcode Demographic File";
run;
proc print data=storage.dmefzip (obs=10);
run;
title;

/*Look at the data*/
*******************************************************************8888;
proc means data=storage.dmefzip;
title "Summary Statistics for Zipcode File";
run;
title;

proc means data=storage.dmefzip n nmiss maxdec=0;
title "Missing Values Report for Zipcode File";
run;
title;

*count number of variables with missing values per record;
data temp;
set  storage.dmefzip;
nummiss=nmiss(of DMAWLTHR--populat);
run;
proc print data=temp (where=(nummiss>0) obs=10);
run;

*isolate records with at least 1 missing value;
data missing;
set  temp;
if   nummiss>0;
run;

*count total number of missing values;
proc means data=missing sum;
var nummiss;
run;

*figure out number of records affected and RELEVANT number of variables;
proc contents data=missing varnum;
run;

proc datasets lib=work nolist;
delete temp missing;
quit;
run;
*************************************************************************************88;

/*Create new data*/
**** create new variable;
data prefactor;
set storage.dmefzip;

census_stname=zipstate(zipcode);
zip=input(zipcode,8.0);
zp=zipcode*1;

run;
** QA;
proc print data=prefactor (obs=10);
run;

/*Change the data*/
proc sort data=prefactor;
by census_stname;
run;
*****changing the variables;
proc standard data=prefactor replace out=prefactor;
by census_stname;
run;

*****QA;
proc means data=prefactor n nmiss maxdec=0;
title "Missing Values Report for Zipcode File After Mean Replacement";
run;
title;
*******************************************************************************;

proc sort data=prefactor out=storage.prefactor;
by zip;
run;




