/* 1. ONE WAY BETWEEN-SUBJECTS ANOVA - Hypothetical Starbucks Experimental-Coffee Site-Trials */

LIBNAME cofetest 'E:\ANOVA_Examples_of_Confounds.xls' ;
DATA work.starbuck;
Length SITE $ 11 COFFEE $ 20 ;
SET cofetest.'Starbucks$'n;
ONE = .0033;
LABEL 	
SITE		=		'Trial Site'
COFFEE 		 = 		'Coffee'
SCORE		 =		'Flavor (1 to 10)'
;
RUN;
PROC PRINT Data= work.starbuck label;
RUN;
Proc Sort Data= work.starbuck;
by COFFEE; 
Run;
PROC FREQ Data= work.starbuck ;
tables SCORE;
by COFFEE;
RUN;
PROC MEANS Data= work.starbuck;
var SCORE;
by COFFEE;
RUN;
PROC UNIVARIATE Data= work.starbuck;
var SCORE;
by COFFEE;
histogram / cfill=gray normal midpoints=1 to 10 by 1 kernel;
run;
/* Note that you CAN use Proc ANOVA commands, instead of Proc GLM
commands, as I am demonstrating as an example below.  However,
Proc ANOVA has less functionality and options than Proc GLM, and
also, Proc ANOVA can only be used for studying groups (aka Independent
Variables or IVs) that have equal numbers of cells filled with scores 
(aka the Dependent Variable or DV). For studying groups with unequal 
numbers of scores, you must use Proc GLM */

ODS GRAPHICS ON;
Proc ANOVA Data= work.starbuck;
CLASS COFFEE;
MODEL SCORE = COFFEE;
Run;
Quit;
ODS GRAPHICS OFF;

/* We are going to run some hi-level graphs that requires us to 
enable the ODS GRAPHICS engine */	
ODS GRAPHICS ON;
PROC GLM Data=work.starbuck plots (only) = diagnostics (unpack) ; 
CLASS COFFEE;
MODEL SCORE = COFFEE; 
MEANS COFFEE / hovtest; 
/* 

PRODUCED BY THE HOVTEST COMMAND

F-Test Model (Table)
R-Squared, Coefficient of Variance, Root of Mean Square Error, Grand Mean: SCORE (Table) 
Type I SS (Table)
Type III SS (Table)
Residuals by Predicted for SCORE (Plot)
Studentized Residuals by Predicted for SCORE (Plot)
Outlier and Leverage Diagnostics for SCORE (PLOT)
Q-Q Plot of Residuals for SCORE (PLOT)
Observed by Predicted for SCORE (PLOT)
Cook’s D for SCORE (Needle-PLOT)
Distribution of Residuals for SCORE (Histogram)
Residual-Fit Spread Plot for SCORE (2-Paneled-PLOT)
Levene's Test for Homogeneity of Variance Between Group-Distributions

*/

RUN;
Quit;
ODS GRAPHICS OFF;
ODS RTF; 
  /* You do not need to use ODS RTF. It outputs your graphs in Rich Text Format
and sends to to a temp folder, so that you can open it it Word or a Microsoft
viewer. The SAS Log File will tell you the path/location to which it sent your 
.rtf output file. Notice that we also have to enable the ODS GRAPHICS engine again. */	
ODS GRAPHICS ON;
PROC GLM Data=work.starbuck;
CLASS  COFFEE;
MODEL SCORE = COFFEE;
MEANS COFFEE/  welch TUKEY CLDIFF;
OUTPUT OUT=FITDATA P=YHAT R=RESID;
PROC GPLOT;
  /* The plot-statement informs SAS which variables to plot on the X & Y Axes */	
plot resid*COFFEE;
plot resid*yhat;
run;
ODS RTF CLOSE;
ODS GRAPHICS OFF;


/* Now it is time for Graphs.  Graphs for ANOVA 1-Way-Between are not naturally 
exciting, and making them exciting is no simle task.  I have tried to create a
few for you to play around with . . . and to IMPROVE upon!  These are unpolished. */	

PROC GCHART DATA= work.starbuck;
title 'SCORES by test-SITE, grouped by COFFEE';
VBAR SITE  / SUMVAR=SCORE GROUP=COFFEE CLIPREF FRAME	DISCRETE TYPE=MEAN 
nostats	OUTSIDE=MEAN LEGEND=LEGEND1 COUTLINE=BLACK MAXIS=AXIS1 RAXIS=AXIS2 
PATTERNID=MIDPOINT
;
RUN; 
QUIT;

proc sgplot DATA= work.starbuck;
title 'SCORES by COFFEE, grouped by SITE';
  scatter x=SCORE y=COFFEE / 
    group=SITE groupdisplay=cluster clusterwidth=0.5;
  xaxis type=discrete;
run;

/* This one graph is neither exciting nor easy to assimilate  */	

proc plot data= work.starbuck;
title 'Density-Plot - Rating SCORES by COFFEE Type';
plot SCORE*COFFEE;
Run;


/* This next graph needs to have lines between the scatter-dots, and
a lot of polishing.  Can anyone guess the reason why I created the
variable called ONE in the data step and set it at a constant value of
.0033 ?  Look below and see how I am using that variable now */	

PROC SORT DATA= work.starbuck;
BY COFFEE SCORE;
RUN;
Proc Means Data= work.starbuck SUM;
Var ONE;
By COFFEE SCORE;
output out= aggcoffe SUM= scorepct;
RUN;
proc sgplot DATA= work.aggcoffe;
by COFFEE;
scatter x=SCORE y=scorepct ;
  xaxis type=discrete;
  title 'SCORE percentages for three-COFFEE-test';
run;

/* This last graph required me to make a different Excel sheet - it can also subset by
SITE, if you use the statement at the very bottom, but you would need to change the 
data-file structure on the Excel sheet, and frankly I found it to be too complex for
easy reading.  See what you can do to improve it. . . */	


LIBNAME cofetest LIBNAME cofetest 'E:\ANOVAsas\ANOVA_Examples_of_Confounds.xls' ;
DATA work.panlplot;
SET cofetest.'StarTrns$'n;
LABEL 	
;
RUN;
proc sgscatter data=work.panlplot;
  compare y= (Argntina Kenya Sumatra )
          x= SCORE
         ;
run;
/* If you add the statement below, directly underneath the x=SCORE line above, and then
change the file-data structure, it will segment the scores by SITE with color & shapes */	
       / group=SITE;
