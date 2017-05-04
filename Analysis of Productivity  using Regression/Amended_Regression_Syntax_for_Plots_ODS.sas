LIBNAME morework 'C:\Users\vvrsk\OneDrive\Fall 2016\SAS-Workshop\DailyChanges.xls';

DATA work.regreson;
SET morework.'DailyChanges$'n;
Run;

proc univariate data= work.regreson;
var confidence affiliation affinity encouraged courage health
concentration produce;
histogram / cfill=gray normal midpoints=0 to 10 by 1 kernel;
run;

proc univariate data= work.regreson;
var sleep;
histogram / cfill=gray normal midpoints=0 to 24 by 2 kernel;
run;

proc univariate data= work.regreson;
var axis5;
histogram / cfill=gray normal midpoints=0 to 100 by 5 kernel;
run;

proc univariate data= work.regreson;
where (axis5 < 0);  											* Checks if the data is blank as axis 5 is always >0;
var confidence affiliation affinity encouraged courage sleep health
concentration produce;
run;

proc univariate data= work.regreson;
where (axis5 > 0);
var confidence affiliation affinity encouraged courage sleep health
concentration produce axis5;
run;

proc reg data= Work.regreson;
where ( Axis5 > 0 );
model Axis5 = confidence affiliation affinity encouraged courage health sleep  
concentration produce / selection=forward sle=0.05; * After model its always a DEPENDENT Variable==>		 4 types;
Run;

/* Add the Quit statement or SAS thinks this procedure is still running */

Quit;
DATA work.regreson;
SET morework.'DailyChanges$'n;
axispred= (54.65 + (.438*confidence)+(.41*encouraged)+(.384*courage)+(-.227*sleep)+(.925*health)+(.817*concentration)+(1.275*produce));
axismean= 73.803;
/* 
cross validate with the results of both mean and the prediction adn impute with the value that works better.
*/
prednet= axispred - axis5;  
meannet= axismean - axis5;
pnetsqrd= prednet**2;
mnetsqrd= meannet**2;
adjpnet= sqrt(pnetsqrd);
adjmnet= sqrt(mnetsqrd);
ppctdiff= adjpnet/axis5;
mpctdiff= adjmnet/axis5;
if axis5 < 0 then axisest = axispred;
Else axisest = axis5;
Run;

Proc Univariate data=work.regreson;
where (axis5 > 0);
var ppctdiff mpctdiff;
run;

PROC REG DATA= work.regreson;
WHERE (axis5 >0);
Model axis5= axispred;
plot axis5 * axispred / pred;
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


DATA work.regreson;
SET morework.'DailyChanges$'n;
confidencez= ((confidence-5.62)/1.61);
affiliationz= ((affiliation-6.63)/1.72);
affinityz= ((affinity-6.83)/1.77);
encouragedz= ((encouraged-6.16)/1.57);
couragez= ((courage-5.42)/1.96);
sleepz= ((sleep-7.35)/2.7);
healthz= ((health-5.24)/1.13);
concentrationz= ((concentration-4.73)/1.66);
RUN;
/* This procedure produces the file "fitcorra"  */
proc corr data=work.regreson spearman cov nosimple
outp=fitcorra;
var confidencez produce;
partial affiliationz affinityz encouragedz couragez sleepz healthz concentrationz; 
title1 'Partial Correlation between Personal Confidence and Productivity';
run;

proc corr data=work.regreson spearman cov nosimple
outp=fitcorrb;
var affiliationz produce;
partial confidencez affinityz encouragedz couragez sleepz healthz concentrationz; 
title1 'Partial Correlation between Perceived Affiliation and Productivity';
run;

proc corr data=work.regreson spearman cov nosimple
outp=fitcorrc;
var affinityz produce;
partial confidencez affiliationz encouragedz couragez sleepz healthz concentrationz; 
title1 'Partial Correlation between Sense of Affinity and Productivity';
run;

proc corr data=work.regreson spearman cov nosimple
outp=fitcorrd;
var encouragedz produce;
partial confidencez affiliationz affinityz couragez sleepz healthz concentrationz; 
title1 'Partial Correlation between Feeling Encouraged and Productivity';
run;

proc corr data=work.regreson spearman cov nosimple
outp=fitcorre;
var couragez produce;
partial confidencez affiliationz affinityz encouragedz sleepz healthz concentrationz; 
title1 'Partial Correlation between Feeling Courageous and Productivity';
run;

proc corr data=work.regreson spearman cov nosimple
outp=fitcorrf;
var sleepz produce;
partial confidencez affiliationz affinityz encouragedz couragez healthz concentrationz; 
title1 'Partial Correlation between Hours of Sleep and
Productivity';
run;

proc corr data=work.regreson spearman cov nosimple
outp=fitcorrg;
var healthz produce;
partial confidencez affiliationz affinityz encouragedz couragez sleepz concentrationz; 
title1 'Partial Correlation between Physical Health and Productivity';
run;

proc corr data=work.regreson spearman cov nosimple
outp=fitcorrh;
var concentrationz produce;
partial confidencez affiliationz affinityz encouragedz couragez sleepz healthz ; 
title1 'Partial Correlation between Ability to Concentrate and Productivity';
run;

/* This procedure produces the file "_doctmp000000000000000000001.sas7bdat"  */
ODS GRAPHICS ON;  * to cater teh version commpatibility in SAS ;
Proc Reg data= work.regreson plots=(diagnostics(stats=ALL)RStudentByLeverage (label) CooksD (label)
ObservedByPredicted (label));
id idnum;
Model produce = confidencez affiliationz affinityz encouragedz couragez sleepz healthz concentrationz/selection=Forward Details=All;
Title 'Forward Multiple Regression of Predictor Variables on Productivity';
Run;
Quit;
ODS GRAPHICS OFF;


ODS GRAPHICS ON;
Proc Reg data= work.regreson plots=(diagnostics(stats=ALL)RStudentByLeverage (label) CooksD (label)
ObservedByPredicted (label));
where idnum NOT IN (62 187 236 849 1081 1128 1199 1105 );
id idnum;
Model produce = confidencez affiliationz affinityz encouragedz couragez sleepz healthz concentrationz/selection=Forward Details=All;
Title 'Forward Multiple Regression on Productivity w/Outliers Removed';
Run;
Quit;
ODS GRAPHICS OFF;

