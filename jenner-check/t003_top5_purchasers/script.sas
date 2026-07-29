/* From Electoral_Bonds_Analysis.sas (lines 27-52):
   build the per-purchaser total, sort descending, keep the top 5 with an
   obs=5 DATA step, and chart them with PROC SGPLOT. */
proc sql;
   create table work.Purchaser_Summary as
   select Name_of_the_Purchaser as Purchaser_Name,
          sum(input(Denominations, comma12.)) as Total_Denominations
   from mydata
   group by Name_of_the_Purchaser
   order by Total_Denominations desc;
quit;

proc sort data=Purchaser_Summary out=Top5Purchasers (keep=Purchaser_Name Total_Denominations);
  by descending Total_Denominations;
run;

data Top5Purchasers;
  set Top5Purchasers (obs=5);
run;

proc sgplot data=Top5Purchasers;
  title 'Top 5 Purchasers by Total Denominations';
  vbar Purchaser_Name / response=Total_Denominations datalabel;
  xaxis display=(nolabel);
  yaxis label='Total Denominations' grid;
run;
