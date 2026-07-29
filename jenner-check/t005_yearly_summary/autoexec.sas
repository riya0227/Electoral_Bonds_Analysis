options obs=100;  /* cap input rows for the captured run */

/* The upstream script imports Reedemer_Party_All_Cols.xlsx, where an xlsx date
   column arrives as a real SAS date. This autoexec stands up WORK.reedemer with
   the same columns the author reads, with Date_of_Encashment as a genuine SAS
   date (read via yymmdd10.) so the author's year(Date_of_Encashment) works as it
   does on the real workbook. Values are a representative sample of the redeemer
   data spanning the 2019-2021 encashment window. */
data reedemer;
  length Name_of_the_Political_Party $55 Denominations $12;
  infile datalines dsd truncover;
  input Sr_No Date_of_Encashment :yymmdd10. Name_of_the_Political_Party :$55.
        Denominations :$12. Pay_Branch_Code;
  format Date_of_Encashment yymmdd10.;
  datalines;
1,2019-04-12,BHARATIYA JANATA PARTY,"1,00,00,000",800
2,2019-04-15,BHARATIYA JANATA PARTY,"1,00,00,000",41
3,2019-04-16,BHARATIYA JANATA PARTY,"10,00,000",1
4,2020-03-10,BHARATIYA JANATA PARTY,"1,00,00,000",300
5,2020-09-26,ALL INDIA TRINAMOOL CONGRESS,"1,00,00,000",152
6,2019-04-20,ALL INDIA TRINAMOOL CONGRESS,"10,00,000",800
7,2021-04-14,ALL INDIA TRINAMOOL CONGRESS,"1,00,00,000",41
8,2019-05-06,"PRESIDENT, ALL INDIA CONGRESS COMMITTEE","1,00,00,000",300
9,2021-05-04,"PRESIDENT, ALL INDIA CONGRESS COMMITTEE","10,00,000",1
10,2019-05-15,BHARAT RASHTRA SAMITHI,"1,00,00,000",125
11,2020-06-18,BHARAT RASHTRA SAMITHI,"1,00,00,000",41
12,2019-08-23,DRAVIDA MUNNETRA KAZHAGAM (DMK),"1,00,00,000",800
13,2021-01-04,BIJU JANATA DAL,"10,00,000",509
14,2019-12-01,AAM AADMI PARTY,"1,00,000",167
15,2021-07-23,ALL INDIA ANNA DRAVIDA MUNNETRA KAZHAGAM,"1,00,00,000",800
;
run;
