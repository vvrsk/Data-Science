DATA work.scndpass;
length

		IDNUM         	 $ 13
        NameL            $ 13
        NameF            $ 14
        DOB_Month        $ 10
        DOB_Day            3
        DOB_Year           4
        Age                3
        Height             3
        Weight             4
        IdealWeight        4
        Years_Psz          3
        GAF_Start          3
        MedStart           8
        MonthStart       $ 9
        DayStart         $ 9
        MedEnd             8
        MonthEnd         $ 9
        DayEnd           $ 9
        GAF_End            3 
        MD_End_Comment   $ 21 ;

infile  'E:\ptdata97DIRTY_02.csv' DLM = ',' MISSOVER DSD FIRSTOBS=2;
*Different from other passses as some oft he fiels are imported as a number and other is a string;
INPUT	 			

		IDNUM            $ 
        NameL            $ 
        NameF            $ 
        DOB_Month        $ 
		DOB_Day						
        DOB_Year
        Age
        Height
        Weight
        IdealWeight
        Years_Psz
        GAF_Start
        MedStart
		MonthStart       $ 
        DayStart         $ 
		MedEnd
        MonthEnd         $ 
        DayEnd           $ 
		GAF_End
        MD_End_Comment   $  ;

FORMAT ROW_NUM 4.;
ROW_NUM=_N_;


informat MedStart MedEnd MMDDYY10.; 
format MedStart MedEnd MMDDYY10. ;


RUN;

		/* End NINE */
		/* End TEN */
		/* End ELEVEN */
		/* End TWELVE */

Proc Freq Data= work.scndpass;
where (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'January')) or (DOB_Day Not Between 1 and 29 AND (DOB_Month = 'February')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'March')) or (DOB_Day Not Between 1 and 30 AND (DOB_Month = 'April')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'May')) or (DOB_Day Not Between 1 and 30 AND (DOB_Month = 'June')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'July')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'August')) or (DOB_Day Not Between 1 and 30 AND (DOB_Month = 'September')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'October')) or (DOB_Day Not Between 1 and 30 AND (DOB_Month = 'November')) or(DOB_Day Not Between 1 and 31 AND (DOB_Month = 'December')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = ''));
tables DOB_Day;
title "Frequencies of Out-of-Range values in DOB_Day";
Run;


proc print Data= work.scndpass;
where (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'January')) or (DOB_Day Not Between 1 and 29 AND (DOB_Month = 'February')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'March')) or (DOB_Day Not Between 1 and 30 AND (DOB_Month = 'April')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'May')) or (DOB_Day Not Between 1 and 30 AND (DOB_Month = 'June')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'July')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'August')) or (DOB_Day Not Between 1 and 30 AND (DOB_Month = 'September')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = 'October')) or (DOB_Day Not Between 1 and 30 AND (DOB_Month = 'November')) or(DOB_Day Not Between 1 and 31 AND (DOB_Month = 'December')) or (DOB_Day Not Between 1 and 31 AND (DOB_Month = ''));
ID ROW_NUM;
var DOB_Day;
title "Out-of-Range values in DOB_Day";
Run;



/* End THIRTEEN    */
   




Proc Freq Data= work.scndpass;
where DOB_Year Not Between 1932 and 1976 and not missing (DOB_Year);
tables DOB_Year;
title "Frequencies of Out-of-Range values in DOB_Year";
Run;



proc print Data= work.scndpass;
where DOB_Year Not Between 1932 and 1976 and not missing (DOB_Year);
ID ROW_NUM;
var Age Years_Psz DOB_Year;
title "Out-of-Range values in DOB_Year";
Run;




Proc Freq Data= work.scndpass;
where Age Not Between 21 and 65 and not missing (Age);
tables Age;
title "Frequencies of Out-of-Range values in Age";
Run;


proc print Data= work.scndpass;
where Age Not Between 21 and 65 and not missing (Age);
ID ROW_NUM;
var DOB_Year Age;
title "Out-of-Range values in Age";
Run;



proc print Data= work.scndpass;
where (1997-(DOB_Year + Age) <  - 1 or 1997-(DOB_Year + Age) > 1) and not missing (Age) and not missing (DOB_Year);
ID ROW_NUM;
var DOB_Year Age Years_Psz;
title "Discrepancy between Stated Age and DOB_Year";
Run;



/* End FOURTEEN   */




Proc Freq Data= work.scndpass;
where not missing (Height) and Height Not Between 60 and 84;
tables Height;
title "Frequencies of Out-of-Range values in Height";
Run;


proc print Data= work.scndpass;
where not missing (Height) and Height Not Between 60 and 84;
ID ROW_NUM;
var Height;
title "Out-of-Range values in Height";
Run;





Proc Freq Data= work.scndpass;
where not missing (Weight) and Weight Not Between 110 and 325;
tables Weight;
title "Frequencies of Out-of-Range values in Weight";
Run;


proc print Data= work.scndpass;
where not missing (Weight) and Weight Not Between 110 and 325;
ID ROW_NUM;
var Weight;
title "Out-of-Range values in Weight";
Run;




Proc Freq Data= work.scndpass;
where IdealWeight Not In (131 134 137 139 142 145 148 151 154 157 160 164 167 171 175 179 184 189 195 201 207 213 219 226 234) and not missing (IdealWeight);
tables IdealWeight;
title "Frequencies of Out-of-Range values in IdealWeight";
Run;


proc print Data= work.scndpass;
where IdealWeight Not In (131 134 137 139 142 145 148 151 154 157 160 164 167 171 175 179 184 189 195 201 207 213 219 226 234) and not missing (IdealWeight);
ID ROW_NUM;
var IdealWeight;
title "Out-of-Range values in IdealWeight";
Run;




proc print Data= work.scndpass;
where Height < 0 and not missing (IdealWeight);
ID ROW_NUM;
var IdealWeight;
title "Values of IdealWeight When Height is Missing";
Run;


proc print Data= work.scndpass;
where IdealWeight < 0 and not missing (Height);
ID ROW_NUM;
var Height;
title "Values of Height When IdealWeight is Missing";
Run;





proc print Data= work.scndpass;
where Weight < 0 and not missing (Height) and not missing (IdealWeight);
ID ROW_NUM;
var Height IdealWeight;
title "Values of Height and IdealWeight When Weight is Missing";
Run;









Proc Freq Data= work.scndpass;
where not missing (Years_Psz) and Years_Psz Not Between 1 and 48;
tables Years_Psz;
title "Frequencies of Out-of-Range values in Years_Psz";
Run;


proc print Data= work.scndpass;
where not missing (Years_Psz) and Years_Psz Not Between 1 and 48;
ID ROW_NUM;
var Years_Psz;
title "Out-of-Range values in Years_Psz";
Run;



proc print Data= work.scndpass;
where Age - Years_Psz < 16 or Age - Years_Psz > 64  ;
ID ROW_NUM;
var Years_Psz Age DOB_Year;
title "Discrepancy between Stated Age and Years_Psz";
Run;




Proc Freq Data= work.scndpass;
where not missing (GAF_Start) and GAF_Start Not Between 20 and 50;
tables GAF_Start;
title "Frequencies of Out-of-Range values in GAF_Start";
Run;


proc print Data= work.scndpass;
where not missing (GAF_Start) and GAF_Start Not Between 20 and 50;
ID ROW_NUM;
var GAF_Start;
title "Out-of-Range values in GAF_Start";
Run;





Proc Freq Data= work.scndpass;
where not missing (MedStart) and MedStart Not Between '01JUN1997'd and '31DEC1997'd ;
tables MedStart;
title "Frequencies of Out-of-Range dates in MedStart";
Run;


proc print Data= work.scndpass;
where not missing (MedStart) and MedStart Not Between '01JUN1997'd and '31DEC1997'd ;
ID ROW_NUM;
var MedStart;
title "Out-of-Range dates in MedStart";
Run;





Proc Freq Data= work.scndpass;
where not missing (MedEnd) and MedEnd Not Between '01DEC1997'd and '30JUN1998'd ;
tables MedEnd;
title "Frequencies of Out-of-Range dates in MedEnd";
Run;


proc print Data= work.scndpass;
where not missing (MedEnd) and MedEnd Not Between '01DEC1997'd and '30JUN1998'd ;
ID ROW_NUM;
var MedEnd;
title "Out-of-Range dates in MedEnd";
Run;





Proc Freq Data= work.scndpass;
where not missing (GAF_End) and GAF_End Not Between 10 and 100;
tables GAF_End;
title "Frequencies of Out-of-Range values in GAF_End";
Run;


proc print Data= work.scndpass;
where not missing (GAF_End) and GAF_End Not Between 10 and 100;
ID ROW_NUM;
var GAF_Start GAF_End;
title "Out-of-Range values in GAF_End";
Run;


IDSIZE = length(IDNUM); /*This gives the length of the character string, not counting any leading or trailing blanks*/ 
IDBROKEN = scan(IDNUM, -1, ' '); /*this will return the last section of the character string, if there is a blank in the middle of the string, otherwise, if there are no blanks, it will return the entire string*/
CKBROKEN = length(IDBROKEN); /*This gives the length of the character string of the IDBROKEN variable, so that we can compare it with the IDNUM field length, to determine whether there were any improperly entered blanks that broke up the string for one or more cells*/
IDSTRING = compress(IDNUM, ' -,.'); /*This removes all stipulated unwanted characters and/or blanks from the character field*/



Proc Freq Data= work.scndpass;
Where MedStart Not Like '%_/%_/1997';  *Very Very important and only available in SAS;
tables MedStart;
title "Frequencies of Some of the illegal code types in MedStart Variable";
Run;

proc print Data= work.scndpass;
Where MedStart Not Like '%_/%_/1997';;
ID ROW_NUM;
var MedStart;
title "Some of the Illegal Codes in MedStart Variable";
Run;        

Proc Freq Data= work.scndpass;
Where MedEnd Not Like '%_/%_/199_';
tables MedEnd;
title "Frequencies of Some of the illegal code types in MedEnd Variable";
Run;

proc print Data= work.scndpass;
Where MedEnd Not Like '%_/%_/199_';;
ID ROW_NUM;
var MedEnd;
title "Some of the Illegal Codes in MedEnd Variable";
Run;        
