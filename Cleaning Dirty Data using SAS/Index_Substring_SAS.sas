LIBNAME namefind 'E:\SAS_Intermediate_Class_List.xls';
DATA work.claslist;
SET namefind.'ClassList$'n;
namespac= 	FIND(Name," "); *Capture the space using the number and populate it wiht number;
lastname= substr(Name, 1, namespac-2);
frstname= substr(Name,namespac+1);
Run;
proc print data = work.claslist;
run;
