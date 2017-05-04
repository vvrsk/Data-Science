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
MedEnd  	     $ 15
MonthEnd         $ 8
DayEnd           $ 9
GAF_End          $ 8
MD_End_Comment   $ 21 ;

infile  'E:\ptdata97DIRTY.csv' DLM = ',' MISSOVER DSD FIRSTOBS=2;

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

FORMAT ROW_NUM 4.;
ROW_NUM=_N_;

LastID = lag (IDNUM);
SecLstID = lag2 (IDNUM);
if LastID EQ IDNUM or SecLstID EQ IDNUM THEN IDDUP = 1;
ELSE IDDUP	= 	0;


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


If DOBMTDUM	= 1 THEN DO;
DOB_Month= tranwrd(DOB_Month, '12' , 'December');
DOB_Month= tranwrd(DOB_Month, 'Sep' , 'September');
DOB_Month= tranwrd(DOB_Month, 'Gordon' , 'September');
DOB_Month= tranwrd(DOB_Month, 'Mar' , 'March');
DOB_Month= tranwrd(DOB_Month, 'Dece.' , 'December');
DOB_Month= tranwrd(DOB_Month, 'Frederick' , 'May');
DOB_Month= tranwrd(DOB_Month, 'Febuary' , 'February');
DOB_Month= tranwrd(DOB_Month, 'Mathew' , 'November');
DOB_Month= tranwrd(DOB_Month, 'Januday' , 'January');
DOB_Month= tranwrd(DOB_Month, 'Dec.' , 'December');
DOB_Month= tranwrd(DOB_Month, '5' , 'May');
DOB_Month= tranwrd(DOB_Month, 'J.' , 'April');
DOB_Month= propcase(DOB_Month);
end;

If IDNUMDUM = 1 then do;
IDNUM= tranwrd(IDNUM, '1,907,252,031' , '1907252031');
IDNUM= tranwrd(IDNUM, '162821400x' , '162821400');
End;




If DOBYRDUM = 1 then do;
DOB_Year= tranwrd(DOB_Year, '16-Sep-59' , '1959');
DOB_Year= tranwrd(DOB_Year, '19-May-60' , '1960');
DOB_Year= tranwrd(DOB_Year, '9-Nov-57' , '1957');
DOB_Year= tranwrd(DOB_Year, '14-Apr-47' , '1947');
End;







If NameL = 'Burton' and NameF = 'Scott' then do;
IDNUM = '218205012222';
end;

if NameL = 'Beisner' and NameF = 'Kurt' then do;
Age= '48' ;
end;

if NameL = 'Dempsey' and NameF = 'John' then do;
Height= '72' ; 
end;

if NameL = 'Bocinsky' and NameF = 'James' then do;
Height= '69' ;
end;

if NameL = 'Busby' and NameF = 'John' then do;
Height= '71' ;
end;

if NameL = 'Balcom' and NameF = 'William' then do;
Height= '68' ;
end;

if NameL = 'Billings' and NameF = 'Steven' then do;
Height= '67' ;
end;

If AGEDUM = 1 then do;
Age= tranwrd(Age, '4/8' , '48');
Age= tranwrd(Age, '2.6' , '26');
Age= tranwrd(Age, '.47' , '47');
End;



/* Check to see if the below recodes will run given the [6’0”] use of single-quote */ 



If HEIGTDUM = 1 then do;
Height= tranwrd(Height, '6’0"' , '72');
Height= tranwrd(Height, '70.5' , '71');
Height= tranwrd(Height, '67.' , '67');
Height= tranwrd(Height, 'Seventy-Four' , '74');
Height= tranwrd(Height, 'Seventy-Three' , '73');
Height= tranwrd(Height, '5’9"' , '69');
Height= tranwrd(Height, '5’11"' , '71');
Height= tranwrd(Height, 'Seventy' , '70');
Height= tranwrd(Height, 'Sixty-Seven' , '67');
Height= tranwrd(Height, '5’8"' , '68');
Height= tranwrd(Height, '5’7"' , '67');
Height= tranwrd(Height, '68*' , '68');
Height= tranwrd(Height, '69..5' , '70');
End;



If WEIGTDUM = 1 then do;
Weight= tranwrd(Weight, '15 6' , '156');
Weight= tranwrd(Weight, '136.5' , '137');
Weight= tranwrd(Weight, '147.' , '147');
End;



If YRPSZDUM = 1 then do;
Years_Psz= tranwrd(Years_Psz, 'Around 20' , '20');
Years_Psz= tranwrd(Years_Psz, '1 to 2' , '2');
Years_Psz= tranwrd(Years_Psz, '5+' , '5');
Years_Psz= tranwrd(Years_Psz, 'Twenty Four' , '24');
End;


If GSTRTDUM = 1 then do;
GAF_Start= tranwrd(GAF_Start, 'Forty' , '40');
GAF_Start= tranwrd(GAF_Start, '31 to 40' , '40');
GAF_Start= tranwrd(GAF_Start, 'Thirty' , '30');
GAF_Start= tranwrd(GAF_Start, 'Fifty' , '50');
End;



If MTHSTDUM = 1 then do;
MonthStart= tranwrd(MonthStart, '7' , 'July');
MonthStart= tranwrd(MonthStart, 'Septmber' , 'September');
MonthStart= tranwrd(MonthStart, '/September' , 'September');
MonthStart= tranwrd(MonthStart, '6' , 'June');
MonthStart= tranwrd(MonthStart, 'Nov' , 'November');
MonthStart= tranwrd(MonthStart, 'Jule' , 'July');
MonthStart= tranwrd(MonthStart, '8' , 'August');
MonthStart= tranwrd(MonthStart, '10' , 'October');
MonthStart= tranwrd(MonthStart, '11' , 'November');
MonthStart= tranwrd(MonthStart, 'Oct.' , 'October');
MonthStart= propcase(MonthStart); * Convert into proper case;
End;


If DAYSTDUM = 1 then do;
DayStart= tranwrd(DayStart, 'Wesnesday' , 'Wednesday');
DayStart= tranwrd(DayStart, 'Tue.' , 'Tuesday');
DayStart= tranwrd(DayStart, 'Tue' , 'Tuesday');
DayStart= tranwrd(DayStart, 'Firday' , 'Friday');
DayStart= tranwrd(DayStart, 'Monday, 3pm' , 'Monday');
DayStart= tranwrd(DayStart, 'Thurdsay' , 'Thursday');
DayStart= propcase(DayStart);
End;


If not missing (MedEnd) then do;
MedEnd= tranwrd(MedEnd, '3/5/19988' , '03/05/1998'); /* ROW_NUM 609 */ 
MedEnd= tranwrd(MedEnd, '1/24/1900' , '01/24/1998'); /* ROW_NUM 424 */
MedEnd= propcase(MedEnd);
End;


If MTHNDDUM = 1 then do;
MonthEnd= tranwrd(MonthEnd, '1' , 'January');
MonthEnd= tranwrd(MonthEnd, '05' , 'May');
MonthEnd= tranwrd(MonthEnd, 'Janruary' , 'January');
MonthEnd= tranwrd(MonthEnd, 'Feb.' , 'February');
MonthEnd= tranwrd(MonthEnd, '3' , 'March');
MonthEnd= propcase(MonthEnd);
End;


If DAYNDDUM = 1 then do;
DayEnd= tranwrd(DayEnd, 'wednesday' , 'Wednesday');
DayEnd= tranwrd(DayEnd, 'Thurs.' , 'Thursday');
DayEnd= propcase(DayEnd);
End;


If GAFNDDUM = 1 then do;
GAF_End= tranwrd(GAF_End, 'Thirty' , '30');
GAF_End= tranwrd(GAF_End, '10 to 29' , '20');
GAF_End= tranwrd(GAF_End, 'Forty' , '40');
GAF_End= tranwrd(GAF_End, 'Fifty' , '50');
GAF_End= tranwrd(GAF_End, '50+' , '50');
End;


If not missing (MedStart) then do;
MedStart= tranwrd(MedStart, '1222/1997' , '12/22/1997'); /* ROW_NUM = 11 */ 
MedStart= tranwrd(MedStart, '11/31/1997' , '12/31/1997'); /* ROW_NUM = 48 */ 
MedStart= tranwrd(MedStart, '18/11/1997' , '11/18/1997'); /* ROW_NUM = 108 */ 
MedStart= tranwrd(MedStart, '21/21/1997' , '10/21/1997'); /* ROW_NUM = 247 */ 
MedStart= tranwrd(MedStart, '100/3/1997' , '10/03/1997'); /* ROW_NUM = 337 */ 
MedStart= tranwrd(MedStart, 'July 30th, 1997' , '07/30/1997'); /* ROW_NUM = 802 */ 
MedStart= tranwrd(MedStart, '8/26/4013' , '08/26/1997'); /* ROW_NUM = 938 */ 
MedStart= tranwrd(MedStart, 'JUN1097' , '06/10/1997'); /* ROW_NUM = 984 */ 
End;


RUN;

/* End EIGHT */


