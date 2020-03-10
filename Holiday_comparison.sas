*Importing the dataset;

FILENAME REFFILE '/folders/myfolders/Walmart_Store_sales.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

*Viewing the contents of the dataset;

PROC SQL;
SELECT * from IMPORT;
RUN;

* Using PROC MEANS to view the data summary;

PROC MEANS DATA = IMPORT;
VAR Weekly_Sales;
CLASS Store;
CLASS Holiday_Type;
QUIT;

* Filtering the non holiday data where the data is seperated only for months that 
contained a holiday;

PROC SQL;

CREATE TABLE Non_Holiday AS
SELECT STORE, MONTH, AVG(Weekly_Sales) as Non_Holiday_average 
FROM IMPORT Where Holiday_Flag = 0 and Month in('February','Septembe','November','December')
Group by STORE, MONTH;

RUN;

* Filtering the holiday data where the data is seperated only for months that 
contained a holiday;

PROC SQL;

CREATE TABLE Holiday AS
SELECT STORE, MONTH, AVG(Weekly_Sales) as Holiday_average 
FROM IMPORT Where Holiday_Flag = 1 and Month in('February','Septembe','November','December')
Group by STORE, MONTH;

RUN;

* Combining both the datasets together using one to one reading method;

DATA Sales_figure;
SET Non_holiday;
SET Holiday;

RUN;

* Creating a calculated column for Holiday sales - Non Holiday Sales;

PROC SQL;

CREATE TABLE Final_Sales AS
SELECT *, (Holiday_average - Non_Holiday_average) as Final_Sale from Sales_figure;

RUN;

* Analyzing the holiday sales and non-holiday sales using PROC MEANS;

PROC MEANS DATA = Final_Sales;

VAR Final_Sale;
Class Month;
Class Store;

QUIT;

PROC MEANS DATA = Final_Sales;

VAR Final_Sale;
Class Month;

QUIT;



* Filtering the dataset to contain positive values only where holiday sales > non-holiday;

PROC SQL;

CREATE TABLE Positive_Sales AS
SELECT * FROM Final_Sales where Final_Sale > 0;

RUN;

* Analyzing the obtained dataset;

PROC MEANS DATA = Positive_Sales;

VAR Final_Sale;
Class Month;
Class Store;

QUIT;

PROC MEANS DATA = Positive_Sales;

VAR Final_Sale;
Class Month;

QUIT;









