LIBNAME mrgmastr 'E:\Merge_Main_File.xls';
DATA work.mainfile;
SET mrgmastr.'Merge_Main_File$'n;
RUN;
Proc Contents Data= work.mainfile;
Run;
LIBNAME newvarbl 'E:\Merge_Add_Variable.xls';
DATA work.varblnew;
SET newvarbl.'Merge_Add_Variable$'n;
RUN;
Proc Contents Data= work.varblnew;  
Run;
DATA work.mainfile;
Length TOWN $ 17 Company $ 50 NAMEF $ 8 NAMEL $ 11 Degrees $ 15 TITLE $ 38 STREET $ 35 STREET2 $ 20 ZIP $ 11 Phone $ 24 Fax $ 14 Websites $ 28 JobBoard $ 3 JobBoardNotes $ 12;
SET mrgmastr.'Merge_Main_File$'n;
LABEL 	
NAMEF = 		‘First Name’
NAMEL = 		‘Last Name’
STREET =		‘Street Address’
STREET2 =		‘Supplemental Address’
TOWN =		    ‘City’
ZIP =			‘Zip Code’
Phone =		    ‘Telephone’
Company =		‘Organization’
Websites =		‘Website’
JobBoard =		‘Has a Job Board’
JobBoardNotes =	‘Comments about Job Board’;
RUN;
DATA work.varblnew;
Length NAMEF $ 8 NAMEL $ 11 email $ 39 Company $ 50;
SET newvarbl.'Merge_Add_Variable$'n;
LABEL 	
NAMEF = 		‘First Name’
NAMEL = 		‘Last Name’;
RUN;
PROC SORT DATA= work.mainfile;
BY NAMEF NAMEL;
RUN;
PROC SORT DATA= work.varblnew;
BY NAMEF NAMEL;
RUN;
data work.varmerge;
    merge work.mainfile work.varblnew;
    by NAMEF NAMEL;
run;
Proc Print Data= work.varmerge;
run;
