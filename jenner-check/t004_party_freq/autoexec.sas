options obs=100;  /* cap input rows for the captured run */

/* The upstream script imports Reedemer_Party_All_Cols.xlsx from a SAS Studio
   home path. This autoexec stands up WORK.reedemer with the same columns the
   author reads (Name_of_the_Political_Party, Denominations, Date_of_Encashment,
   Pay_Branch_Code), populated with a small representative sample of the real
   redeemer workbook. Date_of_Encashment is an Excel serial, matching the
   source; the author later applies year() to it. */
data reedemer;
  length Name_of_the_Political_Party $55 Denominations $12;
  infile datalines dsd truncover;
  input Sr_No Date_of_Encashment Name_of_the_Political_Party :$55.
        Denominations :$12. Pay_Branch_Code;
  datalines;
1,43567,BHARATIYA JANATA PARTY,"1,00,00,000",800
2,43570,BHARATIYA JANATA PARTY,"1,00,00,000",41
3,43571,BHARATIYA JANATA PARTY,"10,00,000",1
4,43900,BHARATIYA JANATA PARTY,"1,00,00,000",300
5,44100,ALL INDIA TRINAMOOL CONGRESS,"1,00,00,000",152
6,43575,ALL INDIA TRINAMOOL CONGRESS,"10,00,000",800
7,44300,ALL INDIA TRINAMOOL CONGRESS,"1,00,00,000",41
8,43591,"PRESIDENT, ALL INDIA CONGRESS COMMITTEE","1,00,00,000",300
9,44320,"PRESIDENT, ALL INDIA CONGRESS COMMITTEE","10,00,000",1
10,43600,BHARAT RASHTRA SAMITHI,"1,00,00,000",125
11,44000,BHARAT RASHTRA SAMITHI,"1,00,00,000",41
12,43700,DRAVIDA MUNNETRA KAZHAGAM (DMK),"1,00,00,000",800
13,44200,BIJU JANATA DAL,"10,00,000",509
14,43800,AAM AADMI PARTY,"1,00,000",167
15,44400,ALL INDIA ANNA DRAVIDA MUNNETRA KAZHAGAM,"1,00,00,000",800
;
run;
