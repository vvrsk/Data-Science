/*This program reads in FDIC bank branch data
  aggregates data to zip level for number of bank branches 
  and number of competitor branched
  output final data to a permanent dataset and csv file
*/  

/*library statement*/
*	Note: adjust this as necessary;
libname storage 'C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\New folder';

/*merge dataset together
 keep only zipcodes where FI is located*/
data storage.branch_fi_comp_census;
merge branch_count_fi (drop=percent in=a) branch_count_comp (drop=percent in=b) prefactor (in=c);
by zip;
if a;
if a and ^b then num_branches_comp=0;
if a and ^c  then missing_census=1;
else missing_census=0;
run;
***QA;
proc print data=storage.branch_fi_comp_census ; *(obs=10);
title "merged data QA";
run;
title;

**************************************************************************************;

/*Output the data*/
**** create csv file;
proc export data=storage.branch_fi_comp_census 
	outfile='C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\New folder\out_branch_census.csv' 
	dbms=csv replace;
run;
