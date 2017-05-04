
libname storage 'C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\New folder';

/*Input the Data*/

/*Get the data*/
*read in FDIC data*;
	data STORAGE.BRANCH_FDIC;
      %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
      infile 'C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\Projects\Data\fdic_branch.csv'
		delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
         informat ADDRESS $30. ;
         informat BKCLASS $2. ;
         informat CBSA $15. ;
         informat CBSA_DIV $1. ;
         informat CBSA_DIV_FLG best32. ;
         informat CBSA_DIV_NO best32. ;
         informat CBSA_METRO best32. ;
         informat CBSA_METRO_FLG best32. ;
         informat CBSA_METRO_NAME $15. ;
         informat CBSA_MICRO_FLG best32. ;
         informat CBSA_NO best32. ;
         informat CERT best32. ;
         informat CITY $12. ;
         informat COUNTY $10. ;
         informat CSA $1. ;
         informat CSA_FLG best32. ;
         informat CSA_NO best32. ;
         informat ESTYMD yymmdd10. ;
         informat FI_UNINUM best32. ;
         informat MAINOFF best32. ;
         informat NAME $37. ;
         informat OFFNAME $34. ;
         informat OFFNUM best32. ;
         informat RUNDATE yymmdd10. ;
         informat SERVTYPE best32. ;
         informat STALP $2. ;
         informat STCNTY best32. ;
         informat STNAME $30. ;
         informat UNINUM best32. ;
         informat ZIP best32. ;
         informat UNINUMBR best32. ;
         informat DEPSUMBR best32. ;
         informat loansumbr best32. ;
         format ADDRESS $30. ;
         format BKCLASS $2. ;
         format CBSA $15. ;
         format CBSA_DIV $1. ;
         format CBSA_DIV_FLG best12. ;
         format CBSA_DIV_NO best12. ;
         format CBSA_METRO best12. ;
         format CBSA_METRO_FLG best12. ;
         format CBSA_METRO_NAME $15. ;
         format CBSA_MICRO_FLG best12. ;
         format CBSA_NO best12. ;
         format CERT best12. ;
         format CITY $12. ;
         format COUNTY $10. ;
         format CSA $1. ;
         format CSA_FLG best12. ;
         format CSA_NO best12. ;
         format ESTYMD yymmdd10. ;
         format FI_UNINUM best12. ;
         format MAINOFF best12. ;
         format NAME $37. ;
         format OFFNAME $34. ;
         format OFFNUM best12. ;
         format RUNDATE yymmdd10. ;
         format SERVTYPE best12. ;
         format STALP $2. ;
         format STCNTY best12. ;
         format STNAME $30. ;
         format UNINUM best12. ;
         format ZIP best12. ;
         format UNINUMBR best12. ;
         format DEPSUMBR best12. ;
         format loansumbr best12. ;
      input
                  ADDRESS $
                  BKCLASS $
                  CBSA $
                  CBSA_DIV $
                  CBSA_DIV_FLG
                  CBSA_DIV_NO
                  CBSA_METRO
                  CBSA_METRO_FLG
                  CBSA_METRO_NAME $
                  CBSA_MICRO_FLG
                  CBSA_NO
                  CERT
                  CITY $
                  COUNTY $
                  CSA $
                  CSA_FLG
                  CSA_NO
                  ESTYMD
                  FI_UNINUM
                  MAINOFF
                  NAME $
                  OFFNAME $
                  OFFNUM
                  RUNDATE
                  SERVTYPE
                  STALP $
                  STCNTY
                  STNAME $
                  UNINUM
                  ZIP
                  UNINUMBR
                  DEPSUMBR
                  loansumbr
      ;
      if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
      run;

proc print data=STORAGE.BRANCH_FDIC (obs=10);
run;
proc freq;
tables stname;
run;

proc datasets;run;
