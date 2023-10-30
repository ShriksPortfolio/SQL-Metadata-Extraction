/*
	RUN SECTION ONE TO CREATE A TABLE FOR THIS EXAMPLE
*/

USE AdventureWorks2016;
IF OBJECT_ID('TempDB.dbo.#CustomerRevenueByTransactionType') IS NOT NULL
DROP TABLE #CustomerRevenueByTransactionType

CREATE TABLE #CustomerRevenueByTransactionType([FactDate] Date null, CustomerName varchar(50) null, TransactionType varchar(20), NetAmount int null)
INSERT INTO #CustomerRevenueByTransactionType (FactDate, CustomerName, TransactionType, NetAmount)

VALUES 
	('5/2/2016', 'Devin Knight', 'Voice', 22),
	('5/2/2016', 'Devin Knight', 'Data', 41),
	('5/2/2016', 'Devin Knight', 'SMS', 33),
	('5/2/2016', 'Dustin Ryan', 'SMS', 10),
	('5/2/2016', 'Dustin Ryan', 'Data', 21),
	('5/2/2016', 'Mitchell Pearson', 'Voice',20),
	('5/2/2016', 'Mitchell Pearson', 'SMS', 7),	
	('5/1/2016', 'Mitchell Pearson', 'Voice', 27),
	('5/1/2016', 'Mitchell Pearson', 'Data', 45),
	('5/1/2016', 'Mitchell Pearson', 'SMS', 31),
	('5/1/2016', 'Dustin Ryan', 'Voice', 10),
	('5/1/2016', 'Dustin Ryan', 'Data', 22),
	('5/1/2016', 'Devin Knight', 'Data', 13),
	('5/1/2016', 'Devin Knight', 'SMS', 9)

-- SHOW DATA
SELECT * FROM #CustomerRevenueByTransactionType

-- PIVOT THE DATA
SELECT 
	FactDate, 
	CustomerName, 
	COALESCE(Voice, 0.0000) Net_Voice,  
	COALESCE(Data, 0.0000) Net_Data, 
	COALESCE(SMS, 0.0000) Net_SMS

FROM #CustomerRevenueByTransactionType
PIVOT
	(
		SUM(NetAmount)
		FOR TransactionType IN (Voice, Data, SMS)
	)AS pvt
