LIBNAME merging 'C:\Users\vvrsk\OneDrive\Fall 2016\SAS-Workshop\Dirty Data_data\Merge_Add_Cases.xls';
DATA work.mainfile;
SET merging.'Merge_Main_File$'n;
RUN;
Proc Contents Data= work.mainfile;
Run;
LIBNAME scndfile 'E:\Merge_Add_Cases.xls';
DATA work.addcases;
SET scndfile.'Merge_Add_Cases$'n;
RUN;
Proc Contents Data= work.addcases;  
Run;
DATA work.mainfile;
Length TOWN $ 17 Company $ 50 NAMEF $ 8 NAMEL $ 11 Degrees $ 15 TITLE $ 38 STREET $ 35 STREET2 $ 20 ZIP $ 11 Phone $ 24 Fax $ 14 Websites $ 28 JobBoard $ 3 JobBoardNotes $ 12;
SET merging.'Merge_Main_File$'n;
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
DATA work.addcases;
Length TOWN $ 17 Company $ 50 NAMEF $ 8 NAMEL $ 11 Degrees $ 15 TITLE $ 38 STREET $ 35 STREET2 $ 20 ZIP $ 11 Phone $ 24 Fax $ 14 Websites $ 28 JobBoard $ 3 JobBoardNotes $ 12;
SET scndfile.'Merge_Add_Cases$'n;
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
Proc Datasets;
APPEND BASE= work.mainfile DATA= work.addcases;  
Run;
Proc Print Data= work.mainfile;
Run;
