-- SETUP Table for following example.
USE AdventureWorks2016;
IF OBJECT_ID('TempDB.dbo.#CustomerRevenueByTransactionType2') IS NOT NULL
DROP TABLE #CustomerRevenueByTransactionType2

CREATE TABLE #CustomerRevenueByTransactionType2
	([FactDate] Date null, CustomerName varchar(50) null 
	,TransactionType varchar(20), NetAmount int null 
	,UsageType varchar(20) NULL, NetUsage int NULL)
INSERT INTO #CustomerRevenueByTransactionType2 
	(FactDate, CustomerName, TransactionType, NetAmount, UsageType, NetUsage)

VALUES 
	('5/2/2016', 'Devin Knight',		'Voice', 22, 'Minutes',    5),
	('5/2/2016', 'Devin Knight',		'Data',  41, 'Bytes',	1028),
	('5/2/2016', 'Devin Knight',		'SMS',   33, 'Texts',	   4),
	('5/2/2016', 'Dustin Ryan',			'SMS',   10, 'Texts',	   4),
	('5/2/2016', 'Dustin Ryan',			'Data',  21, 'Bytes',	1028),
	('5/2/2016', 'Mitchell Pearson',	'Voice', 20, 'Minutes',    5),
	('5/2/2016', 'Mitchell Pearson',	'SMS',    7, 'Texts',	   4),	
	('5/1/2016', 'Mitchell Pearson',	'Voice', 27, 'Minutes',    5),
	('5/1/2016', 'Mitchell Pearson',	'Data',  45, 'Bytes',	1028),
	('5/1/2016', 'Mitchell Pearson',	'SMS',   31, 'Texts',	   4),
	('5/1/2016', 'Dustin Ryan',			'Voice', 10, 'Minutes',    5),
	('5/1/2016', 'Dustin Ryan',			'Data',  22, 'Bytes',	1028),
	('5/1/2016', 'Devin Knight',		'Data',  13, 'Bytes',	1028),
	('5/1/2016', 'Devin Knight',		'SMS',    9, 'Texts',	   4)


-- SHOW THE DATA
SELECT * FROM #CustomerRevenueByTransactionType2

-- DEMO 1 - PIVOTING DATA
-- COALESCE - Required to replace NULLS when a customer doesn't have that usage type.

SELECT 
	FactDate, 
	CustomerName, 
	MAX(COALESCE(Voice,		0.0000)) Net_Voice,  
	MAX(COALESCE(Data,		0.0000)) Net_Data, 
	MAX(COALESCE([SMS],		0.0000)) Net_SMS,
	MAX(COALESCE([Minutes], 0.0000))Net_Minutes,  
	MAX(COALESCE(Bytes,		0.0000)) Net_Bytes, 
	MAX(COALESCE(Texts,		0.0000)) Net_Texts

FROM #CustomerRevenueByTransactionType2
PIVOT
	(
		SUM(NetAmount)
		FOR TransactionType IN (Voice, Data, SMS)
		
	)AS pvt1 
PIVOT
(
	SUM(NetUsage)
	FOR UsageType IN ([Minutes], [Bytes], [Texts])
)AS pvt2
GROUP BY
	FactDate, CustomerName

