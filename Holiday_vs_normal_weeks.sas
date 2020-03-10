* Code to implement the Holiday vs Non-holiday weekends comparison;

* Loading the original dataset in SAS;

FILENAME REFFILE '/folders/myfolders/Walmart_Store_sales.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

* Creating Seperate Datasets for Holiday and Non-holiday rows;


PROC SQL;

CREATE TABLE Non_Holiday AS
SELECT * FROM IMPORT Where Holiday_Flag = 0;

RUN;

PROC SQL;

CREATE TABLE Holiday AS
SELECT * FROM IMPORT Where Holiday_Flag = 1;

RUN;

* Creating table for average of sales and merging them together;


PROC SQL;

CREATE TABLE NonHoliday as
SELECT Store, AVG(Weekly_Sales) as Non_holiday_sum from Non_Holiday
GROUP BY Store;

QUIT;

PROC SQL;

CREATE TABLE HolidayDay as
SELECT Store, AVG(Weekly_Sales) as Holiday_sum from Holiday
GROUP BY Store;

QUIT;

PROC SQL;

CREATE TABLE Comparison as 
Select NonHoliday.Store, HolidayDay.Holiday_sum, NonHoliday.Non_holiday_sum from NonHoliday
Inner Join HolidayDay on HolidayDay.Store = NonHoliday.Store;

RUN;

* Creating a table for Calulated column for difference between sales;

PROC SQL;

CREATE TABLE Tabular as
SELECT Store, (Holiday_sum - Non_holiday_sum) as FinalSales from Comparison;

RUN;


* Viewing the stores with poor holiday performance;

PROC SQL;
SELECT * FROM Tabular where FinalSales < 0;
RUN;


