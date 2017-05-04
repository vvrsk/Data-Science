LIBNAME applepie 'E:\Longitudinal_Teen_BMI_Study.xls' ;
DATA work.norepeat;
Length TASTER $ 11 ;
SET applepie.'AppleTranspose$'n;
RUN;
PROC FORMAT;
  VALUE SEX
1= 'Male'
2= 'Female' 
;
RUN;
PROC FORMAT;
  VALUE PIES
1= 'Apple Crumb' 
2= 'Dutch Apple'
3= 'Granny Smith Apple'
4= 'Cinnamon Apple'
;
RUN;
PROC FORMAT;
  VALUE AGECAT
1= 'Age 21-32' 
2= 'Age 33-40'
3= 'Age 41-50'
4= 'Age 51-73'
;
RUN;
/* 
When you are running the most basic R-ANOVA, 
where the only factor you are using is the 
commonality among the DVs (in this example 
the commonality is that all the DVs are
flavor rating scores for apple-pie, so the 
basic Factor is "type of apple-pie"), then 
the test you run is called "One-Way Repeated-
Measures ANOVA." To run 1-Way-Repeated ANOVA 
tests, you can write your code with or without 
a "REPEATED" statement. However, if you do not 
use a "REPEATED" statement in your code, then 
you must transform your dataset from "short 
and fat" to "long and thin." In the Excel 
file containing the datasets, the tab labeled 
"ApplePies" is "short and fat," and the tab 
labeled "AppleTranspose" is "long and thin."

At first glance, it seems like both approaches 
each have their own strengths and weaknesses. I 
have not had enough time before class to deeply 
study and compare the two approaches, but at 
first try, it looks like I can only get an 
easily readable post-hoc test (aka "pairwise-
comparisons") if I do NOT use the REPEATED 
Statement. However, it also looks like I can 
only get the Sphericity (aka Mauchly) test if 
I DO use the REPEATED Statement.  If I had spent 
more time experimenting with these two 
approaches, then maybe I would have identified a 
method to get one or the other approach to 
produce the Sphericity AND the post-hoc tests, 
but, unfortunately, I have no more time before 
class to experiment with this.
*/

ODS GRAPHICS ON;
PROC GLM DATA=work.norepeat;
CLASS SUBJECT PIES;
MODEL SCORE= SUBJECT PIES;
MEANS PIES / TUKEY BON;
TITLE 'One-Factor, Across-Conditions, Repeated-Measures ANOVA';
TITLE2 'With No REPEATED Statement'
RUN;
QUIT;
ODS GRAPHICS OFF;



LIBNAME applepie 'E:\Longitudinal_Teen_BMI_Study.xls' ;
DATA work.tastetst;
Length Subject $ 11;
SET applepie.'ApplePies$'n;
Pie1 = Crumb;
Pie2 = Dutch;
Pie3 = GrannySmith;
Pie4 = Cinammon;
run;
PROC FORMAT;
  VALUE Sex
1= 'Male'
2= 'Female' 
;
RUN;
PROC FORMAT;
  VALUE AGECAT
1= 'Age 21-32' 
2= 'Age 33-40'
3= 'Age 41-50'
4= 'Age 51-73'
;
RUN;
PROC FREQ Data= work.tastetst;
tables Sex ;
RUN;
PROC UNIVARIATE Data= work.tastetst;
var Crumb Dutch GrannySmith Cinammon;
histogram / cfill=gray normal midpoints=1 to 10 by 1 kernel;
run;
PROC UNIVARIATE Data= work.tastetst;
var Age;
histogram / cfill=gray normal midpoints=20 to 80 by 10 kernel;
run;
ODS GRAPHICS ON;
Proc GLM data= work.tastetst;
MODEL Pie1 Pie2 Pie3 Pie4= / SOLUTION;
REPEATED Pie 4 PROFILE / PRINTE SUMMARY;
TITLE 'One-Factor, Across-Conditions, Repeated-Measures ANOVA';
TITLE2 'With The REPEATED Statement';
run;
Quit;
ODS GRAPHICS OFF;


/* 
Time for the fancy Proc GLM code to analyze
scores on the Repeated-Measures DV's, based upon 
the Factors of Gender, Category of Age, and the 
Interaction between those two Factors.
*/

ODS GRAPHICS ON;
Proc GLM data= work.tastetst;

CLASS Sex AGECAT;

MODEL Pie1 Pie2 Pie3 Pie4= Sex AGECAT Sex*AGECAT 
/ SOLUTION CLPARM ;

REPEATED Pie 4 PROFILE / SUMMARY PRINTE PRINTM MSTAT=FAPPROX;

CONTRAST 'Dutch Apple VS Others' Pie 0.33 -1 0.33 0.33;

MANOVA  h=intercept  m=(1 -1 0 0,
                       0 1 -1 0,
                       0 1 0 -1) 
PREFIX=DIFF / PRINTE ;


MEANS Sex AGECAT Sex*AGECAT 
/ TUKEY BON;


LSMEANS AGECAT / OUT=MEANS  ;
TITLE 'Repeated-Measures ANOVA, Across-Conditions';
TITLE2 'With Factors of Sex & Age of Taste-Testers';
RUN;
QUIT;
ODS GRAPHICS OFF;
/* Time for Graphs ! */	

proc print data=work.means;
run;
proc sort data=means out=sortage;
 by AGECAT;
run;
goptions reset=all;
symbol1 c=blue v=star h=.9 i=j;
symbol2 c=red v=dot h=1.1 i=j;
symbol3 c=green v=diamond h=1 i=j;
symbol4 c=yellow v=triangle h=1 i=j;
axis1 order=(1 to 10 by 1) label=(a=3 'Means of Flavor Scores');
axis2 value=('Apple Crumb' 'Dutch Apple' 'Granny Smith' 'Cinnamon') label=('Type of Apple Pie');
/* Per the PROC GPLOT below, "_NAME_" is a new 
   character variable. For each observation in the 
   data set, _NAME_ contains the name of one of the 
   dependent variables in the model. */	
proc gplot data=sortage;
  plot lsmean*_name_= AGECAT / vaxis=axis1 haxis=axis2;
run;
quit;

