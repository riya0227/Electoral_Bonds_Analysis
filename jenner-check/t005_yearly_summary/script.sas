/* From Electoral_Bonds_Analysis.sas (lines 87-124):
   strip the grouping punctuation out of Denominations into a numeric column,
   then roll the encashed amount up by year with PROC SQL and print it with the
   rupee picture format. */
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

data reedemer;
    set reedemer;
    Denominations = compress(Denominations, '.,$');
    DenomNumeric = input(Denominations, comma12.);
run;

proc sql;
  create table Yearly_Summary as
  select year(Date_of_Encashment) as Encashment_Year format=4.,
         sum(DenomNumeric) as Total_Denominations
  from reedemer
  group by Encashment_Year
  order by Encashment_Year;
quit;

proc print data=Yearly_Summary;
  title 'Yearly Summary - Total Denominations';
  format Total_Denominations INR_FORMAT.;
run;
