/* From Electoral_Bonds_Analysis.sas (lines 11-38):
   a rupee picture format, a PROC SQL roll-up that parses the comma-grouped
   Denominations text into a number and totals it per purchaser, then a
   formatted PROC PRINT of the summary. */
proc format;
  picture INR_FORMAT
    low - 999 = '999'(prefix=' ₹' mult=1)
    1000 - 9999 = '9,999'(prefix=' ₹' mult=1)
    10000 - 99999 = '99,999'(prefix=' ₹' mult=1)
    100000 - 999999 = '9,99,999'(prefix=' ₹' mult=1)
    1000000 - 9999999 = '99,99,999'(prefix=' ₹' mult=1)
    10000000 - 99999999 = '9,99,99,999'(prefix=' ₹' mult=1)
    100000000 - 1000000000 = '99,99,99,999'
    (prefix=' ₹' mult=1)
    1000000000 - 10000000000 = '999,99,99,999'
    (prefix=' ₹' mult=1)
    10000000000 - high = '9999,99,99,999'
    (prefix=' ₹' mult=1);
run;

proc sql;
   create table work.Purchaser_Summary as
   select Name_of_the_Purchaser as Purchaser_Name,
          sum(input(Denominations, comma12.)) as Total_Denominations
   from mydata
   group by Name_of_the_Purchaser
   order by Total_Denominations desc;
quit;

proc print data=Purchaser_Summary;
  format Total_Denominations INR_FORMAT.;
  title 'Purchaser Summary - Total Denominations';
run;
