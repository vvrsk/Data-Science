/*This program creates the model. */
/*change program to fit your data and model*/

libname storage 'C:\Users\vvrsk\OneDrive\Fall 2016\IDS462\Projects\Project3\Code\Data';


/*creating test and training data*/

data storage.model_ds;
set  storage.model_vars;

rand=ranuni(092765);
testdata=0;
if rand <=.7 then Resptest=.;
else if rand  >.7 then do;
	testdata=1;
    Resptest=Resp;
   	Resp=.;
end;
run;
proc print data=storage.model_ds (obs=10);
run;

/****there may be overfitting***/
/*check the model*/
proc logistic data=storage.model_ds descending;
model resp= mostyp18
moshoo2
moshoo6
MFALLE2
MOPLHO2
MSKB22
MAUT02
pwapar2
;
output out=scored_chk p=pred;
run;
quit;

proc sort data=scored_chk;
by testdata;
run;

proc rank data=scored_chk groups=100 ties=high out=scoredrank_chk;
by testdata;
var pred;
ranks mscore;
run;

proc sql;
create table tt_chk as
select ((100-mscore)/100) as rank, ((100-mscore)/100) as random, sum(resp) as resp_development, sum(resptest) as resp_test
from scoredrank_chk
group by 1,2
order by 1,2
;
quit;



/*explaining the model to your business partner*/

proc reg data=storage.model_ds;
model resp= mostyp18
moshoo2
moshoo6
MFALLE2
MOPLHO2
MSKB22
MAUT02
pwapar2;
run;
quit;

/*save the model for execution*/

proc logistic data=storage.model_ds descending
			outmodel=storage.log_resp_model;
model resp= PWAPAR2 MINKGE2 MAUT02 MGODPR2 MOSHOO10;
run;
quit;



