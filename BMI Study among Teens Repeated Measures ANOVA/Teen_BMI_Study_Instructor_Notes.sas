	
LIBNAME TrackBMI 'C:\Users\vvrsk\OneDrive\Fall 2016\SAS-Workshop\Repeated Measures\Longitudinal_Teen_BMI_Study.xls' ;
DATA work.TeenBMI;
LENGTH KidName1 $ 10;
SET TrackBMI.'TeenBMIData$'n;

/* 
When running a Repeated Measure ANOVA, you have 
to create new variables that represent the DVs 
that are the Repeated Measures.  They have to 
have the same convention, as per below.  On the 
left of the equals-sign are the variables that 
will be used in the Repeated Analyses, and on 
the right of the equals sign are the true 
variables names. Notice that the variables for 
the Repeated Analyses have to end with sequential 
numbers, starting with # 1.
*/

Yr1 = Age12BMI;
Yr2 = Age14BMI;
Yr3 = Age16BMI;

/* 
Below, you will see that new variables are 
being created. Can you determine what these 
new variables represent? 

What do these equations produce?
*/

BMI1214 = (Age14BMI / Age12BMI) -1;
BMI1216 = (Age16BMI / Age12BMI) -1;
BMI1416 = (Age16BMI / Age14BMI) -1;

LABEL
RowNum	= 'ID'
KidName1 = 'Student First Name'
KidGender = 'Student Gender'
KidVolActLev = 'Student Elective Phys. Act. Level'
KidDiet = 'Student Nutrition'
ParWeightM = 'Father Observed Weight'
ParWeightF = 'Mother Observed Weight'
ParVolActLevM = 'Father Elective Phys. Act. Level'
ParVolActLevF = 'Mother Elective Phys. Act. Level'
ParSmokeM = 'Father Smokes'
ParSmokeF = 'Mother Smokes'
Age12BMI = 'BMI at 12'
Age14BMI = 'BMI at 14'
Age16BMI = 'BMI at 16'
BMI12Cat = 'BMI Category at Age 12'
BMI14Cat = 'BMI Category at Age 14'
BMI16Cat = 'BMI Category at Age 16'
MrYoung  = 'Propensity Score Matches'
;
RUN;
PROC FORMAT;
  VALUE KidGender
1= 'Male'
2= 'Female' 
;
RUN;
PROC FORMAT;
  VALUE KidVolActLev
1= 'Zero Elective Exercise' 
2= 'Little/Some Elective Exercise'
3= 'Substantial Elective Exercise'
;
RUN;
PROC FORMAT;
  VALUE KidDiet
1= 'Unhealthy' 
2= 'Somewhat Unhealthy'
3= 'Somewhat Healthy'
4= 'Healthy'
;
RUN;
PROC FORMAT;
  VALUE ParWeightM
1= 'Thin or Athletic' 
2= 'Normal'
3= 'Visibly Overweight'
;
RUN;
PROC FORMAT;
  VALUE ParWeightF
1= 'Thin or Athletic' 
2= 'Normal'
3= 'Visibly Overweight'
;
RUN;
PROC FORMAT;
  VALUE ParVolActLevM
1= 'Zero Elective Exercise' 
2= 'Little/Some Elective Exercise'
3= 'Substantial Elective Exercise'
;
RUN;
PROC FORMAT;
  VALUE ParVolActLevF
1= 'Zero Elective Exercise' 
2= 'Little/Some Elective Exercise'
3= 'Substantial Elective Exercise'
;
RUN;
PROC FORMAT;
  VALUE ParSmokeM
0= 'Father is Nonsmoker'
1= 'Father Smokes' 
;
RUN;
PROC FORMAT;
  VALUE ParSmokeF
0= 'Mother is Nonsmoker'
1= 'Mother Smokes' 
;
RUN;
PROC FORMAT;
  VALUE BMI12Cat
1= 'Underweight' 
2= 'Normal Weight'
3= 'Overweight'
4= 'Obese'
;
RUN;
PROC FORMAT;
  VALUE BMI14Cat
1= 'Underweight' 
2= 'Normal Weight'
3= 'Overweight'
4= 'Obese'
;
RUN;
PROC FORMAT;
  VALUE BMI16Cat
1= 'Underweight' 
2= 'Normal Weight'
3= 'Overweight'
4= 'Obese'
;
RUN;

/* 
Per below, in the WHERE Statement, the �SaiVar� 
variable is a dichotomous field that flags Boy 
and Girl student-subject who�s scores on the IVs 
have been propensity-matched. The other portion 
of the WHERE Statement is �KidGender,� therefore 
this Statement limits the PROCs to analysis of 
Boys who had been propensity-matched. Girls have 
a KidGender code of �2.�
*/


PROC FREQ Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 1;
tables ParSmokeM ParSmokeF;
RUN;
PROC MEANS Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 1;
var KidVolActLev ParWeightM ParWeightF 
    ParVolActLevM ParVolActLevF BMI12Cat 
    BMI14Cat BMI16Cat;
RUN;
PROC UNIVARIATE Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 1;
var KidDiet;
histogram / cfill=gray normal midpoints=1 to 4 by 1 kernel;
run;
PROC UNIVARIATE Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 1;
var Age12BMI Age14BMI Age16BMI;
histogram / cfill=gray normal midpoints=12 to 39 by 3 kernel;
run;
PROC UNIVARIATE Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 1;
VAR BMI1216;
/* 
Note: per below, if you do not specify 
midpoints and kernels in a PROC UNIVARIATE 
histogram then SAS will do it for you as 
best as it can
*/
histogram / cfill=gray normal ;
RUN;

/* 
Below, you see that there are two PROC CORR 
procedures being run to identify degree of 
correlation between �the proportion of the 
weight change that occurred in propensity-
matched Boys between Age 12 and Age 16,� and, 
�the weight category of the propensity-matched 
Boys at Age 12.�  These PROC CORR procedures 
are subsequently duplicated for propensity-
matched Girls.  How might running these PROC 
CORR procedures yield information that could 
be useful to you as an Analyst?  
*/

PROC CORR Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 1;
VAR BMI1216 BMI12Cat;
title1 'Bivariate Corr: Age 12 Boys BMI-Category';
title2 'with Age 16 Proportions of Weight Change';
RUN;
proc corr data=work.TeenBMI spearman nosimple
          outp=fitboy;
where SaiVar = 1 and KidGender = 1;
     var   BMI1216 BMI12Cat;
      partial KidVolActLev ParWeightM ParWeightF 
              ParVolActLevM ParVolActLevF ParSmokeM 
              ParSmokeF;  
     title1 'Partial-Corr: Age 12 Boys BMI-Category';
	 title2 'with Age 16 Proportions of Weight Change';
	 title3 'Controlling for all Predictor Variables';
run;
title;
/* 
The PROC REG Procedure below should look 
familiar to those who took Mr. Young�s 
Linear or Logistic Regression classes. 
Data-diagnostic plots are being run. Also 
being run is a Linear Regression (method=
forward) that is evaluating all of the 
predictor-variables for propensity-matched 
Boys on the main target-variable of �Student 
BMI at Age 16.�  Lastly, the procedure is 
outputting a temp-file called �estboy� The 
temp file will contain variables of the 
regression-model�s Predicted-scores, error-
differences between the model�s predicted 
scores and the actual Boys BMI scores at 
Age 16, and the standard-deviation of the 
error-differences. Can you determine the 
purpose of running this procedure for 
propensity-matched Boys (and subsequently 
for propensity-matched Girls)? 
*/

ODS GRAPHICS ON; 
Proc Reg data= work.TeenBMI plots=(diagnostics
(stats=ALL)RStudentByLeverage (label) CooksD (label)
ObservedByPredicted (label));
where SaiVar = 1 and KidGender = 1;
id RowNum;
Model Age16BMI = KidVolActLev KidDiet ParWeightM 
ParWeightF ParVolActLevM ParVolActLevF ParSmokeM 
ParSmokeF
/
selection=Backward sle=0.05 Details=All /* Backward Reg enters an extra variable */
;
OUTPUT OUT=estboy P=PRED R=Resid STUDENT=residdev ;
Title 'Forward Regression of Boys Age-12 Predictors on Age-16 BMI';
Run;
Quit;
ODS GRAPHICS OFF;
TITLE;
/* 
Immediately after running the PROC REG 
procedure, the temp-file it created is 
accessed and there is a WHERE statement 
which limits the PROC PRINT output to 
those propensity-matched Boys who�s Age- 
16 BMI scores the Regression model had 
mispredicted by more than two standard 
deviations above or below the misprediction-
mean. The same PROC PRINT will subsequently 
be run for propensity-matched Girls.  What 
is the reason for running this procedure?  
*/

PROC PRINT DATA=estboy;
WHERE residdev >= 2 or residdev <= -2;
VAR RowNum 
    KidName1 
    KidVolActLev 
    KidDiet 
    ParWeightM 
    ParWeightF 
    ParVolActLevM 
    ParVolActLevF 
    ParSmokeM 
    ParSmokeF 
    Age12BMI 
    Age14BMI 
    Age16BMI 
    BMI1214 
    BMI1416 
    BMI1216 ;
RUN;


PROC FREQ Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 2;
tables ParSmokeM ParSmokeF;
RUN;
PROC MEANS Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 2;
var KidVolActLev ParWeightM ParWeightF ParVolActLevM
ParVolActLevF BMI12Cat BMI14Cat BMI16Cat;
RUN;
PROC UNIVARIATE Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 2;
var KidDiet;
histogram / cfill=gray normal midpoints=1 to 4 by 1 kernel;
run;
PROC UNIVARIATE Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 2;
var Age12BMI Age14BMI Age16BMI;
histogram / cfill=gray normal midpoints=12 to 39 by 3 kernel;
run;
PROC UNIVARIATE Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 2;
VAR BMI1216;
histogram / cfill=gray normal ;
RUN;
PROC CORR Data= work.TeenBMI;
where SaiVar = 1 and KidGender = 2;
VAR BMI1216 BMI12Cat;
title1 'Bivariate Corr: Age 12 Girls BMI-Category';
title2 'with Age 16 Proportions of Weight Change';
RUN;
title;
proc corr data=work.TeenBMI spearman nosimple
          outp=fitgirl;
where SaiVar = 1 and KidGender = 2;
     var   BMI1216 BMI12Cat;
      partial KidVolActLev ParWeightM ParWeightF 
              ParVolActLevM ParVolActLevF ParSmokeM 
              ParSmokeF
              ;  
     title1 'Partial-Corr: Age 12 Girls BMI-Category';
	 title2 'with Age 16 Proportions of Weight Change';
	 title3 'Controlling for all Predictor Variables';
run;
title;
proc sort data=work.TeenBMI;
 by RowNum;
run;
ODS GRAPHICS ON;
Proc Reg data= work.TeenBMI plots=(diagnostics(stats=ALL)
RStudentByLeverage (label) CooksD (label)
ObservedByPredicted (label));
where SaiVar = 1 and KidGender = 2;
id RowNum;
Model Age16BMI = KidVolActLev KidDiet ParWeightM
ParWeightF ParVolActLevM ParVolActLevF ParSmokeM 
ParSmokeF 
/
selection=Forward sle=0.05 Details=All /* Tried running Backward Reg, nothing changed */
;
OUTPUT OUT=estgirl P=PRED R=Resid STUDENT=residdev ;
Title 'Forward Regression of Girls Age-12 Predictors on Age-16 BMI';
Run;
Quit;
ODS GRAPHICS OFF;
TITLE;

PROC PRINT DATA=estgirl;
WHERE residdev >= 2 or residdev <= -2;
VAR RowNum 
    KidName1 
    KidVolActLev 
    KidDiet 
    ParWeightM 
    ParWeightF 
    ParVolActLevM 
    ParVolActLevF 
    ParSmokeM 
    ParSmokeF 
    Age12BMI 
    Age14BMI 
    Age16BMI 
    BMI1214 
    BMI1416 
    BMI1216 ;
RUN;

/* 
The Repeated-Measures ANOVA! We will 
be working with the data for the 
propensity-matched Girls.  You can later 
slightly change the TITLE statements 
below to say �Boys� instead of �Girls,� 
and also change the KidGender value in 
the WHERE Statement from a �2� to a �1,� 
so that you can run this Repeated-Measures 
ANOVA for the propensity-matched Boys.  

Then, in a third effort, you can remove 
"KidGender" variable from the WHERE 
Statement and also remove the word �Boys� 
from the TITLE Statements so that you can 
run a Repeated-Measures ANOVA that 
utilizes all of the propensity-matched 
students.  

Finally, you can remove the WHERE Statement 
and run the Repeated-Measures ANOVA on the 
entire 460 student-subjects in the study.
*/

/*  
NOTE: In the PROC GLM Statement, immediately 
after �work.TeenBMI,� you can specify the 
Option �MANOVA,� which will filter out of 
the Repeated-Measures ANOVA procedure any 
student records that contain any missing-
values in any of the Dependent Variables.  
Because Repeated-ANOVA is completely 
intolerant of missing-values, if you know 
(or think) that your dataset might have any 
missing values, you might wish to place the 
MANOVA option in the PROC GLM Statement. 
*/



Proc GLM data= work.TeenBMI MANOVA;
where SaiVar = 1 and KidGender = 2;
;

/* 
The CLASS Statement is to inform SAS about 
which variables are "Factor" variables.  Below,
Teen-Elective-Activity-Level and Teen-Diet are 
the two variables that our Linear Regression
procedure retained to build the predictive 
model for propensity-matched Boys and Girls.
Therefore, we are including those two Factors,
(Aka �predictor-variables�) in this R-ANOVA.
*/

CLASS KidVolActLev KidDiet;

/* 
The MODEL Statement names the dependent 
variables and independent effects.  If no 
independent effects are specified, only an 
intercept term is fit. Below, we ask SAS to 
show us the effects of the Teen-Activity
factor and the Teen-Diet factor, and the 
interaction-effect of TeenActivity and Teen-
Diet.

Many types of options can be added to the 
MODEL Statement after the forward-slash.  
Below are 3 of the many options: "SOLUTION," 
"p," and NOUNI. 

"SOLUTION" produces parameter-estimates;
and, "p" displays observed, predicted, and 
residual values. "NOUNI" suppresses display 
of endless pages of univariate output.  
*/

/*PROBLEM obtaining a Prediction-formula. Do I 
have to use Mixed Models to obtain Parameter-
Estimates (aka �Yhat=A+B[x]�)??? */

MODEL Yr1 Yr2 Yr3 = KidVolActLev KidDiet KidVolActLev*KidDiet 
/ 
SOLUTION p NOUNI
;

/* 
The MEANS Statement computes the arithmetic 
means and standard deviations of all continuous 
variables in the model (both dependent and 
independent variables). 

Below, in the MEANS Statements, we are asking 
SAS for the Age-16 BMI means of students� 
proclivities at Age 12 (e.g. their �Elective 
Physical Activity Level,� �Dietary Intake,� and 
the interaction between Activity and Diet.)
Then, after the forward-slash, we list a few of 
the many possible options that can be included 
in a MEANS Statement.

TUKEY: If the Sphericity Assumption is met, and 
if the F-Test is significant (aka "the group-means 
are not all equal") then the TUKEY option will be 
adequate to perform the post-hoc ANOVA tests that 
determine exactly which group-means are 
significantly different from other group-means.  

BON: Performs Bonferroni t-tests of differences. 
BON is one of several possible alternative post-hoc 
ANOVA tests that you can use instead of the TUKEY 
when the Sphericity Assumption is NOT met. 

LINES: Lists the means in descending order and 
indicating nonsignificant subsets by line segments.

KRATIO=: is an Option which allows you to select 
the level of significance which constitutes your 
critical threshold for Type-1 and Type-2 error-
seriousness. KRATIO=100 is the equivalent of p.<.05 
and KRATIO=500 is the equivalent of p.<.01. 

The WALLER Option actually performs the KRATIO test 
itself.

HTYPE=n Option specifies the MS type for the 
hypothesis MS. The HTYPE= option is needed only when 
the WALLER option is specified. The default HTYPE= 
value is the highest type used in the model. 

DUNCAN Option performs Duncan�s multiple range test 
on all main-effect means given in the MEANS statement. 
See the LINES option for a discussion of how the 
procedure displays results. 

The CLDIFF option requests confidence intervals for 
both the Tukey and the Least Significant Difference 
("LSD") tests. 

The LSD option performs pairwise t tests, equivalent 
to Fisher�s least significant difference test in the 
case of equal cell sizes, for all ((main-effect means)) 
in the MEANS statement. 
*/

MEANS KidVolActLev KidDiet KidVolActLev*KidDiet 
/ 
TUKEY BON LINES WALLER KRATIO=100 DUNCAN LSD CLDIFF HTYPE= 
;

/* 
TUKEY PROBLEM - ERROR 22-322: Syntax error, expecting one of the following: a numeric constant, a datetime constant.
 */


/* 
The REPEATED Statement enables you to test 
hypotheses about the measurement factors 
(often called within-subject factors) as well 
as the interactions of within-subject factors 
with independent variables in the MODEL 
statement (often called between-subject 
factors). The REPEATED statement provides 
multivariate and univariate tests as well 
as hypothesis tests for a variety of single-
degree-of-freedom contrasts.

The simplest form of the REPEATED statement 
requires only a factor-name. With two 
repeated factors, you must specify in 
the CLASS Statement the factor-name and 
number of levels (levels) for each factor. 
Optionally, you can specify the actual 
values for the levels (level-values), a 
transformation that defines single-degree-
of-freedom contrasts, and options for 
additional analyses and output. When you 
specify more than one within-subject factor, 
such as for crossover-rANOVA, the factor-
names (and associated level and transformation 
information) must be separated by a comma 
in the REPEATED statement. 

THE REPEATED Statement has several options 
that occur before the forward slash, and 
several options that occur after the
forward slash.

We want to do a repeated measures analysis 
of variance. Here, "Yr" is the independent 
variable (often called a �between subjects 
factor� in repeated measures) and the 3 
dependent variables are Yr1, Yr2, and Yr3. 
To inform SAS that a repeated measures 
analysis should be performed, it is 
necessary to give a REPEATED statement. 

Let us parse the REPEATED statement. Here, the 
repeated measures factor is called �Yr� and it 
has 3 levels. The actual name for the repeated 
measures factor is arbitrary, could just as 
well have been called �Year.� The PROFILE Option 
generates contrasts between adjacent levels of 
the "Yr" factor. 

Three Options are listed after the forward slash. 
It is recommended that you always use two of 
these options when performing a repeated measures 
analysis with SAS. The first Option (PRINTE)
requests that several matrices be printed along 
with tests so check whether the assumptions of 
the repeated measures analysis are met (e.g., 
Sphericity). PRINTE Option displays the  E-matrix 
for each combination of within-subject factors, as 
well as partial correlation matrices for both the 
original dependent variables and the variables 
defined by the transformations specified in the 
REPEATED statement. In addition, the PRINTE option 
provides sphericity tests for each set of 
transformed variables. If the requested 
transformations are not orthogonal, the PRINTE 
option also provides a sphericity test for a set of 
orthogonal contrasts. 

The SUMMARY Option produces analysis-of-variance 
tables for each contrast defined by the within-
subject factors. Along with tests for the effects 
of the independent variables specified in the 
MODEL statement, a term labeled MEAN tests the 
hypothesis that the overall mean of the contrast 
is zero. */

/* The MEAN generates the overall arithmetic means of 
the within-subject variables.  */


REPEATED Yr 3 PROFILE 
/ 
PRINTE SUMMARY MEAN
;

/* 
With the LSMEANS Statement, least-
squares means (LS-means) are computed 
for each effect listed in the LSMEANS 
Statement. LS-means are predicted 
population margins; that is, they 
estimate the marginal means over a 
balanced population. 

There are many possible Options you 
can list in the LSMEANS Statement ... 
after the forward-slash.  

OUT= Option creates an output data 
set that contains the values, standard 
errors, and, optionally, the covariances.
In this case we are asking SAS to output 
a file with the Least-Squares Means for
KidVolActLev, KidDiet and the interaction
(aka permutations) between the two.  

STDERR Option is for the Standard Error 
of the LSMEANS.

COV Option is for the Covariance, but it 
can ONLY be used if there is ONLY one 
variable in the LSMEANS Statement.
*/

LSMEANS KidVolActLev*KidDiet 
/ 
OUT=MEANS   
;

/* 

The MANOVA Statement. If the MODEL statement 
includes more than one dependent variable, 
you can perform multivariate analysis of 
variance with the MANOVA statement. The test-
options define which effects to test, while 
the detail-options specify how to execute the 
tests and what results to display. 

The MANOVA Statement Options.  

H= Specifies hypothesis effects. Specifies 
   effects in the preceding model to use as 
   hypothesis matrices. By default, these 
   statistics are tested with approximations 
   based on the F distribution. Use the 
   keyword INTERCEPT to produce tests for the 
   intercept. To produce tests for all effects 
   listed in the MODEL statement, use the keyword 
   _ALL_ in place of a list of effects.

M= Specifies a transformation matrix for the 
   dependent variables. Equations should involve 
   two or more dependent variables. Alternatively, 
   you can input the transformation matrix 
   directly by entering the elements of the matrix 
   with commas separating the rows and parentheses 
   surrounding the matrix. When this alternate 
   form of input is used, the number of elements 
   in each row must equal the number of dependent 
   variables. 
   Although these combinations actually 
   represent the columns of the  matrix, they are 
   displayed by rows. When you include an M= 
   specification, the analysis requested in the 
   MANOVA statement is carried out for the variables 
   defined by the equations in the specification, 
   not the original dependent variables. If you 
   omit the M= option, the analysis is performed for 
   the original dependent variables in the MODEL 
   statement. 
   If an M= specification is included without either 
   the MNAMES= or PREFIX= option, the variables are 
   labeled MVAR1, MVAR2, and so forth, by default. 

E= Specifies the error effect. IF YOU OMIT the 
   E= specification, the GLM procedure uses the 
   error SSCP (residual) matrix from the 
   analysis. 

SUMMARY Option produces analysis-of-variance 
   tables for each dependent variable. When no 
   M-matrix is specified, a table is displayed for 
   each original dependent variable from the 
   MODEL statement; with an M-matrix other than the 
   identity, a table is displayed for each 
   transformed variable defined by the M-matrix. 

PRINTE Option displays the error SSCP matrix-E. If 
   the E-matrix is the error SSCP (residual) matrix 
   from the analysis, the partial correlations of 
   the dependent variables given the independent 
   variables are also produced.

MSTAT= (EXACT or FAPPROX)specifies the method of 
   evaluating the multivariate test statistics. 
   The default is MSTAT=FAPPROX, which specifies that 
   the multivariate tests are evaluated using the 
   usual approximations based on the F distribution.

   Alternatively, you can specify MSTAT=EXACT to 
   compute exact p-values for three of the four tests 
   (Wilks� lambda, the Hotelling-Lawley trace, and 
   Roy�s greatest root) and an improved F approximation 
   for the fourth (Pillai�s trace). While MSTAT=EXACT 
   provides better control of the significance 
   probability for the tests, especially for Roy�s 
   greatest root, computations for the exact p-values 
   can be appreciably more demanding, and are in fact 
   infeasible for large problems (many dependent variables). 
   Thus, although MSTAT=EXACT is more accurate for most 
   data, it is not the default method. 



*/


MANOVA  H=intercept  M=Yr1 - Yr2,
                       Yr1 - Yr3,
                       Yr2 - Yr3	
PREFIX=DIFF / 
MSTAT=EXACT SUMMARY PRINTE
;

/* 
The OUTPUT statement creates a new SAS 
data set that saves diagnostic measures 
calculated after fitting the model. All 
the variables in the original data set 
are included in the new data set, along 
with variables created in the OUTPUT 
statement. 
*/

OUTPUT OUT=outfile p=y1hat y2hat y3hat r=y1resid y2resid y3resid;
Title1 'Repeated-ANOVA on Girls Who Matched with Boys on IVs';
Title2 'w/Factor of 3 Levels of Elective Physical Activity';
Title3 'w/Factor of 4 Levels of Healthiness of Diet';
Title4 'w/Factor of Interaction of Diet*Activity';
Run;
quit;
title;

PROC EXPORT DATA= WORK.outfile
            OUTFILE= "F:\SASrANOVA\Longitudinal_Adolescent_BMI_Study.xls" 
            DBMS=EXCEL REPLACE;
     SHEET="BoyMatchPred"; 
RUN;

proc sort data=work.outfile;
 by RowNum;
run;
PROC PRINT DATA=outfile;
WHERE SaiVar = 1;
VAR RowNum y1hat y2hat y3hat y1resid y2resid y3resid 
     ;
RUN;

/* 
Now it is time for Graphs.  I have tried 
to create a few for you to play around with,
and to IMPROVE upon!  These are unpolished. 

*/	

proc sort data=work.outfile out=sortdiet;
 by RowNum;
run;

PROC REG DATA= work.outfile;
Model Yr3= y3hat;
plot Yr3 * y3hat / pred;
Run;
quit;





proc univariate data= work.outfile plot normal;
   var y1resid y2resid y3resid;
Run;
proc gplot;
   plot resid*KidVolActLev;
   plot resid*KidDiet;
   plot resid*yhat;
run;
Quit;
ODS GRAPHICS OFF;



proc print data=work.means;
run;
proc sort data=means out=sortdiet;
 by KidDiet;
run;
goptions reset=all;
symbol1 c=blue v=star h=.9 i=j;
symbol2 c=red v=dot h=1.1 i=j;
symbol3 c=green v=diamond h=1 i=j;
symbol4 c=orange v=triangle h=1 i=j;
axis1 order=(10 to 40 by 5) label=(a=3 'Means of BMI');
axis2 value=('Age12' 'Age14' 'Age16') label=('Age of BMI-Measure');
proc gplot data=sortdiet;
  plot lsmean*_name_= KidDiet / vaxis=axis1 haxis=axis2;
run;
quit;
proc sort data=means out=sortkact;
 by KidVolActLev;
run;
goptions reset=all;
symbol1 c=blue v=star h=.8 i=j;
symbol2 c=red v=dot h=.8 i=j;
symbol3 c=green v=diamond h=.8 i=j;
axis1 order=(10 to 40 by 5) label=(a=3 'Means of BMI');
axis2 value=('Age12' 'Age14' 'Age16') label=('Age of BMI-Measure');
proc gplot data=sortkact;
  plot lsmean*_name_= KidVolActLev / vaxis=axis1 haxis=axis2;
run;
quit;
proc sort data=means out=sortiact;
 by KidVolActLev;
run;
goptions reset=all;
symbol1 c=blue v=star h=.9 i=j;
symbol2 c=red v=dot h=1.1 i=j;
symbol3 c=green v=diamond h=1 i=j;
axis1 order=(10 to 40 by 5) 
label=(a=90 'Means of BMI');
axis2 value=('Age12' 'Age14' 'Age16') 
label=('Age of BMI');
proc gplot data=sortage;
  plot lsmean*_name_= KidVolActLev / vaxis=axis1 haxis=axis2;
run;
quit;

/* THIS GRAPH FAILED.  IT HAS NO FILL. THE SORTIVS TEMP FILE LOOKS OK, SO CODING IS WRONG */

proc sort data=means out=sortivs;
 by KidDiet ;
run;
PROC GCHART DATA= work.sortivs;
Where _NAME_ = 'Yr3';
title 'BMI at Age 16 of Propensity-Matched Girls';
TITLE2 'by the Quality of thier Diets at Age 12';
TITLE3 'Grouped by their Level of Elective Exercise at Age12';
VBAR KidDiet  / SUMVAR=LSMEAN GROUP=KidVolActLev CLIPREF FRAME	DISCRETE TYPE=MEAN 
nostats	OUTSIDE=MEAN LEGEND=LEGEND1 COUTLINE=BLACK MAXIS=AXIS1 RAXIS=AXIS2 
PATTERNID=MIDPOINT
;
RUN; 
QUIT;

proc sgplot DATA= work.sortivs;
Where KidVolActLev =1;
title 'LSMEANS by KidDiet, grouped by BMI-Age, Where ActLev = 1';
  scatter x=_NAME_ y=LSMEAN / 
    group=KidDiet groupdisplay=cluster clusterwidth=0.5;
  xaxis type=discrete;
run;

proc sgscatter data=work.sortivs;
Where KidVolActLev=1;
  compare y= (LSMEAN)
          x= _NAME_
          / group=KidDiet;
TITLE 'LSMEANS of Propensity-Matched Girls';
TITLE2 'by Quality of their Diets at Age 12'; 
TITLE3 'grouped by Age when BMIs were Measured';
TITLE4 'Where Voluntary-Exercise Level at Age 12 Was NEGLIGIBLE';
run;
proc sgscatter data=work.sortivs;
Where KidVolActLev=2;
  compare y= (LSMEAN)
          x= _NAME_
          / group=KidDiet;
TITLE 'LSMEANS of Propensity-Matched Girls';
TITLE2 'by Quality of their Diets at Age 12'; 
TITLE3 'grouped by Age when BMIs were Measured';
TITLE4 'Where Voluntary-Exercise Level at Age 12 Was MODEST';
run;
proc sgscatter data=work.sortivs;
Where KidVolActLev=3;
  compare y= (LSMEAN)
          x= _NAME_
          / group=KidDiet;
TITLE 'LSMEANS of Propensity-Matched Girls';
TITLE2 'by Quality of their Diets at Age 12'; 
TITLE3 'grouped by Age when BMIs were Measured';
TITLE4 'Where Voluntary-Exercise Level at Age 12 Was SUBSTANTIAL';
run;

proc sort data=means out=sortivs;
 by KidVolActLev ;
run;
proc sgscatter data=work.sortivs;
Where KidDiet=1;
  compare y= (LSMEAN)
          x= _NAME_
          / group=KidVolActLev;
TITLE 'LSMEANS of Propensity-Matched Girls';
TITLE2 'by Voluntary-Exercise Level at Age 12'; 
TITLE3 'grouped by Age when BMIs were Measured';
TITLE4 'Where Quality of Diet at Age 12 Was VERY-UNHEALTHY';
run;
proc sgscatter data=work.sortivs;
Where KidDiet=2;
  compare y= (LSMEAN)
          x= _NAME_
          / group=KidVolActLev;
TITLE 'LSMEANS of Propensity-Matched Girls';
TITLE2 'by Voluntary-Exercise Level at Age 12'; 
TITLE3 'grouped by Age when BMIs were Measured';
TITLE4 'Where Quality of Diet at Age 12 Was SOMEWHAT-UNHEALTHY';
run;
proc sgscatter data=work.sortivs;
Where KidDiet=3;
  compare y= (LSMEAN)
          x= _NAME_
          / group=KidVolActLev;
TITLE 'LSMEANS of Propensity-Matched Girls';
TITLE2 'by Voluntary-Exercise Level at Age 12'; 
TITLE3 'grouped by Age their BMIs were Measured';
TITLE4 'Where Quality of Diet at Age 12 Was SOMEWHAT-HEALTHY';
run;
proc sgscatter data=work.sortivs;
Where KidDiet=4;
  compare y= (LSMEAN)
          x= _NAME_
          / group=KidVolActLev;
TITLE 'LSMEANS of Propensity-Matched Girls';
TITLE2 'by Voluntary-Exercise Level at Age 12'; 
TITLE3 'grouped by Age their BMIs were Measured';
TITLE4 'Where Quality of Diet at Age 12 Was VERY-HEALTHY';
run;
/* THESE 2 GRAPHS FAILED.  THEY HAVE NO FILL. THE Outfile TEMP FILE LOOKS OK, SO CODING IS WRONG */

PROC GCHART DATA= work.outfile;
Where BMI12CAT <= 2;
title 'Propensity-Matched Girls BMI Changes Between Age 12 and 16';
TITLE2 'by the Quality of thier Diets at Age 12';
TITLE3 'Grouped by their Level of Elective Exercise at Age12';
TITLE4 'Where Age-12 BMI Category was NORMAL or UNDERWEIGHT';
VBAR KidDiet  / SUMVAR=BMI1216 GROUP=KidVolActLev CLIPREF FRAME	DISCRETE TYPE=MEAN 
nostats	OUTSIDE=MEAN LEGEND=LEGEND1 COUTLINE=BLACK MAXIS=AXIS1 RAXIS=AXIS2 
PATTERNID=MIDPOINT
;
RUN; 
QUIT;
PROC GCHART DATA= work.outfile;
Where BMI12CAT >= 3;
title 'Propensity-Matched Girls BMI Changes Between Age 12 and 16';
TITLE2 'by the Quality of thier Diets at Age 12';
TITLE3 'Grouped by their Level of Elective Exercise at Age12';
TITLE4 'Where Age-12 BMI Category was OVERWEIGHT or OBESE';
VBAR KidDiet  / SUMVAR=BMI1216 GROUP=KidVolActLev CLIPREF FRAME	DISCRETE TYPE=MEAN 
nostats	OUTSIDE=MEAN LEGEND=LEGEND1 COUTLINE=BLACK MAXIS=AXIS1 RAXIS=AXIS2 
PATTERNID=MIDPOINT
;
RUN; 
QUIT;





PROC REG DATA= work.outfile;
Model Yr3= y3hat;
plot Yr3 * y3hat / pred;
Run;
quit;

Proc Corr data= work.regreson;
var confidence affiliation affinity encouraged courage sleep health concentration produce axisest;
Title 'Bivariate Correlation Matrix';
Run;

PROC REG DATA= work.regreson;
Model produce= confidence; /* substitute variable "concentration" for confidence */
Plot produce * confidence; /* substitute variable "concentration" for confidence */
ID idnum; 
Run;
/* Add Quit statement or SAS thinks this procedure is still running */
/* This procedure produces the file "_doctmp000000000000000000000.sas7bdat"  */
Quit;

PROC REG DATA= work.LogRegDx;
Where (Mortality = 0 & LOS < 100); 
Model LOS= LOSpred;
plot LOS * LOSpred / pred;
Run;
quit;
