*Importing the dataset;

FILENAME REFFILE '/folders/myfolders/Walmart_Store_sales.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

*Creating PROC MEANS ON DATASET FOR DATA ANALYSIS QUARTER AND MONTH WISE;

PROC MEANS DATA = IMPORT

MEAN STDDEV MIN MAX;

VAR Weekly_Sales;
CLASS Month;
CLASS Quarter;
CLASS STORE;

QUIT;

* Viewing the dataset;

PROC SQL; 
SELECT * FROM IMPORT;
QUIT;

* Creating an output from PROC MEANS STATEMENT;

PROC MEANS DATA = IMPORT MEAN STDDEV;
VAR Weekly_Sales;
Class Store;
OUTPUT OUT = Statistical_data;
RUN;

* Filtering the table created to view only std.deviation data;

PROC SQL;
CREATE TABLE Statistical_table1 AS
SELECT Store, Weekly_Sales as Std_dev from Statistical_data where
Store >= 1 and _STAT_ = "STD";
QUIT;

* Store is set to >1 as null values were present in the proc mean table to
PROC SQL Table conversion hence it was removed;

* Selection of Maximum Std.dev;

PROC SQL;
SELECT STORE, Std_dev from Statistical_table1 where Std_dev =
(SELECT MAX(Std_dev) from Statistical_table1);

QUIT;

* Selection of mean statistical measure from the dataset;

PROC SQL;
CREATE TABLE Statistical_table2 AS
SELECT Store, Weekly_Sales as Mean from Statistical_data where
Store >= 1 and _STAT_ = "MEAN";
QUIT;

* Creating the final table;

PROC SQL;

CREATE TABLE Final_stat as

SELECT Statistical_table1.Store, Statistical_table2.Mean, Statistical_table1.Std_dev
from Statistical_table1 Inner join 
Statistical_table2 on Statistical_table1.Store = Statistical_table2.Store;

QUIT;









