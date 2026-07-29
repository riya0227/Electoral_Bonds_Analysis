/* From Electoral_Bonds_Analysis.sas (lines 60-71):
   count bonds per political party into an output dataset, sort by that count
   descending, and print the ranked party bond counts. */
proc freq data=reedemer;
  tables Name_of_the_Political_Party / nocum nopercent missing
  out=Party_Frequency(keep=Name_of_the_Political_Party Count) ;
run;

proc sort data=Party_Frequency;
  by descending Count;
run;

proc print data=Party_Frequency;
  title 'Party Bond Counts';
run;
