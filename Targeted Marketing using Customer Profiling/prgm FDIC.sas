/*This program reads in FDIC bank branch data
  aggregates data to zip level for number of bank branches 
  and number of competitor branched
  output final data to a permanent dataset and csv file
*/  

/*library statement*/
*	Note: adjust this as necessary;
* libname storage 'C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\New folder';

/*Check the FDIC data*/
proc contents data= storage.branch_fdic;
title "Checking the imported FDIC data file";
run;
proc print data=storage.branch_fdic (obs=10);
run;
title;

/*Create new data*/
**************************************************************************************;
proc sort data=storage.branch_fdic;
by  FI_UNINUM STALP SERVTYPE; /*zip servtype; */
run;
/*FI branch count*/
proc freq data=storage.branch_fdic (where=(fi_uninum=2238 and servtype=11 and upcase(stalp)="VA"))noprint;
tables fi_uninum*zip*stalp*servtype / out=storage.branch_count_fi (rename=(count=num_branches)) ;
run;
proc print data=storage.branch_count_fi (obs=10);
title "Bank branches output";
run;
title;
/*competitior branch count*/
proc freq data=storage.branch_fdic (where=(fi_uninum^=2238 and servtype=11 and upcase(stalp)="VA")) noprint;
tables zip*stalp*servtype / out=storage.branch_count_comp (rename=(count=num_branches_comp));
run;
proc print data=storage.branch_count_comp (obs=10);
title "Competitor branches output";
run;
title;
