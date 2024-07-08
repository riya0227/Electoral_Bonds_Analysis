proc import datafile='/home/u63714413/Riya/Purchaser_Comp_All_Cols.xlsx'
            out=mydata
            dbms=xlsx
            replace;
run;

proc freq data=mydata;
    tables Name_of_the_Purchaser/ nocum nopercent missing;
run;

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

proc sort data=Purchaser_Summary out=Top5Purchasers (keep=Purchaser_Name Total_Denominations);
  by  descending Total_Denominations;
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

proc import datafile='/home/u63714413/Riya/Reedemer_Party_All_Cols.xlsx'
        	out=reedemer
        	dbms=xlsx
        	replace;
run;

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

PROC SQL;
  CREATE TABLE Top5Parties AS
    SELECT Name_of_the_Political_Party,
           Count
    FROM Party_Frequency(OBS=5)
    ORDER BY Count DESC;
QUIT;

proc sgplot data=Top5Parties;
   vbar Name_of_the_Political_Party / response=Count
                                      datalabel;
   title 'Top 5 Parties with Highest Bond Counts';
run;

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

proc sgplot data=Yearly_Summary;
  title 'Yearly Summary - Total Denominations';
  vbar Encashment_Year / response=Total_Denominations;
  xaxis label='Year' valuesformat=YEAR4.;
  yaxis label='Total Denominations';
run;

proc print data=WORK.WorkingCOMBINE noobs;
var Date_of_Purchase Issue_Branch_Code Name_of_the_Purchaser 
Name_of_the_Political_Party DenomNumeric ;
format Date_of_Purchase ddmmyy. DenomNumeric indian_currency. ;
id BondNumber;
title "Join Of Bond Purchasing Companies and Bond Redeeming Parties";
run;

PROC SORT DATA=WORK.WorkingCOMBINE OUT=sorted_bonds;
 BY Year DenomNumeric DESCENDING Name_of_the_Purchaser;
RUN;
PROC SQL OUTOBS=MAX;
 CREATE TABLE top_companies AS
 SELECT 
 Year,
 Name_of_the_Purchaser,
 Name_of_the_Political_Party,
 SUM(DenomNumeric) AS Total_Denomination
 FROM sorted_bonds
 GROUP BY Year, Name_of_the_Purchaser, Name_of_the_Political_Party
 ORDER BY Year, Total_Denomination DESCENDING;
QUIT;
DATA top_companies;
 SET top_companies;
 BY Year;
 IF FIRST.Year THEN Rank=1;
 ELSE Rank+1;
 IF Rank <= 5;
RUN;
PROC PRINT DATA=top_companies NOOBS label;
 BY Year;
 VAR Rank Name_of_the_Purchaser Name_of_the_Political_Party Total_Denomination;
 TITLE "Year-wise Top 5 Purchasing Companies and Redeeming Political Parties";
 format Total_Denomination INR_FORMAT.;
RUN;

PROC SORT DATA=WORK.WorkingCOMBINE OUT=sorted_bonds;
 BY Year DenomNumeric DESCENDING Name_of_the_Purchaser;
RUN; 
PROC SQL;
 CREATE TABLE party_report AS
 SELECT 
 Name_of_the_Political_Party,
 Name_of_the_Purchaser,
 SUM(DenomNumeric) AS Total_Denomination
 FROM WORK.WorkingCOMBINE
 GROUP BY Name_of_the_Political_Party, Name_of_the_Purchaser
 ORDER BY Name_of_the_Political_Party, Total_Denomination DESCENDING;
QUIT;
PROC PRINT DATA=party_report NOOBS label;
 BY Name_of_the_Political_Party;
 VAR Name_of_the_Purchaser Total_Denomination;
 TITLE "Total Denominations and Associated Companies for Each Redeeming Political 
Party";
 format Total_Denomination INR_FORMAT.;
RUN;

*Rename WORK.BRANCH_CODE_TO_BRANCH_NAME fields;
proc sql;
 create table most_issuing_branch as
 select t1.Issue_Branch_Code as Branch_Code, 
 t2.Branch_Name, 
 count(*) as Total_Count, 
 sum(input(compress(t1.Denominations, ','), comma20.)) as 
Total_Denominations
 from WORK.PURCHASER_COMP_ALL_COLS t1 
 left join WORK.BRANCH_CODE_TO_BRANCH_NAME t2
 on t1.Issue_Branch_Code = t2.Branch_Code
 group by t1.Issue_Branch_Code, t2.Branch_Name
 order by Total_Count desc;
quit;
title "Most Issuing SBI Branches Report";
proc print data=most_issuing_branch label noobs;
label Total_Denominations ="Worth of Bonds Issued" Total_Count="No. of Bonds 
Issued" Branch_Code="Branch Code";
format Total_Denominations INR_FORMAT.;
id Branch_Code;
run;

*Rename WORK.BRANCH_CODE_TO_BRANCH_NAME fields;
proc sql;
create table most_issuing_branch as
select t1.Pay_Branch_Code as Branch_Code,
 t2.Branch_Name,
 count(*) as Total_Count,
 sum(input(compress(t1.Denominations, ','), comma20.)) as 
Total_Denominations
from WORK.REDEEMER_PARTY_ALL_COLS t1 
left join WORK.BRANCH_CODE_TO_BRANCH_NAME t2
on t1.Pay_Branch_Code = t2.Branch_Code
group by t1.Pay_Branch_Code, t2.Branch_Name
order by Total_Count desc;
quit;
title "SBI Branches with most Bonds Redeemed Report";
proc print data=most_issuing_branch label noobs;
label Total_Denominations ="Worth of Bonds Redeemed" Total_Count="No. of 
Bonds Redeemed" Branch_Code="Branch Code";
format Total_Denominations INR_FORMAT.;
id Branch_Code;
run;




