data work.rxtrial;
length  
IDNUM            $ 13
NameL            $ 13
NameF            $ 14
DOB_Month        $ 9
DOB_Day          $  8
DOB_Year         $  9
Age              $ 4
Height           $ 13
Weight            $ 8
IdealWeight      $  8
Years_Psz        $ 11
GAF_Start        $ 8
MedStart	     $ 15
MonthStart       $ 10
DayStart         $ 11
MedEnd			 $ 15
MonthEnd         $ 8
DayEnd           $ 9
GAF_End          $ 8
MD_End_Comment   $ 21 ;

infile  'E:\ptdata97.csv' DLM = ',' MISSOVER DSD FIRSTOBS=2;

INPUT	 			
		IDNUM            $ 
        NameL            $ 
        NameF            $ 
        DOB_Month        $ 
        DOB_Day          $  
        DOB_Year         $  
        Age              $ 
        Height           $ 
        Weight           $  
        IdealWeight      $  
        Years_Psz        $ 
        GAF_Start        $ 
        MedStart         $ 
        MonthStart       $ 
        DayStart         $ 
        MedEnd           $ 
        MonthEnd         $ 
        DayEnd           $ 
        GAF_End          $ 
        MD_End_Comment   $  ;


IDNUMDUM		=	0;
DOBMTDUM		=	0;
DOBDYDUM		=	0;
DOBYRDUM		=	0;
AGEDUM			=	0;
HEIGTDUM		=	0;
WEIGTDUM		=	0;
IDLWTDUM		=	0;
YRPSZDUM		=	0;
GSTRTDUM		=	0;

MTHSTDUM		=	0;
DAYSTDUM		=	0;

MTHNDDUM		=	0;
DAYNDDUM		=	0;
GAFNDDUM		=	0;
SUMDUMMY		=	0;

LastID = lag (IDNUM); 
*lag -looks at the previous rows to check for the duplicates ;
SecLstID = lag2 (IDNUM);

if LastID EQ IDNUM or SecLstID EQ IDNUM THEN IDDUP = 1;
ELSE IDDUP	= 	0;



FORMAT ROW_NUM 4.;
ROW_NUM=_N_;



if notdigit (trim(IDNUM)) and not missing (IDNUM)THEN IDNUMDUM = 1; 
if notdigit (trim(DOB_Day)) and not missing (DOB_Day) THEN DOBDYDUM = 1; 
if notdigit (trim(DOB_Year)) and not missing (DOB_Year) THEN DOBYRDUM = 1; 
if notdigit (trim(Age)) and not missing (Age) THEN AGEDUM = 1; 
if notdigit (trim(Height)) and not missing (Height) THEN HEIGTDUM = 1; 
if notdigit (trim(Weight)) and not missing (Weight) THEN WEIGTDUM = 1; 
if notdigit (trim(IdealWeight)) and not missing (IdealWeight) THEN IDLWTDUM = 1; 
if notdigit (trim(Years_Psz)) and not missing (Years_Psz) THEN YRPSZDUM = 1; 
if notdigit (trim(GAF_Start)) and not missing (GAF_Start) THEN GSTRTDUM = 1; 
if notdigit (trim(GAF_End)) and not missing (GAF_End) THEN GAFNDDUM = 1; 

if DOB_Month not in ('January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December' ' ') THEN DOBMTDUM = 1;
if MonthStart not in ('January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December' ' ') THEN MTHSTDUM = 1;
if DayStart not in ('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday' ' ') THEN DAYSTDUM = 1;
if MonthEnd not in ('January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December' ' ') THEN MTHNDDUM = 1;
if DayEnd not in ('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday' ' ') THEN DAYNDDUM = 1;

SUMDUMMY = (IDNUMDUM + IDDUP + DOBMTDUM + DOBDYDUM + DOBYRDUM + AGEDUM + HEIGTDUM + WEIGTDUM + IDLWTDUM + YRPSZDUM + GSTRTDUM + MTHSTDUM + DAYSTDUM + MTHNDDUM + DAYNDDUM + GAFNDDUM);




RUN;

/* End ONE */

Proc Freq Data= work.rxtrial;
Where SUMDUMMY > 1;
tables SUMDUMMY;
title "Frequencies of Records with Multiple Illegal Codes in Summary Dummy-Flag Variable";
Run;

/* End TWO */


proc print Data= work.rxtrial;
where SUMDUMMY > 1;
ID ROW_NUM;
var IDNUMDUM IDDUP DOBMTDUM DOBDYDUM DOBYRDUM AGEDUM HEIGTDUM WEIGTDUM IDLWTDUM YRPSZDUM GSTRTDUM MedStart MTHSTDUM DAYSTDUM MedEnd MTHNDDUM DAYNDDUM GAFNDDUM;
title "Printout of Zeros/Ones for Records With Illegal Codes In Multiple Fields";
Run;

/* End THREE */

proc print Data= work.rxtrial;
where SUMDUMMY > 1;
var ROW_NUM IDNUM NameL NameF DOB_Month DOB_Day DOB_Year Age Height Weight IdealWeight Years_Psz GAF_Start MedStart MonthStart DayStart MedEnd MonthEnd DayEnd GAF_End MD_End_Comment ;
title "Printout Full Records of Fields with Multiple Illegal Codes";
Run;

/* End FOUR */

proc print Data= work.rxtrial;
where IDNUMDUM = 1 OR IDDUP = 1 OR Missing (IDNUM);
ID ROW_NUM;
var IDNUM LastID SecLstID;
title "Illegal Codes or Duplicates or Missing in IDNUM Variable";
Run;

/* End FIVE */


Proc Means Data= work.rxtrial;
var IDNUMDUM DOBMTDUM DOBDYDUM DOBYRDUM AGEDUM HEIGTDUM WEIGTDUM IDLWTDUM YRPSZDUM GSTRTDUM MTHSTDUM DAYSTDUM MTHNDDUM DAYNDDUM GAFNDDUM;
title "Means for Dummy Error-Flag Variables";
Run;

/* End SIX */

Proc Freq Data= work.rxtrial;
where DOBMTDUM = 1;
tables DOB_Month;
title "Frequencies of illegal code types in DOB_Month Variable";
Run;
proc print Data= work.rxtrial;
where DOBMTDUM = 1;
ID ROW_NUM;
var DOB_Month;
title "Illegal Codes in DOB_Month Variable";
Run;





Proc Freq Data= work.rxtrial;
where DOBDYDUM = 1;
tables DOB_Day;
title "Frequencies of illegal code types in DOB_Day Variable";
Run;
proc print Data= work.rxtrial;
where DOBDYDUM = 1;
ID ROW_NUM;
var DOB_Day;
title "Illegal Codes in DOB_Day Variable";
Run;





Proc Freq Data= work.rxtrial;
where DOBYRDUM = 1;
tables DOB_Year;
title "Frequencies of illegal code types in DOB_Year Variable";
Run;
proc print Data= work.rxtrial;
where DOBYRDUM = 1;
ID ROW_NUM;
var DOB_Year;
title "Illegal Codes in DOB_Year Variable";
Run;





Proc Freq Data= work.rxtrial;
where AGEDUM = 1;
tables Age;
title "Frequencies of illegal code types in Age Variable";
Run;
proc print Data= work.rxtrial;
where AGEDUM = 1;
ID ROW_NUM;
var Age;
title "Illegal Codes in Age Variable";
Run;





Proc Freq Data= work.rxtrial;
where HEIGHTDUM = 1;
tables Height;
title "Frequencies of illegal code types in Height Variable";
Run;
proc print Data= work.rxtrial;
where HEIGTDUM = 1;
ID ROW_NUM;
var Height;
title "Illegal Codes in Height Variable";
Run;





Proc Freq Data= work.rxtrial;
where WEIGHTDUM = 1;
tables Weight;
title "Frequencies of illegal code types in Weight Variable";
Run;
proc print Data= work.rxtrial;
where WEIGTDUM = 1;
ID ROW_NUM;
var Weight;
title "Illegal Codes in Weight Variable";
Run;    





Proc Freq Data= work.rxtrial;
where IDLWTDUM = 1;
tables IdealWeight;
title "Frequencies of illegal code types in IdealWeight Variable";
Run;
proc print Data= work.rxtrial;
where IDLWTDUM = 1;
ID ROW_NUM;
var IdealWeight;
title "Illegal Codes in IdealWeight Variable";
Run;        





Proc Freq Data= work.rxtrial;
where YRPSZDUM = 1;
tables Years_Psz;
title "Frequencies of illegal code types in Years_Psz Variable";
Run;
proc print Data= work.rxtrial;
where YRPSZDUM = 1;
ID ROW_NUM;
var Years_Psz;
title "Illegal Codes in Years_Psz Variable";
Run;        





Proc Freq Data= work.rxtrial;
where GSTRTDUM = 1;
tables GAF_Start;
title "Frequencies of illegal code types in GAF_Start Variable";
Run;
proc print Data= work.rxtrial;
where GSTRTDUM = 1;
ID ROW_NUM;
var GAF_Start;
title "Illegal Codes in GAF_Start Variable";
Run;        




Proc Freq Data= work.rxtrial;
where MTHSTDUM = 1;
tables MonthStart;
title "Frequencies of illegal code types in MonthStart Variable";
Run;
proc print Data= work.rxtrial;
where MTHSTDUM = 1;
ID ROW_NUM;
var MonthStart;
title "Illegal Codes in MonthStart Variable";
Run;        





Proc Freq Data= work.rxtrial;
where DAYSTDUM = 1;
tables DayStart;
title "Frequencies of illegal code types in DayStart Variable";
Run;
proc print Data= work.rxtrial;
where DAYSTDUM = 1;
ID ROW_NUM;
var DayStart;
title "Illegal Codes in DayStart Variable";
Run;        







Proc Freq Data= work.rxtrial;
where MTHNDDUM = 1;
tables MonthEnd;
title "Frequencies of illegal code types in MonthEnd Variable";
Run;
proc print Data= work.rxtrial;
where MTHNDDUM = 1;
ID ROW_NUM;
var MonthEnd;
title "Illegal Codes in MonthEnd Variable";
Run;                





Proc Freq Data= work.rxtrial;
where DAYNDDUM = 1;
tables DayEnd;
title "Frequencies of illegal code types in DayEnd Variable";
Run;
proc print Data= work.rxtrial;
where DAYNDDUM = 1;
ID ROW_NUM;
var DayEnd;
title "Illegal Codes in DayEnd Variable";
Run;                





Proc Freq Data= work.rxtrial;
where GAFNDDUM = 1;
tables GAF_End;
title "Frequencies of illegal code types in GAF_End Variable";
Run;
proc print Data= work.rxtrial;
where GAFNDDUM = 1;
ID ROW_NUM;
var GAF_End;
title "Illegal Codes in GAF_End Variable";
Run;



Proc Freq Data= work.rxtrial;
Where MedStart Not Like '%_/%_/1997';
tables MedStart;
title "Frequencies of Some of the illegal code types in MedStart Variable";
Run;

proc print Data= work.rxtrial;
Where MedStart Not Like '%_/%_/1997';;
ID ROW_NUM;
var MedStart;
title "Some of the Illegal Codes in MedStart Variable";
Run;        

Proc Freq Data= work.rxtrial;
Where MedEnd Not Like '%_/%_/199_';
tables MedEnd;
title "Frequencies of Some of the illegal code types in MedEnd Variable";
Run;

proc print Data= work.rxtrial;
Where MedEnd Not Like '%_/%_/199_';;
ID ROW_NUM;
var MedEnd;
title "Some of the Illegal Codes in MedEnd Variable";
Run;        




Proc Sort Data=work.rxtrial;
by MedStart;
Run;
Proc Freq Data= work.rxtrial;
tables MedStart;
title "Frequencies of Response-Types in MedStart (Ascending) Variable";
Run;
proc print Data= work.rxtrial;
Where MedStart In ( '1222/97' 'JUN1097' 'July 30th, 1997' '8/26/4013' '100/3/1997' '21/21/1997' '18/11/1997' '11/31/1997' );  
ID ROW_NUM;
var MedStart;
title "Printout of MedStart (Ascending)with ROW_NUM for Cross Reference";
Run;



Proc Sort Data=work.rxtrial;
by MedEnd;
Run;
Proc Freq Data= work.rxtrial;
tables MedEnd;
title "Frequencies of Response-Types in MedEnd (Ascending) Variable";
Run;
proc print Data= work.rxtrial;
Where MedEnd In ( '3/5/19988' '1/24/1900'  );
ID ROW_NUM;
var MedEnd;
title "Printout of MedEnd (Ascending)with ROW_NUM for Cross Reference";
Run;


/* End SEVEN */
