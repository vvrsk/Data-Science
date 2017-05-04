DATA work.aggrgate;
Length netid $ 8;
INFILE 'E:\PharosDat.csv' DLM = ',' MISSOVER DSD FIRSTOBS=2; 
Informat cost DOLLAR12.2;
Format cost DOLLAR12.2;
INPUT netid $ cost pages sheets;
RUN;
/*Sory=t by the break variable */
PROC SORT DATA= work.aggrgate;
BY netid;
RUN;
Proc Means Data= work.aggrgate SUM;
Var cost pages sheets;
By netid;
output out= aggprint SUM=costagr pagesagr sheetsag;
RUN:
proc print data= aggprint;
where costagr > 15;
run;
