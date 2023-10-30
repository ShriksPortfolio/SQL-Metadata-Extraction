/*
	EXCEPT - Set operator
*/ 

-- DEMO 1
-- Note that when using SET operators all queries must have an equal number of expressions
-- in their target lists.

USE Adventureworks2016;
SELECT 'UK', NULL, 'LONDON'
EXCEPT
SELECT 'UK', NULL, 'LONDON'--, 'test'

-- EXCEPT is the only set operator that is asymetrical.
-- No results are returned.

SELECT 'UK', NULL, 'LONDON'
EXCEPT
(
 SELECT 'UK', NULL, 'LONDON' 
 UNION ALL
 SELECT 'USA', NULL, 'NEW YORK' 
)

-- NOW DEMO THE OPPOSITE ORDER
-- USA is returned.

SELECT 'UK', NULL, 'LONDON' 
	UNION ALL
SELECT 'USA', NULL, 'NEW YORK' 
	EXCEPT
SELECT 'UK', NULL, 'LONDON'

-- DEMO 2
-- EASY METHOD FOR FINDING CUSTOMERS OR PRODUCTS NOT SOLD.
USE AdventureworksDW2016;

SELECT ProductKey
FROM DimProduct
	EXCEPT
SELECT ProductKey
FROM FactInternetSales

-- DEMO 3
-- CONTROL TABLE EXAMPLE
USE AdventureWorks2016; 

DECLARE @StartDate AS DATE = DATEADD(DD, -9, GETDATE())

-- Recursive CTE used to generate a list of dates.
;WITH DatesToProcess as (

	SELECT @StartDate AS ProcessDate
		UNION ALL
	SELECT DATEADD(DD, 1, ProcessDate) AS ProcessDate
	FROM   DatesToProcess
	WHERE  ProcessDate <= getdate() - 1
	)

SELECT 
	CONVERT(DATE, ProcessDate) as DatesToProcess
FROM
	DatesToProcess

	EXCEPT -- exclude dates that have already been procesed and exists in the ControlTable

SELECT 
	Date 
FROM
	dbo.ControlTable_Module04
