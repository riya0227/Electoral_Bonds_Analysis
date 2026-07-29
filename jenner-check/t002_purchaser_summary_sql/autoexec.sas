options obs=100;  /* cap input rows for the captured run */

/* The upstream script imports Purchaser_Comp_All_Cols.xlsx from a SAS Studio
   home path (/home/u63714413/Riya/...). To make the analysis self-contained,
   this autoexec stands up WORK.mydata with the same columns the author reads
   (Name_of_the_Purchaser, Denominations, Issue_Branch_Code, Date_of_Purchase),
   populated with a small representative sample of the real purchaser workbook. */
data mydata;
  length Name_of_the_Purchaser $45 Denominations $12;
  infile datalines dsd truncover;
  input Sr_No Name_of_the_Purchaser :$45. Denominations :$12.
        Issue_Branch_Code Date_of_Purchase;
  datalines;
1,FUTURE GAMING AND HOTEL SERVICES PR,"1,00,00,000",800,43567
2,FUTURE GAMING AND HOTEL SERVICES PR,"1,00,00,000",800,43570
3,FUTURE GAMING AND HOTEL SERVICES PR,"10,00,000",800,43571
4,FUTURE GAMING AND HOTEL SERVICES PR,"1,00,00,000",300,43572
5,MEGHA ENGINEERING AND INFRASTRUCTURES LIMITED,"1,00,00,000",41,43573
6,MEGHA ENGINEERING AND INFRASTRUCTURES LIMITED,"1,00,00,000",41,43575
7,MEGHA ENGINEERING AND INFRASTRUCTURES LIMITED,"10,00,000",41,43591
8,QWIKSUPPLYCHAINPRIVATELIMITED,"1,00,00,000",1,43592
9,QWIKSUPPLYCHAINPRIVATELIMITED,"1,00,00,000",1,43593
10,HALDIA ENERGY LIMITED,"1,00,00,000",300,43594
11,HALDIA ENERGY LIMITED,"10,00,000",300,43567
12,VEDANTA LIMITED,"10,00,000",41,43570
13,VEDANTA LIMITED,"1,00,000",41,43571
14,A B C INDIA LIMITED,"10,00,000",1,43567
15,A B C INDIA LIMITED,"1,00,000",1,43567
16,MKJ ENTERPRISES LIMITED,"10,00,000",125,43575
17,ESSEL MINING AND INDS LTD,"1,00,00,000",152,43591
;
run;
