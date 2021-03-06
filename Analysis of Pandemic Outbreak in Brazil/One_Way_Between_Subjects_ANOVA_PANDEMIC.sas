LIBNAME outbreak 'E:\ANOVA_Examples_of_Confounds.xls' ;
DATA work.posttemp;
Length GENDER $ 1 RESIDENCE $ 21 TXCLASS $ 23 TXTYPE $ 11 ;
SET outbreak.'PANDEMIC$'n;
ONE = .01;
LABEL 	
RESIDENCE	=		'Sao Paulo Neighborhood'
TXCLASS		=		'Anti-Viral Inhibitor class'
TXTYPE 		= 		'Anti-Viral Medication type'
FARENHEIT	=		'Temperature 48 Hrs post-Tx'
TEMPDIFF 	=		'Temp (minus 98.6f)'
;
RUN;
PROC PRINT Data= work.posttemp label;
RUN;
Proc Sort Data= work.posttemp;
by TXTYPE; 
Run;
PROC FREQ Data= work.posttemp ;
tables FARENHEIT;
by TXTYPE;
RUN;
PROC MEANS Data= work.posttemp;
var FARENHEIT;
by TXTYPE;
RUN;
PROC UNIVARIATE Data= work.posttemp;
var FARENHEIT;
by TXTYPE;
histogram / cfill=gray normal midpoints=98 to 105 by .5 kernel;
run;
ODS GRAPHICS ON;
PROC ANOVA Data=work.posttemp;
CLASS TXTYPE;
MODEL FARENHEIT = TXTYPE;
Run;
ODS GRAPHICS OFF;
ODS GRAPHICS ON;
PROC GLM Data=work.posttemp plots (only) = diagnostics (unpack) ; 
CLASS TXTYPE;
MODEL FARENHEIT = TXTYPE;
MEANS TXTYPE / hovtest; 
RUN;
Quit;
ODS GRAPHICS OFF;
ODS GRAPHICS ON;
PROC GLM Data=work.posttemp;
CLASS  TXTYPE;
MODEL FARENHEIT = TXTYPE;
MEANS TXTYPE/TUKEY CLDIFF;
OUTPUT OUT=FITDATA P=YHAT R=RESID;
PROC GPLOT;
plot resid*TXTYPE;
plot resid*yhat;
run;
ODS GRAPHICS OFF;
proc glm data= work.posttemp;
  class TXTYPE;
  model FARENHEIT = TXTYPE;
  means TXTYPE /deponly;
  contrast 'Compare 2nd & 4th grp' TXTYPE 0 1 0 -1;
  contrast 'Compare 1st & 3rd grp' TXTYPE 1 0 -1 0;
  contrast 'Compare 2nd & 4th with 1st & 3rd grp' TXTYPE 1 -1 1 -1;
  contrast 'Compare 2nd, 3rd & 4th grps with 1st grp' TXTYPE -3 1 1 1;
run;
quit;
proc sgplot DATA= work.posttemp;
  scatter x=TXTYPE y=FARENHEIT / 
    group=TXCLASS groupdisplay=cluster clusterwidth=0.5;
  xaxis type=discrete;
run;
Axis1 
	STYLE=1
	WIDTH=1
	MINOR= 
	(NUMBER=1);
Axis2
	STYLE=1
	WIDTH=1;
TITLE;
TITLE1 "Mean Temperature over 98.6f 48 hours after Anti-Viral Drug";
FOOTNOTE;

PROC GCHART DATA=WORK.posttemp ;
	VBAR TXTYPE  / SUMVAR=TEMPDIFF CLIPREF FRAME TYPE=MEAN OUTSIDE=MEAN 
	LEGEND=LEGEND1 COUTLINE=BLACK RAXIS=AXIS1 MAXIS=AXIS2 PATTERNID=MIDPOINT
	LREF=1 CREF=BLACK AUTOREF ;
RUN; 
QUIT;
TITLE; 
FOOTNOTE;
